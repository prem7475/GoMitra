import 'package:flutter/material.dart';

import '../models.dart';
import '../services/local_store.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'support_screens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.terminal,
    required this.destination,
    required this.onSelectTerminal,
    required this.onSelectDestination,
    required this.onChooseDestination,
    required this.onFindCompanions,
    required this.onOpenTrips,
    super.key,
  });

  final String terminal;
  final String? destination;
  final ValueChanged<String> onSelectTerminal;
  final VoidCallback onSelectDestination;
  final ValueChanged<String> onChooseDestination;
  final VoidCallback onFindCompanions;
  final VoidCallback onOpenTrips;

  @override
  Widget build(BuildContext context) {
    final selectedDestination = destination ?? 'Search destination (e.g. Thane)';
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(child: BrandMark(compact: true)),
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('GoMitra Notifications: No new alerts.')),
                  );
                },
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_none_rounded, size: 26),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: GoMitraColors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              const TravellerAvatar(initials: 'Y', size: 38, showOnlineRing: true),
            ],
          ),
          const SizedBox(height: 12),
          const DemoNotice(),
          const SizedBox(height: 20),
          Text(
            'Where are you\ncoming from?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.8,
                  height: 1.1,
                  color: GoMitraColors.ink,
                ),
          ),
          const SizedBox(height: 16),
          AirportTerminalCard(
            terminal: 'T2',
            title: 'Mumbai Airport T2',
            subtitle: 'Chhatrapati Shivaji Maharaj International Airport',
            isSelected: terminal == 'T2',
            onTap: () => onSelectTerminal('T2'),
          ),
          const SizedBox(height: 12),
          AirportTerminalCard(
            terminal: 'T1',
            title: 'Mumbai Airport T1',
            subtitle: 'Chhatrapati Shivaji Maharaj International Airport',
            isSelected: terminal == 'T1',
            onTap: () => onSelectTerminal('T1'),
          ),
          const SizedBox(height: 22),
          const SectionLabel('Choose your destination'),
          const SizedBox(height: 10),
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onSelectDestination,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GoMitraColors.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 12,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: GoMitraColors.muted, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDestination,
                      style: TextStyle(
                        color: destination == null ? GoMitraColors.muted : GoMitraColors.ink,
                        fontWeight: destination == null ? FontWeight.normal : FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(Icons.map_outlined, color: GoMitraColors.green, size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const SectionLabel('Popular destinations'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final place in const [
                'Thane',
                'Mulund',
                'Vikhroli',
                'Powai',
                'Navi Mumbai',
                'Andheri',
                'Bandra',
                'Goregaon',
              ])
                ActionChip(
                  key: ValueKey('chip-$place'),
                  label: Text(place),
                  labelStyle: TextStyle(
                    color: destination == place ? GoMitraColors.forestGreen : GoMitraColors.ink,
                    fontWeight: destination == place ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 13,
                  ),
                  onPressed: () => onChooseDestination(place),
                  backgroundColor: destination == place ? GoMitraColors.softGreen : GoMitraColors.white,
                  side: BorderSide(
                    color: destination == place ? GoMitraColors.green : GoMitraColors.border,
                    width: destination == place ? 1.5 : 1,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          MapPreview(
            terminal: terminal,
            destination: destination ?? 'Destination',
            height: 162,
          ),
          const SizedBox(height: 22),
          FilledButton.icon(
            onPressed: onFindCompanions,
            icon: const Icon(Icons.people_alt_outlined),
            label: const Text('Find Travel Companions'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(56),
              backgroundColor: GoMitraColors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'Matches use fictional demo profiles.',
              style: TextStyle(color: GoMitraColors.muted, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationSearchScreen extends StatefulWidget {
  const DestinationSearchScreen({this.initialDestination, super.key});

  final String? initialDestination;

  @override
  State<DestinationSearchScreen> createState() => _DestinationSearchScreenState();
}

class _DestinationSearchScreenState extends State<DestinationSearchScreen> {
  static const _destinations = [
    'Thane',
    'Mulund',
    'Vikhroli',
    'Powai',
    'Navi Mumbai',
    'Andheri',
    'Bandra',
    'Goregaon',
  ];
  late final TextEditingController _search;
  String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialDestination;
    _search = TextEditingController(text: widget.initialDestination);
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _destinations
        .where((place) => place.toLowerCase().contains(_search.text.trim().toLowerCase()))
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Where are you going?')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 18),
          child: Column(
            children: [
              TextField(
                controller: _search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search destination (e.g. Thane)',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _search.text.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear search',
                          onPressed: () => _search.clear(),
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: SectionLabel('Popular Destinations'),
              ),
              const SizedBox(height: 8),
              if (filtered.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      'No saved destinations match that search.',
                      style: TextStyle(color: GoMitraColors.muted),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 2),
                    itemBuilder: (context, index) {
                      final place = filtered[index];
                      final isSelected = _selected == place;
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                        leading: const CircleAvatar(
                          backgroundColor: GoMitraColors.softGreen,
                          child: Icon(
                            Icons.location_on_outlined,
                            color: GoMitraColors.forestGreen,
                          ),
                        ),
                        title: Text(
                          place,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text('Mumbai Metropolitan Region · ~24 km'),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: GoMitraColors.green,
                              )
                            : const Icon(Icons.chevron_right),
                        onTap: () => setState(() => _selected = place),
                      );
                    },
                  ),
                ),
              if (_selected != null) ...[
                MapPreview(
                  terminal: 'T2',
                  destination: _selected!,
                  height: 125,
                ),
                const SizedBox(height: 12),
              ],
              FilledButton(
                onPressed: _selected == null
                    ? null
                    : () => Navigator.of(context).pop(_selected),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Confirm Destination', style: TextStyle(fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripsScreen extends StatelessWidget {
  const TripsScreen({
    required this.store,
    required this.onOpenChat,
    super.key,
  });

  final LocalStore store;
  final ValueChanged<Trip> onOpenChat;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trip>>(
      future: store.getTrips(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _LoadError(
            message: 'Trips could not be loaded. Return home and try again.',
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'My Trips',
                subtitle: 'Your saved shared journeys',
              ),
              const SizedBox(height: 20),
              if (!snapshot.hasData)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.data!.isEmpty)
                const _EmptyState(
                  icon: Icons.luggage_outlined,
                  title: 'No saved trips yet',
                  message: 'Find compatible travellers to create your first demo group.',
                )
              else
                for (final trip in snapshot.data!)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TripCard(
                      trip: trip,
                      onOpenChat: () => onOpenChat(trip),
                    ),
                  ),
              const SizedBox(height: 8),
              const DemoNotice(),
            ],
          ),
        );
      },
    );
  }
}

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({
    required this.store,
    required this.onOpenChat,
    super.key,
  });

  final LocalStore store;
  final ValueChanged<Trip> onOpenChat;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Trip>>(
      future: store.getTrips(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const _EmptyState(
            icon: Icons.error_outline,
            title: 'Chats unavailable',
            message: 'Local conversations could not be loaded. Please retry.',
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageHeading(
                title: 'Chats',
                subtitle: 'Group conversations stay inside GoMitra',
              ),
              const SizedBox(height: 18),
              if (!snapshot.hasData)
                const Center(child: CircularProgressIndicator())
              else if (snapshot.data!.isEmpty || snapshot.data!.where((trip) => trip.status != 'Cancelled').isEmpty)
                const Expanded(
                  child: _EmptyState(
                    icon: Icons.chat_bubble_outline,
                    title: 'No active conversations',
                    message: 'Create a demo group to start chatting.',
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: snapshot.data!.where((trip) => trip.status != 'Cancelled').length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final trip = snapshot.data!.where((trip) => trip.status != 'Cancelled').elementAt(index);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        leading: const TravellerAvatar(
                          initials: 'GM',
                          color: Color(0xFFE0F2FE),
                          showOnlineRing: true,
                        ),
                        title: Text(
                          '${trip.destination} Group',
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                        ),
                        subtitle: Text(
                          '${trip.members.length + 1} travellers · ${trip.meetingPoint}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.chevron_right, color: GoMitraColors.muted),
                        onTap: () => onOpenChat(trip),
                      );
                    },
                  ),
                ),
              const DemoNotice(),
            ],
          ),
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.onLogout, super.key});

  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      children: [
        const PageHeading(
          title: 'Profile',
          subtitle: 'Your traveller account & preferences',
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const TravellerAvatar(
                  initials: 'Y',
                  size: 56,
                  color: Color(0xFFE0F2FE),
                  showOnlineRing: true,
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Demo Traveller',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.verified, color: GoMitraColors.green, size: 16),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        '@gomitra_demo · Rating ★ 5.0',
                        style: TextStyle(
                          color: GoMitraColors.muted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        const SectionLabel('Preferences'),
        _ProfileTile(
          icon: Icons.tune,
          title: 'Travel Preferences',
          subtitle: 'Airport terminal, luggage count & detour limits',
          onTap: () => _showInfo(
            context,
            'Travel Preferences',
            'Travel preferences are configured per trip in this preview.',
          ),
        ),
        _ProfileTile(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Push alerts for co-passenger matches',
          onTap: () => _showInfo(
            context,
            'Notifications',
            'Notifications are handled locally in this offline prototype.',
          ),
        ),
        const SizedBox(height: 12),
        const SectionLabel('Privacy & Support'),
        _ProfileTile(
          icon: Icons.shield_outlined,
          title: 'Privacy and Safety',
          subtitle: 'No phone numbers exposed · Public meeting points only',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const MoreAndSupportScreen()),
          ),
        ),
        _ProfileTile(
          icon: Icons.help_outline,
          title: 'Help Centre & Support',
          subtitle: 'FAQs, Safety Guidelines, and App Feedback',
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const MoreAndSupportScreen()),
          ),
        ),
        _ProfileTile(
          icon: Icons.payments_outlined,
          title: 'Payment Preferences',
          subtitle: 'External ride provider handoff (Uber / Ola / Rapido)',
          onTap: () => _showInfo(
            context,
            'Payments',
            'GoMitra calculates split fare estimates. Payment is processed directly with the ride provider.',
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () async {
            final shouldLogout = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Leave Demo Mode?'),
                content: const Text(
                  'You will return to the welcome screen. Saved demo trips remain on this device.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Leave Demo'),
                  ),
                ],
              ),
            );
            if (shouldLogout == true) onLogout();
          },
          icon: const Icon(Icons.logout, color: GoMitraColors.error),
          label: const Text(
            'Leave Demo Mode',
            style: TextStyle(color: GoMitraColors.error, fontWeight: FontWeight.w800),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            side: const BorderSide(color: GoMitraColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 14),
        const DemoNotice(),
      ],
    );
  }
}

