import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models.dart';
import 'matching.dart';

abstract interface class LocalStore {
  Future<List<Passenger>> findMatches(String destination, {String terminal = 'T2'});
  Future<int> createTrip({
    required String terminal,
    required String destination,
    required List<String> members,
    required String meetingPoint,
  });
  Future<void> leaveTrip(int tripId);
  Future<List<Trip>> getTrips();
  Future<List<ChatMessage>> getMessages(int tripId);
  Future<void> sendMessage(int tripId, String body);
  Future<bool> isOnboardingCompleted();
  Future<void> setOnboardingCompleted(bool value);
}

class SqliteStore implements LocalStore {
  SqliteStore._(this._db, this._prefs);

  final Database _db;
  final SharedPreferences _prefs;

  static Future<SqliteStore> open() async {
    final databasePath = await getDatabasesPath();
    final prefs = await SharedPreferences.getInstance();
    final db = await openDatabase(
      p.join(databasePath, 'gomitra_local.db'),
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE passengers(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            initials TEXT NOT NULL,
            destination TEXT NOT NULL,
            area TEXT NOT NULL,
            departure_minutes INTEGER NOT NULL,
            match_reason TEXT NOT NULL,
            detour_minutes INTEGER NOT NULL,
            match_percentage INTEGER NOT NULL DEFAULT 90
          )
        ''');
        await db.execute('''
          CREATE TABLE trips(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            terminal TEXT NOT NULL,
            destination TEXT NOT NULL,
            meeting_point TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE group_members(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trip_id INTEGER NOT NULL,
            display_name TEXT NOT NULL,
            role TEXT NOT NULL CHECK(role IN ('organizer', 'member')),
            FOREIGN KEY(trip_id) REFERENCES trips(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('CREATE INDEX group_members_trip_id ON group_members(trip_id)');
        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            trip_id INTEGER NOT NULL,
            sender TEXT NOT NULL,
            body TEXT NOT NULL,
            created_at TEXT NOT NULL,
            is_mine INTEGER NOT NULL,
            FOREIGN KEY(trip_id) REFERENCES trips(id) ON DELETE CASCADE
          )
        ''');
        await db.execute('CREATE INDEX messages_trip_id ON messages(trip_id)');
        final batch = db.batch();
        for (final passenger in demoPassengers) {
          batch.insert('passengers', passenger);
        }
        await batch.commit(noResult: true);
      },
    );
    return SqliteStore._(db, prefs);
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    return _prefs.getBool('onboarding_completed') ?? false;
  }

  @override
  Future<void> setOnboardingCompleted(bool value) async {
    await _prefs.setBool('onboarding_completed', value);
  }

  @override
  Future<List<Passenger>> findMatches(String destination, {String terminal = 'T2'}) async {
    final rows = await _db.query('passengers');
    final list = rows.map(_passengerFromRow);
    return rankPassengers(list, destination, terminal: terminal);
  }

  @override
  Future<int> createTrip({
    required String terminal,
    required String destination,
    required List<String> members,
    required String meetingPoint,
  }) async {
    final cleanMembers = members.map((member) => member.trim()).toSet();
    if (cleanMembers.isEmpty || cleanMembers.any((member) => member.isEmpty)) {
      throw ArgumentError.value(members, 'members', 'Select at least one traveller.');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    return _db.transaction((txn) async {
      final tripId = await txn.insert('trips', {
        'terminal': terminal,
        'destination': destination,
        'meeting_point': meetingPoint,
        'status': 'Upcoming',
        'created_at': now,
      });
      await txn.insert('group_members', {
        'trip_id': tripId,
        'display_name': 'You',
        'role': 'organizer',
      });
      for (final member in cleanMembers) {
        await txn.insert('group_members', {
          'trip_id': tripId,
          'display_name': member,
          'role': 'member',
        });
      }
      final nowTime = DateTime.now().toUtc();
      if (cleanMembers.contains('Aryan K.')) {
        await txn.insert('messages', {
          'trip_id': tripId,
          'sender': 'Aryan K.',
          'body': 'I\'ll reach Gate A in 5 mins',
          'created_at': nowTime.subtract(const Duration(minutes: 6)).toIso8601String(),
          'is_mine': 0,
        });
      }
      if (cleanMembers.contains('Riya S.')) {
        await txn.insert('messages', {
          'trip_id': tripId,
          'sender': 'Riya S.',
          'body': 'Same here, I\'m near the exit',
          'created_at': nowTime.subtract(const Duration(minutes: 4)).toIso8601String(),
          'is_mine': 0,
        });
      }
      await txn.insert('messages', {
        'trip_id': tripId,
        'sender': 'You',
        'body': 'I\'m at Gate A, wearing a black backpack.',
        'created_at': nowTime.subtract(const Duration(minutes: 2)).toIso8601String(),
        'is_mine': 1,
      });
      if (cleanMembers.length > 1) {
        await txn.insert('messages', {
          'trip_id': tripId,
          'sender': cleanMembers.last,
          'body': 'Perfect, see you there!',
          'created_at': nowTime.toIso8601String(),
          'is_mine': 0,
        });
      }
      return tripId;
    });
  }

  @override
  Future<void> leaveTrip(int tripId) async {
    final updated = await _db.update(
      'trips',
      {'status': 'Cancelled'},
      where: 'id = ? AND status = ?',
      whereArgs: [tripId, 'Upcoming'],
    );
    if (updated != 1) {
      throw StateError('This demo group is no longer active.');
    }
  }

  @override
  Future<List<Trip>> getTrips() async {
    final rows = await _db.query('trips', orderBy: 'created_at DESC');
    final memberRows = await _db.query(
      'group_members',
      where: "role = 'member'",
      orderBy: 'id ASC',
    );
    final membersByTrip = <int, List<String>>{};
    for (final row in memberRows) {
      membersByTrip
          .putIfAbsent(row['trip_id'] as int, () => [])
          .add(row['display_name'] as String);
    }
    return rows.map((row) {
      return Trip(
        id: row['id'] as int,
        terminal: row['terminal'] as String,
        destination: row['destination'] as String,
        members: membersByTrip[row['id'] as int] ?? const [],
        meetingPoint: row['meeting_point'] as String,
        status: row['status'] as String,
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
      );
    }).toList();
  }

  @override
  Future<List<ChatMessage>> getMessages(int tripId) async {
    final rows = await _db.query(
      'messages',
      where: 'trip_id = ?',
      whereArgs: [tripId],
      orderBy: 'created_at ASC, id ASC',
    );
    return rows.map((row) {
      return ChatMessage(
        id: row['id'] as int,
        tripId: row['trip_id'] as int,
        sender: row['sender'] as String,
        body: row['body'] as String,
        createdAt: DateTime.parse(row['created_at'] as String).toLocal(),
        isMine: row['is_mine'] == 1,
      );
    }).toList();
  }

  @override
  Future<void> sendMessage(int tripId, String body) async {
    final cleanBody = body.trim();
    final error = messageValidationError(cleanBody);
    if (error != null) {
      throw ArgumentError.value(body, 'body', error);
    }
    await _db.transaction((txn) async {
      final activeTrip = await txn.query(
        'trips',
        columns: ['id'],
        where: 'id = ? AND status = ?',
        whereArgs: [tripId, 'Upcoming'],
        limit: 1,
      );
      if (activeTrip.isEmpty) {
        throw StateError('This group is no longer active.');
      }
      await txn.insert('messages', {
        'trip_id': tripId,
        'sender': 'You',
        'body': cleanBody,
        'created_at': DateTime.now().toUtc().toIso8601String(),
        'is_mine': 1,
      });
    });
  }

  Passenger _passengerFromRow(Map<String, Object?> row) => Passenger(
        id: row['id'] as int,
        name: row['name'] as String,
        initials: row['initials'] as String,
        destination: row['destination'] as String,
        area: row['area'] as String,
        departureMinutes: row['departure_minutes'] as int,
        matchReason: row['match_reason'] as String,
        detourMinutes: row['detour_minutes'] as int,
        matchPercentage: row['match_percentage'] as int? ?? 90,
      );
}

final demoPassengers = <Map<String, Object>>[
  {
    'id': 1,
    'name': 'Aryan K.',
    'initials': 'AK',
    'destination': 'Thane',
    'area': 'Going to Thane',
    'departure_minutes': 20,
    'match_reason': 'In 20 mins',
    'detour_minutes': 0,
    'match_percentage': 95,
  },
  {
    'id': 2,
    'name': 'Riya S.',
    'initials': 'RS',
    'destination': 'Thane',
    'area': 'Going to Thane (Majiwada)',
    'departure_minutes': 25,
    'match_reason': 'In 25 mins',
    'detour_minutes': 8,
    'match_percentage': 90,
  },
  {
    'id': 3,
    'name': 'Karan P.',
    'initials': 'KP',
    'destination': 'Mulund',
    'area': 'Going to Mulund (Nearby)',
    'departure_minutes': 30,
    'match_reason': 'In 30 mins',
    'detour_minutes': 18,
    'match_percentage': 85,
  },
  {
    'id': 4,
    'name': 'Neha T.',
    'initials': 'NT',
    'destination': 'Thane',
    'area': 'Going to Thane',
    'departure_minutes': 35,
    'match_reason': 'In 35 mins',
    'detour_minutes': 27,
    'match_percentage': 90,
  },
  {
    'id': 5,
    'name': 'Dev M.',
    'initials': 'DM',
    'destination': 'Powai',
    'area': 'Going to Powai Lake',
    'departure_minutes': 45,
    'match_reason': 'In 45 mins',
    'detour_minutes': 31,
    'match_percentage': 88,
  },
];
