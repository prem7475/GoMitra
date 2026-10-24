import 'package:flutter/material.dart';

import '../theme.dart';

class BrandMark extends StatelessWidget {
  const BrandMark({this.dark = false, this.compact = false, super.key});

  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textColor = dark ? GoMitraColors.white : GoMitraColors.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: compact ? 30 : 38,
              height: compact ? 30 : 38,
              decoration: BoxDecoration(
                color: GoMitraColors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
            Icon(
              Icons.location_on,
              color: GoMitraColors.green,
              size: compact ? 28 : 36,
            ),
          ],
        ),
        const SizedBox(width: 6),
        Text(
          'GoMitra',
          style: TextStyle(
            color: textColor,
            fontSize: compact ? 22 : 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.2,
          ),
        ),
      ],
    );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading({
    required this.title,
    this.subtitle,
    this.action,
    super.key,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.6,
                      color: GoMitraColors.ink,
                    ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GoMitraColors.muted,
                      ),
                ),
              ],
            ],
          ),
        ),
        ?action,
      ],
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {this.trailing, super.key});

  final String text;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: GoMitraColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(color: GoMitraColors.muted, fontSize: 12, fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}

class DemoNotice extends StatelessWidget {
  const DemoNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: GoMitraColors.mint,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GoMitraColors.green.withValues(alpha: 0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.verified_user_outlined, color: GoMitraColors.greenDark, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Demo mode · Fictional passengers · Offline device storage',
              style: TextStyle(
                color: GoMitraColors.greenDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TravellerAvatar extends StatelessWidget {
  const TravellerAvatar({
    required this.initials,
    this.size = 44,
    this.color = GoMitraColors.mint,
    this.showOnlineRing = false,
    super.key,
  });

  final String initials;
  final double size;
  final Color color;
  final bool showOnlineRing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: color,
          child: Text(
            initials,
            style: TextStyle(
              color: GoMitraColors.greenDark,
              fontWeight: FontWeight.w900,
              fontSize: size * 0.38,
            ),
          ),
        ),
        if (showOnlineRing)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                color: GoMitraColors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class AirportTerminalCard extends StatelessWidget {
  const AirportTerminalCard({
    required this.terminal,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String terminal;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? GoMitraColors.green : GoMitraColors.border,
          width: isSelected ? 2.2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 125,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TerminalArchitecturalPainter(terminal: terminal),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.4),
                        Colors.black.withValues(alpha: 0.15),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  title,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: GoMitraColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RideProviderBadge extends StatelessWidget {
  const RideProviderBadge({required this.provider, this.size = 20, super.key});

  final String provider; // 'uber', 'rapido', 'ola', 'blabla'
  final double size;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.black;
    String label = 'Uber';
    if (provider.toLowerCase() == 'rapido') {
      bg = const Color(0xFFF3C623);
      label = 'Rapido';
    } else if (provider.toLowerCase() == 'ola') {
      bg = const Color(0xFF8DC63F);
      label = 'Ola';
    } else if (provider.toLowerCase() == 'blabla') {
      bg = const Color(0xFF054752);
      label = 'BlaBla';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.4, vertical: size * 0.15),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: provider.toLowerCase() == 'rapido' ? Colors.black : Colors.white,
          fontSize: size * 0.5,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.3,
        ),
      ),
    );
  }
}

class GroupMemberAvatarRow extends StatelessWidget {
  const GroupMemberAvatarRow({
    required this.members,
    this.onAddMore,
    super.key,
  });

  final List<String> members;
  final VoidCallback? onAddMore;

