import 'package:flutter/material.dart';

import '../models.dart';
import '../services/local_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

class FindingMatchesScreen extends StatefulWidget {
  const FindingMatchesScreen({
    required this.store,
    required this.terminal,
    required this.destination,
    required this.onCreateGroup,
    super.key,
  });

  final LocalStore store;
  final String terminal;
  final String destination;
  final ValueChanged<List<String>> onCreateGroup;

  @override
  State<FindingMatchesScreen> createState() => _FindingMatchesScreenState();
}

class _FindingMatchesScreenState extends State<FindingMatchesScreen> with SingleTickerProviderStateMixin {
  late AnimationController _radarController;

  @override
  void initState() {
    super.initState();
    _radarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(
            builder: (_) => MatchResultsScreen(
              store: widget.store,
              terminal: widget.terminal,
              destination: widget.destination,
              onCreateGroup: widget.onCreateGroup,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _radarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoMitraColors.ink,
      appBar: AppBar(
        backgroundColor: GoMitraColors.ink,
        foregroundColor: Colors.white,
        title: const Text('Finding Your Mitra', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AnimatedBuilder(
                animation: _radarController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 180 * _radarController.value,
                        height: 180 * _radarController.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: GoMitraColors.green.withValues(alpha: 1.0 - _radarController.value),
                            width: 2,
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: GoMitraColors.green.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.radar, color: GoMitraColors.green, size: 48),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 36),
              Text(
                'Searching Terminal ${widget.terminal}…',
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Scanning compatible passengers heading to ${widget.destination}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const Spacer(),
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white24),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Cancel Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchResultsScreen extends StatefulWidget {
  const MatchResultsScreen({
    required this.store,
    required this.terminal,
    required this.destination,
    required this.onCreateGroup,
    super.key,
  });

  final LocalStore store;
  final String terminal;
  final String destination;
  final ValueChanged<List<String>> onCreateGroup;

  @override
  State<MatchResultsScreen> createState() => _MatchResultsScreenState();
}

class _MatchResultsScreenState extends State<MatchResultsScreen> {
  final Set<int> _selectedIds = {};
  late final Future<List<Passenger>> _matches;
  int _activeFilter = 0; // 0 = Best Matches, 1 = Nearby, 2 = Departing Soon

  @override
  void initState() {
    super.initState();
    _matches = widget.store.findMatches(widget.destination, terminal: widget.terminal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('People going to ${widget.destination}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Change', style: TextStyle(color: GoMitraColors.green, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<Passenger>>(
                future: _matches,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const _MessageState(
                      icon: Icons.error_outline,
                      title: 'Matches could not be loaded',
                      detail: 'Please return and try again.',
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final matches = snapshot.data!
                      .where((person) =>
                          person.detourMinutes <= 35 &&
                          person.departureMinutes <= 60)
                      .toList();
                  if (matches.isEmpty) {
                    return const _MessageState(
                      icon: Icons.person_search_outlined,
                      title: 'No demo matches found',
                      detail:
                          'Try another destination or check again later. Real travellers are not connected in this prototype.',
                    );
                  }
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
                    children: [
                      Text(
                        'Mumbai CSMIA ${widget.terminal} → Destination (~24 km)',
                        style: const TextStyle(color: GoMitraColors.muted, fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ChoiceChip(
                              label: Text('Best Matches (${matches.length})'),
                              selected: _activeFilter == 0,
                              selectedColor: GoMitraColors.softGreen,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _activeFilter == 0 ? GoMitraColors.forestGreen : GoMitraColors.ink,
                                fontWeight: FontWeight.w800,
                              ),
                              side: BorderSide(
                                color: _activeFilter == 0 ? GoMitraColors.green : GoMitraColors.border,
                                width: _activeFilter == 0 ? 1.5 : 1,
                              ),
                              onSelected: (val) => setState(() => _activeFilter = 0),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Nearby Passengers (8)'),
                              selected: _activeFilter == 1,
                              selectedColor: GoMitraColors.softGreen,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _activeFilter == 1 ? GoMitraColors.forestGreen : GoMitraColors.ink,
                                fontWeight: FontWeight.w800,
                              ),
                              side: BorderSide(
                                color: _activeFilter == 1 ? GoMitraColors.green : GoMitraColors.border,
                                width: _activeFilter == 1 ? 1.5 : 1,
                              ),
                              onSelected: (val) => setState(() => _activeFilter = 1),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Departing Soon'),
                              selected: _activeFilter == 2,
                              selectedColor: GoMitraColors.softGreen,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                color: _activeFilter == 2 ? GoMitraColors.forestGreen : GoMitraColors.ink,
                                fontWeight: FontWeight.w800,
                              ),
                              side: BorderSide(
                                color: _activeFilter == 2 ? GoMitraColors.green : GoMitraColors.border,
                                width: _activeFilter == 2 ? 1.5 : 1,
                              ),
                              onSelected: (val) => setState(() => _activeFilter = 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (final passenger in matches)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _MatchCard(
                            passenger: passenger,
                            selected: _selectedIds.contains(passenger.id),
                            exact: passenger.matches(widget.destination),
                            onTap: () {
                              setState(() {
                                if (!_selectedIds.add(passenger.id)) {
                                  _selectedIds.remove(passenger.id);
                                }
                              });
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: FilledButton(
                onPressed: _selectedIds.isEmpty
                    ? null
                    : () async {
                        final matches = await _matches;
                        final members = matches
                            .where((person) => _selectedIds.contains(person.id))
                            .map((person) => person.name)
                            .toList(growable: false);
                        if (members.isNotEmpty && context.mounted) {
                          widget.onCreateGroup(members);
                        }
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _selectedIds.isEmpty
                      ? 'Select Passengers to Split Fare'
                      : 'Create Group & Share Ride (${_selectedIds.length + 1})',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.passenger,
    required this.selected,
    required this.exact,
    required this.onTap,
  });

  final Passenger passenger;
  final bool selected;
  final bool exact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected ? const Color(0xFFECFDF5) : GoMitraColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? GoMitraColors.green : GoMitraColors.border,
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        key: ValueKey('match-${passenger.id}'),
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              TravellerAvatar(
                initials: passenger.initials,
                size: 50,
                color: exact ? GoMitraColors.softGreen : const Color(0xFFE0F2FE),
                showOnlineRing: true,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          passenger.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.verified, color: GoMitraColors.green, size: 15),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.star, color: GoMitraColors.amber, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              '${passenger.rating}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      passenger.area,
                      style: const TextStyle(
                        color: GoMitraColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GoMitraColors.softGreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${passenger.matchPercentage}% MATCH',
                            style: const TextStyle(
                              color: GoMitraColors.forestGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: GoMitraColors.canvas,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: GoMitraColors.border),
                          ),
                          child: Text(
                            'In ${passenger.departureMinutes} mins',
                            style: const TextStyle(
                              color: GoMitraColors.ink,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: selected ? GoMitraColors.green : GoMitraColors.canvas,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected ? GoMitraColors.green : GoMitraColors.border,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  selected ? Icons.check : Icons.add,
                  color: selected ? Colors.white : GoMitraColors.green,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupSetupScreen extends StatefulWidget {
  const GroupSetupScreen({
    required this.store,
    required this.terminal,
    required this.destination,
    required this.members,
    required this.onConfirmed,
    required this.onOpenChat,
    super.key,
  });

  final LocalStore store;
  final String terminal;
  final String destination;
  final List<String> members;
  final VoidCallback onConfirmed;
  final ValueChanged<Trip> onOpenChat;

  @override
  State<GroupSetupScreen> createState() => _GroupSetupScreenState();
}

class _GroupSetupScreenState extends State<GroupSetupScreen> {
  String _meetingPoint = 'T2 - Arrival Gate A (Inside Terminal)';
  Trip? _trip;
  bool _saving = false;

  List<String> get _meetingPoints => [
        '${widget.terminal} - Arrival Gate A (Inside Terminal)',
        '${widget.terminal} - Arrival Gate B (Outside Exit)',
        '${widget.terminal} - Public Cab Pick-Up Zone',
      ];

  Future<void> _confirmGroup() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final tripId = await widget.store.createTrip(
        terminal: widget.terminal,
        destination: widget.destination,
        members: widget.members,
        meetingPoint: _meetingPoint,
      );
      final trips = await widget.store.getTrips();
      final trip = trips.firstWhere((item) => item.id == tripId);
      if (!mounted) return;
      setState(() {
        _trip = trip;
        _saving = false;
      });
      widget.onConfirmed();
    } catch (error) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the demo group: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = _trip;
    final totalCount = widget.members.length + 1;
    final originalFare = 1200;
    final sharedFare = (originalFare / totalCount).round();
    final savingsPercent = (((originalFare - sharedFare) / originalFare) * 100).round();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Group ($totalCount)'),
        actions: [
          IconButton(
            tooltip: 'Group Options',
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            GroupMemberAvatarRow(
              members: widget.members,
              onAddMore: () => Navigator.pop(context),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: GoMitraColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: GoMitraColors.green, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Meeting Point',
                          style: TextStyle(color: GoMitraColors.muted, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _meetingPoint,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: trip == null ? _changeMeetingPoint : null,
                    child: const Text('Change', style: TextStyle(color: GoMitraColors.green, fontWeight: FontWeight.w800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            MapPreview(
              terminal: widget.terminal,
              destination: widget.destination,
              meetingPointLabel: 'T2 - Gate A Meeting Point',
              height: 150,
            ),
            const SizedBox(height: 18),
            UberFareCard(
              originalFare: originalFare,
              sharedFare: sharedFare,
              savingsPercent: savingsPercent,
              onBookUber: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CabBookingScreen(
                      terminal: widget.terminal,
                      destination: widget.destination,
                      memberCount: totalCount,
                      sharedFare: sharedFare,
                    ),
                  ),
                );
              },
              onOpenChat: () {
                if (trip != null) {
                  widget.onOpenChat(trip);
                } else {
                  _confirmGroup().then((_) {
                    if (_trip != null && mounted) {
                      widget.onOpenChat(_trip!);
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            if (trip == null)
              FilledButton(
                onPressed: _saving ? null : _confirmGroup,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Confirm Group & Meeting Point', style: TextStyle(fontWeight: FontWeight.w800)),
              )
            else ...[
              TextButton(
                onPressed: _leaveGroup,
                style: TextButton.styleFrom(foregroundColor: GoMitraColors.error),
                child: const Text('Leave group'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _changeMeetingPoint() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Meeting Point',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              for (final point in _meetingPoints)
                ListTile(
                  leading: const Icon(Icons.place_outlined, color: GoMitraColors.green),
                  title: Text(point, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: _meetingPoint == point
                      ? const Icon(Icons.check_circle, color: GoMitraColors.green)
                      : null,
                  onTap: () => Navigator.pop(context, point),
                ),
            ],
          ),
        ),
      ),
    );
    if (selected != null && mounted) {
      setState(() => _meetingPoint = selected);
    }
  }

  Future<void> _leaveGroup() async {
    final trip = _trip;
    if (trip == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave this group?'),
        content: const Text(
          'This demo group will be marked cancelled for all its members.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay in group'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Leave group'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.store.leaveTrip(trip.id);
      if (!mounted) return;
      setState(() {
        _trip = Trip(
          id: trip.id,
          terminal: trip.terminal,
          destination: trip.destination,
          members: trip.members,
          meetingPoint: trip.meetingPoint,
          status: 'Cancelled',
          createdAt: trip.createdAt,
        );
      });
      widget.onConfirmed();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not leave the demo group: $error')),
      );
    }
  }
}

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({
    required this.store,
    required this.trip,
    required this.onChanged,
    super.key,
  });

  final LocalStore store;
  final Trip trip;
  final VoidCallback onChanged;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late Future<List<ChatMessage>> _messages;
  bool _sending = false;

  final List<String> _quickReplies = [
    'I\'m at Gate A',
    '2 mins away',
    'Near the exit',
    'Wearing blue shirt',
  ];

  @override
  void initState() {
    super.initState();
    _messages = widget.store.getMessages(widget.trip.id);
    _controller.addListener(_onDraftChanged);
  }

  void _onDraftChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onDraftChanged);
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendText(String text) async {
    final body = text.trim();
    final validationError = messageValidationError(body);
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }
    if (_sending) return;
    setState(() => _sending = true);
    try {
      await widget.store.sendMessage(widget.trip.id, body);
      _controller.clear();
      setState(() {
        _messages = widget.store.getMessages(widget.trip.id);
        _sending = false;
      });
      widget.onChanged();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _sending = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Message was not saved: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.trip.destination} Group (${widget.trip.members.length + 1})',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const Row(
              children: [
                CircleAvatar(radius: 3, backgroundColor: GoMitraColors.green),
                SizedBox(width: 4),
                Text(
                  'Online',
                  style: TextStyle(
                    color: GoMitraColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Call group',
            icon: const Icon(Icons.call_outlined),
            onPressed: () => _showChatSafety(context),
          ),
          IconButton(
            tooltip: 'More options',
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 6),
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: GoMitraColors.softGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 15, color: GoMitraColors.forestGreen),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'Coordination chat · No phone numbers shared',
                        style: TextStyle(
                          color: GoMitraColors.forestGreen,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ChatMessage>>(
                future: _messages,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const _MessageState(
                      icon: Icons.error_outline,
                      title: 'Messages could not be loaded',
                      detail: 'Return to the group and try again.',
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return const _MessageState(
                      icon: Icons.chat_bubble_outline,
                      title: 'Start the conversation',
                      detail: 'Coordinate the public meeting point with your demo group.',
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) => _MessageBubble(message: snapshot.data![index]),
                  );
                },
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  for (final reply in _quickReplies) ...[
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ActionChip(
                        label: Text(reply),
                        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: GoMitraColors.forestGreen),
                        backgroundColor: GoMitraColors.softGreen,
                        side: const BorderSide(color: GoMitraColors.green),
                        onPressed: () => _sendText(reply),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: GoMitraColors.muted),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        minLines: 1,
                        maxLines: 4,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          hintText: 'Type a message…',
                          counterText: '',
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.mic_none, color: GoMitraColors.muted),
                      onPressed: () {},
                    ),
                    IconButton.filled(
                      tooltip: 'Send message',
                      onPressed: _sending || _controller.text.trim().isEmpty ? null : () => _sendText(_controller.text),
                      style: IconButton.styleFrom(
                        backgroundColor: GoMitraColors.green,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(44, 44),
                      ),
                      icon: _sending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CabBookingScreen extends StatefulWidget {
  const CabBookingScreen({
    required this.terminal,
    required this.destination,
    required this.memberCount,
    required this.sharedFare,
    super.key,
  });

  final String terminal;
  final String destination;
  final int memberCount;
  final int sharedFare;

  @override
  State<CabBookingScreen> createState() => _CabBookingScreenState();
}

class _CabBookingScreenState extends State<CabBookingScreen> {
  String _selectedProvider = 'uber'; // uber, ola, rapido, blabla

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: MapPreview(
              terminal: widget.terminal,
              destination: widget.destination,
              height: double.infinity,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: GoMitraColors.ink),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 18,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      RideProviderBadge(provider: _selectedProvider, size: 24),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_selectedProvider.toUpperCase()} Booking',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            'Shared Ride · ${widget.memberCount} passengers',
                            style: const TextStyle(
                              color: GoMitraColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (final p in ['uber', 'ola', 'rapido', 'blabla']) ...[
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(p.toUpperCase()),
                              selected: _selectedProvider == p,
                              selectedColor: GoMitraColors.softGreen,
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: _selectedProvider == p ? GoMitraColors.forestGreen : GoMitraColors.ink,
                              ),
                              side: BorderSide(
                                color: _selectedProvider == p ? GoMitraColors.green : GoMitraColors.border,
                              ),
                              onSelected: (val) => setState(() => _selectedProvider = p),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    children: [
                      const Icon(Icons.my_location, color: GoMitraColors.blue, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('From', style: TextStyle(color: GoMitraColors.muted, fontSize: 11)),
                          Text('Mumbai Airport ${widget.terminal}', style: const TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: GoMitraColors.green, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('To', style: TextStyle(color: GoMitraColors.muted, fontSize: 11)),
                          Text(widget.destination, style: const TextStyle(fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: GoMitraColors.canvas,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Estimated Shared Price',
                          style: TextStyle(color: GoMitraColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${widget.sharedFare}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                                color: GoMitraColors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '(per person)',
                              style: TextStyle(
                                color: GoMitraColors.muted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Launching ${_selectedProvider.toUpperCase()}'),
                          content: Text(
                            'Navigating to official ${_selectedProvider.toUpperCase()} app to book a shared ride for ${widget.memberCount} passengers to ${widget.destination}.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: RideProviderBadge(provider: _selectedProvider, size: 20),
                    label: Text('Book with ${_selectedProvider.toUpperCase()}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.isMine;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: mine ? GoMitraColors.softGreen : GoMitraColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(mine ? 18 : 4),
            bottomRight: Radius.circular(mine ? 4 : 18),
          ),
          border: mine ? null : Border.all(color: GoMitraColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!mine)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.sender,
                  style: const TextStyle(
                    color: GoMitraColors.forestGreen,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            Text(message.body, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  _time(message.createdAt),
                  style: const TextStyle(
                    color: GoMitraColors.muted,
                    fontSize: 10,
                  ),
                ),
                if (mine) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.done_all,
                    color: GoMitraColors.green,
                    size: 14,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: GoMitraColors.green, size: 48),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: GoMitraColors.muted, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

String _time(DateTime value) =>
    '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

Future<void> _showChatSafety(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Coordinate Thoughtfully'),
      content: const Text(
        'This prototype uses fictional profiles and does not verify identity. '
        'Meet only at public, permitted places. Do not share sensitive personal '
        'or payment information in chat.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}
