import 'package:flutter/material.dart';

import '../services/local_store.dart';
import 'auth_screens.dart';
import 'journey_screens.dart';
import 'main_screens.dart';
import 'welcome_screen.dart';

class AppFlow extends StatefulWidget {
  const AppFlow({required this.store, super.key});

  final LocalStore store;

  @override
  State<AppFlow> createState() => _AppFlowState();
}

class _AppFlowState extends State<AppFlow> {
  bool _showWelcome = true;

  void _enterDemo() {
    if (mounted) setState(() => _showWelcome = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcome) {
      return WelcomeScreen(
        store: widget.store,
        onContinue: _enterDemo,
        onSignIn: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => DemoSignInScreen(
                onContinue: () {
                  Navigator.of(context).pop();
                  _enterDemo();
                },
              ),
            ),
          );
        },
      );
    }
    return MainShell(
      store: widget.store,
      onLogout: () => setState(() => _showWelcome = true),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({required this.store, required this.onLogout, super.key});

  final LocalStore store;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  int _revision = 0;
  String _terminal = 'T2';
  String? _destination;

  Future<void> _openDestinationPicker() async {
    final destination = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => DestinationSearchScreen(
          initialDestination: _destination,
        ),
      ),
    );
    if (destination != null && mounted) {
      setState(() => _destination = destination);
    }
  }

  Future<void> _openMatches() async {
    final destination = _destination;
    if (destination == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a destination first.')),
      );
      return;
    }
    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => FindingMatchesScreen(
          store: widget.store,
          terminal: _terminal,
          destination: destination,
          onCreateGroup: (members) {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (_) => GroupSetupScreen(
                  store: widget.store,
                  terminal: _terminal,
                  destination: destination,
                  members: members,
                  onConfirmed: () {
                    if (mounted) setState(() => _revision++);
                  },
                  onOpenChat: (trip) {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => GroupChatScreen(
                          store: widget.store,
                          trip: trip,
                          onChanged: () {
                            if (mounted) setState(() => _revision++);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
    if (mounted) setState(() => _revision++);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        terminal: _terminal,
        destination: _destination,
        onSelectTerminal: (value) => setState(() => _terminal = value),
        onSelectDestination: _openDestinationPicker,
        onChooseDestination: (value) => setState(() => _destination = value),
        onFindCompanions: _openMatches,
        onOpenTrips: () => setState(() => _tab = 1),
      ),
      TripsScreen(
        key: ValueKey('trips-$_revision'),
        store: widget.store,
        onOpenChat: (trip) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => GroupChatScreen(
                store: widget.store,
                trip: trip,
                onChanged: () => setState(() => _revision++),
              ),
            ),
          );
        },
      ),
      ChatsScreen(
        key: ValueKey('chats-$_revision'),
        store: widget.store,
        onOpenChat: (trip) {
          Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (_) => GroupChatScreen(
                store: widget.store,
                trip: trip,
                onChanged: () => setState(() => _revision++),
              ),
            ),
          );
        },
      ),
      ProfileScreen(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: _tab, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.luggage_outlined),
            selectedIcon: Icon(Icons.luggage),
            label: 'My Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
