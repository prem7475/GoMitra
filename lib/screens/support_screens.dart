import 'package:flutter/material.dart';

import '../models.dart';
import '../theme.dart';
import '../widgets/common.dart';

class MoreAndSupportScreen extends StatefulWidget {
  const MoreAndSupportScreen({super.key});

  @override
  State<MoreAndSupportScreen> createState() => _MoreAndSupportScreenState();
}

class _MoreAndSupportScreenState extends State<MoreAndSupportScreen> {
  final List<SupportArticle> _faqs = const [
    SupportArticle(
      id: 'f1',
      title: 'How does GoMitra match airport travellers?',
      category: 'Matching',
      content:
          'GoMitra uses a 4-factor scoring model taking into account destination proximity (40%), departure time window (25%), terminal location (20%), and passenger group preferences (15%).',
    ),
    SupportArticle(
      id: 'f2',
      title: 'Are my phone numbers or personal details shared?',
      category: 'Privacy',
      content:
          'No. GoMitra coordinates group members inside the app. Phone numbers are never exposed to other passengers or public profiles.',
    ),
    SupportArticle(
      id: 'f3',
      title: 'Where do we meet at Mumbai CSMIA Airport?',
      category: 'Meeting Points',
      content:
          'All travel groups meet at official, public, well-lit airport pickup points (Arrival Gate A or Gate B inside CSMIA Terminal 1 & 2).',
    ),
    SupportArticle(
      id: 'f4',
      title: 'How are cab fares split?',
      category: 'Fare Sharing',
      content:
          'GoMitra displays an illustrative per-person fare share (Cab Fare ÷ Passengers). Payment is handled directly through the ride provider (Uber, Ola, Rapido).',
    ),
  ];

  void _showFeedbackModal() {
    double userRating = 5.0;
    final feedbackText = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Send App Feedback',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Help us improve the GoMitra airport journey experience.',
                style: TextStyle(color: GoMitraColors.muted, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 1; i <= 5; i++)
                    IconButton(
                      icon: Icon(
                        i <= userRating ? Icons.star : Icons.star_border,
                        color: GoMitraColors.amber,
                        size: 32,
                      ),
                      onPressed: () => setModalState(() => userRating = i.toDouble()),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackText,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Share your thoughts or suggest features…',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you! Your feedback has been received.')),
                  );
                },
                child: const Text('Submit Feedback'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTermsModal(String title, String body) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  body,
                  style: const TextStyle(color: GoMitraColors.ink, height: 1.5, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Understood'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Centre & Policies')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            const SectionLabel('Frequently Asked Questions'),
            const SizedBox(height: 10),
            for (final faq in _faqs)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: GoMitraColors.border),
                ),
                child: ExpansionTile(
                  title: Text(
                    faq.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  children: [
                    Text(
                      faq.content,
                      style: const TextStyle(color: GoMitraColors.muted, height: 1.45, fontSize: 13),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 18),
            const SectionLabel('Safety & Legal Policies'),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.shield_outlined, color: GoMitraColors.green),
              title: const Text('Safety Guidelines', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Best practices for meeting co-passengers at CSMIA'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsModal(
                'Safety Guidelines',
                '1. Meet only in designated, public, well-lit airport pickup gates (Gate A/B).\n2. Confirm your group member names before leaving the terminal.\n3. Keep coordination chat inside GoMitra without sharing phone numbers.\n4. If you feel uncomfortable, leave the group immediately using the Leave Group button.',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.description_outlined, color: GoMitraColors.ink),
              title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('GoMitra platform terms and conditions'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsModal(
                'Terms of Service',
                'GoMitra is a passenger discovery and journey coordination platform. GoMitra is not a cab operator, payment processor, or transportation carrier. Ride fares and driver dispatch are managed independently by third-party providers (Uber, Ola, Rapido).',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined, color: GoMitraColors.ink),
              title: const Text('Privacy Notice', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Data retention and location privacy policies'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTermsModal(
                'Privacy Notice',
                'Your profile preferences and journey history are stored safely on your device. GoMitra does not track live background location continuously or sell passenger data to third parties.',
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _showFeedbackModal,
              icon: const Icon(Icons.rate_review_outlined),
              label: const Text('Submit App Feedback'),
              style: FilledButton.styleFrom(
                backgroundColor: GoMitraColors.softGreen,
                foregroundColor: GoMitraColors.greenDark,
              ),
            ),
            const SizedBox(height: 24),
            const Center(
              child: Column(
                children: [
                  BrandMark(compact: true),
                  SizedBox(height: 6),
                  Text(
                    'GoMitra v1.0.0 (Build 1) • Production Prototype\nChhatrapati Shivaji Maharaj International Airport, Mumbai',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: GoMitraColors.muted, fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Global Overlay State Dialogs
Future<void> showNetworkErrorDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: GoMitraColors.warning),
          SizedBox(width: 10),
          Text('Offline Mode'),
        ],
      ),
      content: const Text(
        'You are currently using GoMitra in offline local prototype mode. Saved trips and chats remain accessible on this device.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Continue Offline'),
        ),
      ],
    ),
  );
}
