import 'package:flutter/material.dart';

import '../services/local_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    required this.store,
    required this.onComplete,
    required this.onSignIn,
    super.key,
  });

  final LocalStore store;
  final VoidCallback onComplete;
  final VoidCallback onSignIn;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _logoScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _proceed() async {
    final completed = await widget.store.isOnboardingCompleted();
    if (!mounted) return;
    if (completed) {
      widget.onComplete();
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => OnboardingScreen(
            store: widget.store,
            onComplete: widget.onComplete,
            onSignIn: widget.onSignIn,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoMitraColors.ink,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _AirportDuskBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: const BrandMark(dark: true),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => FadeTransition(
                      opacity: _taglineFade,
                      child: const Text(
                        'Land. Connect. Go Together.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Shared Rides.\nLower Costs.\nBetter Journeys.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      height: 1.15,
                      letterSpacing: -1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Discover compatible travellers arriving at Mumbai Airport T1/T2, share a cab, and lower your journey costs by up to 75%.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _proceed,
                    style: FilledButton.styleFrom(
                      backgroundColor: GoMitraColors.green,
                      minimumSize: const Size.fromHeight(56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.onSignIn,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    required this.store,
    required this.onContinue,
    required this.onSignIn,
    super.key,
  });

  final LocalStore store;
  final VoidCallback onContinue;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      store: store,
      onComplete: onContinue,
      onSignIn: onSignIn,
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    required this.store,
    required this.onComplete,
    required this.onSignIn,
    super.key,
  });

  final LocalStore store;
  final VoidCallback onComplete;
  final VoidCallback onSignIn;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Find Travellers\nGoing Your Way',
      'body': 'Discover airport passengers arriving at CSMIA T1/T2 heading toward the same destination and split cab fares.',
    },
    {
      'title': 'Connect Before\nYou Ride',
      'body': 'View passenger ratings, route compatibility, and arrival times with transparent 90%+ match score explanations.',
    },
    {
      'title': 'Coordinate Together\nWith Confidence',
      'body': 'Chat inside GoMitra to meet at public airport gates (Gate A/B) without exposing personal phone numbers.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    await widget.store.setOnboardingCompleted(true);
    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GoMitraColors.canvas,
      appBar: AppBar(
        backgroundColor: GoMitraColors.canvas,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: GoMitraColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemCount: _slides.length,
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: GoMitraColors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: GoMitraColors.border),
                          ),
                          child: CustomPaint(
                            painter: _TravellersIllustrationPainter(slideIndex: index),
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: GoMitraColors.ink,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            letterSpacing: -0.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            slide['body']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: GoMitraColors.muted,
                              fontSize: 14,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _slides.length; i++) ...[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: i == _currentPage ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _currentPage
                            ? GoMitraColors.green
                            : GoMitraColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  } else {
                    _finishOnboarding();
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: GoMitraColors.green,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _currentPage < _slides.length - 1 ? 'Next' : 'Continue as Demo',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(height: 12),
              const DemoNotice(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AirportDuskBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final bgGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF070B0A),
        Color(0xFF0F1714),
        Color(0xFF16221D),
      ],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = bgGradient);

    final horizonY = size.height * 0.42;

    final sunsetGlow = RadialGradient(
      center: Alignment(0.2, (horizonY / size.height) * 2 - 1),
      radius: 0.8,
      colors: [
        GoMitraColors.green.withValues(alpha: 0.18),
        Colors.transparent,
      ],
    ).createShader(rect);
    canvas.drawRect(rect, Paint()..shader = sunsetGlow);

    final silhouette = Path()
      ..moveTo(0, horizonY)
      ..lineTo(size.width * 0.15, horizonY - 12)
      ..lineTo(size.width * 0.35, horizonY - 30)
      ..lineTo(size.width * 0.65, horizonY - 30)
      ..lineTo(size.width * 0.85, horizonY - 12)
      ..lineTo(size.width, horizonY)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      silhouette,
      Paint()..color = const Color(0xFF0A0F0D),
    );

    final lightPaint = Paint()..color = GoMitraColors.green;
    for (var i = 0; i < 8; i++) {
      final t = i / 7.0;
      final x = size.width * (0.1 + t * 0.8);
      final y = horizonY + 20 + (t - 0.5).abs() * 30;
      canvas.drawCircle(Offset(x, y), 2.5, lightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TravellersIllustrationPainter extends CustomPainter {
  const _TravellersIllustrationPainter({required this.slideIndex});

  final int slideIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFF1F7F4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(24),
      ),
      bg,
    );

    final pGreen = Paint()..color = GoMitraColors.green;
    final pInk = Paint()..color = GoMitraColors.ink;
    final pMuted = Paint()..color = GoMitraColors.muted;

    final centerY = size.height * 0.58;

    final positions = [
      size.width * 0.3,
      size.width * 0.5,
      size.width * 0.7,
    ];

    for (var i = 0; i < positions.length; i++) {
      final x = positions[i];
      final height = i == 1 ? 65.0 : 58.0;

      canvas.drawCircle(Offset(x, centerY - height), 12, i == slideIndex ? pGreen : pInk);

      final bodyPath = Path()
        ..moveTo(x - 10, centerY - height + 14)
        ..lineTo(x + 10, centerY - height + 14)
        ..lineTo(x + 8, centerY - 8)
        ..lineTo(x - 8, centerY - 8)
        ..close();
      canvas.drawPath(bodyPath, i == slideIndex ? pInk : pMuted);

      final suitcaseRect = Rect.fromLTWH(x + 12, centerY - 25, 16, 25);
      canvas.drawRRect(
        RRect.fromRectAndRadius(suitcaseRect, const Radius.circular(4)),
        pGreen,
      );
      canvas.drawLine(
        Offset(x + 20, centerY - 25),
        Offset(x + 20, centerY - 32),
        pInk..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