class TripCard extends StatelessWidget {
  const TripCard({required this.trip, required this.onOpenChat, super.key});

  final Trip trip;
  final VoidCallback onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flight_land, color: GoMitraColors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${trip.terminal} → ${trip.destination}',
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                _StatusBadge(trip.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              trip.meetingPoint,
              style: const TextStyle(color: GoMitraColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              '${trip.members.length + 1} travellers · ${_formatDate(trip.createdAt)}',
              style: const TextStyle(fontSize: 12, color: GoMitraColors.muted),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: trip.status == 'Upcoming'
                  ? TextButton.icon(
                      onPressed: onOpenChat,
                      icon: const Icon(Icons.chat_bubble_outline, size: 18),
                      label: const Text('Open Group Chat'),
                    )
                  : const Text(
                      'Group Cancelled',
                      style: TextStyle(
                        color: GoMitraColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
      leading: Icon(icon, color: GoMitraColors.ink),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: GoMitraColors.muted),
      onTap: onTap,
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: label == 'Cancelled' ? GoMitraColors.error.withValues(alpha: 0.1) : GoMitraColors.softGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: label == 'Cancelled' ? GoMitraColors.error : GoMitraColors.forestGreen,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

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
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: GoMitraColors.muted,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: GoMitraColors.error, size: 36),
            const SizedBox(height: 8),
            Text(message),
          ],
        ),
      );
}

String _formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

Future<void> _showInfo(
  BuildContext context,
  String title,
  String message,
) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}