  @override
  Widget build(BuildContext context) {
    final allMembers = ['You', ...members];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < allMembers.length; i++) ...[
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Column(
                children: [
                  TravellerAvatar(
                    initials: _getInitials(allMembers[i]),
                    size: 48,
                    color: i == 0 ? GoMitraColors.mint : const Color(0xFFE0F2FE),
                    showOnlineRing: true,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    allMembers[i],
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: GoMitraColors.amber, size: 10),
                      Text(
                        i == 0 ? '5.0' : '4.9',
                        style: const TextStyle(fontSize: 9, color: GoMitraColors.muted, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          if (onAddMore != null)
            Column(
              children: [
                InkWell(
                  onTap: onAddMore,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: GoMitraColors.canvas,
                      shape: BoxShape.circle,
                      border: Border.all(color: GoMitraColors.border),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: GoMitraColors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add',
                  style: TextStyle(fontSize: 11, color: GoMitraColors.muted, fontWeight: FontWeight.w600),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static String _getInitials(String name) {
    if (name == 'You') return 'Y';
    final parts = name.replaceAll('.', '').split(' ');
    if (parts.length > 1) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 1).toUpperCase();
  }
}

class UberFareCard extends StatelessWidget {
  const UberFareCard({
    required this.originalFare,
    required this.sharedFare,
    required this.savingsPercent,
    required this.onBookUber,
    required this.onOpenChat,
    super.key,
  });

  final int originalFare;
  final int sharedFare;
  final int savingsPercent;
  final VoidCallback onBookUber;
  final VoidCallback onOpenChat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        RideProviderBadge(provider: 'uber', size: 18),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Estimated Cab Fare',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: GoMitraColors.muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '₹$originalFare',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: GoMitraColors.muted,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹$sharedFare',
                            style: const TextStyle(
                              color: GoMitraColors.green,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '(Shared per person)',
                            style: TextStyle(
                              color: GoMitraColors.greenDark,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: GoMitraColors.mint,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$savingsPercent% SAVED',
                      style: const TextStyle(
                        color: GoMitraColors.greenDark,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        FilledButton.icon(
          onPressed: onBookUber,
          icon: const RideProviderBadge(provider: 'uber', size: 18),
          label: const Text('Book Ride Together'),
          style: FilledButton.styleFrom(
            backgroundColor: GoMitraColors.green,
            minimumSize: const Size.fromHeight(54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onOpenChat,
          icon: const Icon(Icons.chat_bubble_outline, color: GoMitraColors.green),
          label: const Text(
            'Chat in Group',
            style: TextStyle(color: GoMitraColors.ink, fontWeight: FontWeight.w800),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            side: const BorderSide(color: GoMitraColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    );
  }
}

class MapPreview extends StatelessWidget {
  const MapPreview({
    required this.terminal,
    required this.destination,
    this.height = 160,
    this.meetingPointLabel,
    super.key,
  });

  final String terminal;
  final String destination;
  final double height;
  final String? meetingPointLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFE2ECE7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GoMitraColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPatternPainter(),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 28,
            child: _MapPin(
              label: terminal,
              color: GoMitraColors.blue,
              icon: Icons.flight_land,
            ),
          ),
          if (meetingPointLabel != null)
            Positioned(
              left: 110,
              top: 35,
              child: _MapPin(
                label: meetingPointLabel!,
                color: GoMitraColors.green,
                icon: Icons.meeting_room,
              ),
            ),
          Positioned(
            right: 28,
            top: 22,
            child: _MapPin(
              label: destination,
              color: GoMitraColors.green,
              icon: Icons.location_on,
            ),
          ),
          Positioned(
            left: 12,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map, size: 12, color: GoMitraColors.green),
                  SizedBox(width: 4),
                  Text(
                    'Interactive Live Route Preview',
                    style: TextStyle(fontSize: 10, color: GoMitraColors.ink, fontWeight: FontWeight.w700),
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

class _MapPin extends StatelessWidget {
  const _MapPin({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Color(0x1F000000), blurRadius: 6, offset: Offset(0, 2)),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Icon(icon, color: color, size: 28),
      ],
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final thin = Paint()
      ..color = const Color(0xFFC1D6CD)
      ..strokeWidth = 1.2;
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final route = Paint()
      ..color = GoMitraColors.green
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round;

    for (var i = -2; i < 9; i++) {
      final x = i * size.width / 6;
      canvas.drawLine(Offset(x, 0), Offset(x + 70, size.height), thin);
      final y = i * size.height / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 35), thin);
    }

    final mainRoad = Path()
      ..moveTo(0, size.height * 0.75)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.55,
        size.width * 0.48,
        size.height * 0.82,
        size.width,
        size.height * 0.35,
      );
    canvas.drawPath(mainRoad, road);

    final path = Path()
      ..moveTo(size.width * 0.16, size.height * 0.78)
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.86,
        size.width * 0.55,
        size.height * 0.28,
        size.width * 0.84,
        size.height * 0.25,
      );
    canvas.drawPath(path, route);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TerminalArchitecturalPainter extends CustomPainter {
  const _TerminalArchitecturalPainter({required this.terminal});

  final String terminal;

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF0F1713);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final linePaint = Paint()
      ..color = GoMitraColors.green.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    if (terminal == 'T2') {
      for (var i = 0; i < 6; i++) {
        final path = Path()
          ..moveTo(size.width * 0.3 + i * 40, size.height)
          ..quadraticBezierTo(
            size.width * 0.5 + i * 40,
            0,
            size.width * 0.7 + i * 40,
            size.height,
          );
        canvas.drawPath(path, linePaint);
      }
    } else {
      for (var i = 0; i < 8; i++) {
        final x = size.width * 0.4 + i * 30;
        canvas.drawLine(
          Offset(x, 0),
          Offset(x - 50, size.height),
          linePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
