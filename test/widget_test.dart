import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gomitra/main.dart';
import 'package:gomitra/models.dart';
import 'package:gomitra/services/local_store.dart';
import 'package:gomitra/services/matching.dart';

void main() {
  testWidgets('demo flow creates a local group and sends a message',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = _MemoryStore();
    await tester.pumpWidget(GoMitraApp(store: store));
    expect(
      find.text('Shared Rides.\nLower Costs.\nBetter Journeys.'),
      findsOneWidget,
    );

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();
    expect(find.text('Find Travellers\nGoing Your Way'), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continue as Demo'));
    await tester.pump();
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('chip-Thane')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('chip-Thane')));
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('Find Travel Companions'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Find Travel Companions'));
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('People going to Thane'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('match-1')));
    await tester.pumpAndSettle();
    expect(find.text('Create Group & Share Ride (2)'), findsOneWidget);
    await tester.tap(find.text('Create Group & Share Ride (2)'));
    await tester.pumpAndSettle();

    expect(find.text('Meeting Point'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Confirm Group & Meeting Point'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Confirm Group & Meeting Point'));
    await tester.pumpAndSettle(const Duration(seconds: 1));
    expect(store.trips, hasLength(1));

    await tester.scrollUntilVisible(
      find.text('Chat in Group'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Chat in Group'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IconButton>(
            find.ancestor(
              of: find.byTooltip('Send message'),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNull,
    );
    await tester.enterText(
      find.byType(EditableText).last,
      'Meet at the public area.',
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<IconButton>(
            find.ancestor(
              of: find.byTooltip('Send message'),
              matching: find.byType(IconButton),
            ),
          )
          .onPressed,
      isNotNull,
    );
    await tester.tap(find.byTooltip('Send message'));
    await tester.pumpAndSettle();
    expect(find.text('Meet at the public area.'), findsOneWidget);
    expect(store.trips, hasLength(1));

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Leave group'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Leave group').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Leave group').last);
    await tester.pumpAndSettle();
    expect(store.trips.single.status, 'Cancelled');
    await expectLater(
      store.sendMessage(1, 'This should not send.'),
      throwsStateError,
    );
  });

  test('exact destination match is ranked before a nearby destination',
      () async {
    final store = _MemoryStore();
    final matches = await store.findMatches('Thane');
    expect(matches.first.destination, 'Thane');
    expect(matches.first.name, 'Aryan K.');
  });

  test('chat rejects blank and overlong messages', () {
    expect(messageValidationError('   '), 'Message cannot be empty.');
    expect(messageValidationError('ok'), isNull);
    expect(messageValidationError(List.filled(501, 'x').join()), isNotNull);
  });

  testWidgets('sign-up preview validates fields without creating an account',
      (tester) async {
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(GoMitraApp(store: _MemoryStore()));

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Don\'t have an account? Create one'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('create-account-submit')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('create-account-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Enter a display name.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'Demo Traveller');
    await tester.enterText(find.byType(TextFormField).at(1), 'demo_user');
    await tester.enterText(find.byType(TextFormField).at(2), 'demo@example.com');
    await tester.enterText(find.byType(TextFormField).at(3), '9876543210');
    await tester.enterText(find.byType(TextFormField).at(4), 'sample-pass-123');
    await tester.ensureVisible(find.byType(CheckboxListTile));
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('create-account-submit')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const ValueKey('create-account-submit')));
    await tester.pumpAndSettle();
    expect(find.text('Demo Account created successfully! Logged in as traveller.'), findsOneWidget);
  });
}

class _MemoryStore implements LocalStore {
  final List<Trip> trips = [];
  final List<ChatMessage> messages = [];
  bool _onboardingCompleted = false;

  @override
  Future<bool> isOnboardingCompleted() async => _onboardingCompleted;

  @override
  Future<void> setOnboardingCompleted(bool value) async {
    _onboardingCompleted = value;
  }

  @override
  Future<List<Passenger>> findMatches(String destination, {String terminal = 'T2'}) async {
    final matches = [
      const Passenger(
        id: 1,
        name: 'Aryan K.',
        initials: 'AK',
        destination: 'Thane',
        area: 'Going to Thane Station',
        departureMinutes: 20,
        matchReason: 'Same destination',
        detourMinutes: 0,
      ),
      const Passenger(
        id: 2,
        name: 'Riya S.',
        initials: 'RS',
        destination: 'Mulund',
        area: 'Going to Mulund West',
        departureMinutes: 30,
        matchReason: 'Nearby destination',
        detourMinutes: 18,
      ),
    ];
    return rankPassengers(matches, destination, terminal: terminal);
  }

  @override
  Future<int> createTrip({
    required String terminal,
    required String destination,
    required List<String> members,
    required String meetingPoint,
  }) async {
    final id = trips.length + 1;
    trips.add(
      Trip(
        id: id,
        terminal: terminal,
        destination: destination,
        members: members,
        meetingPoint: meetingPoint,
        status: 'Upcoming',
        createdAt: DateTime.now(),
      ),
    );
    return id;
  }

  @override
  Future<void> leaveTrip(int tripId) async {
    final index = trips.indexWhere((trip) => trip.id == tripId);
    if (index == -1 || trips[index].status != 'Upcoming') {
      throw StateError('This demo group is no longer active.');
    }
    final trip = trips[index];
    trips[index] = Trip(
      id: trip.id,
      terminal: trip.terminal,
      destination: trip.destination,
      members: trip.members,
      meetingPoint: trip.meetingPoint,
      status: 'Cancelled',
      createdAt: trip.createdAt,
    );
  }

  @override
  Future<List<Trip>> getTrips() async => List.unmodifiable(trips.reversed);

  @override
  Future<List<ChatMessage>> getMessages(int tripId) async =>
      messages.where((message) => message.tripId == tripId).toList();

  @override
  Future<void> sendMessage(int tripId, String body) async {
    if (!trips.any((trip) => trip.id == tripId && trip.status == 'Upcoming')) {
      throw StateError('This group is no longer active.');
    }
    final validationError = messageValidationError(body);
    if (validationError != null) {
      throw ArgumentError.value(body, 'body', validationError);
    }
    messages.add(
      ChatMessage(
        id: messages.length + 1,
        tripId: tripId,
        sender: 'You',
        body: body.trim(),
        createdAt: DateTime.now(),
        isMine: true,
      ),
    );
  }
}
