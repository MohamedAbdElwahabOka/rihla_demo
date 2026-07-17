import 'package:flutter/material.dart';
import '../theme.dart';

/// Small rounded label used for "Featured", discounts, cuisine tags, etc.
/// [RihlaBadge.sunset] floats a gold→coral gradient chip (for hero/promo
/// labels over photography); [RihlaBadge.soft] is a tinted, subtle chip for
/// inline metadata.
class RihlaBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Gradient? gradient;
  final Color? background;
  final Color foreground;

  const RihlaBadge({
    super.key,
    required this.label,
    this.icon,
    this.gradient,
    this.background,
    this.foreground = Colors.white,
  });

  const RihlaBadge.sunset(this.label, {super.key, this.icon})
      : gradient = RihlaColors.sunsetGradient,
        background = null,
        foreground = Colors.white;

  const RihlaBadge.soft(this.label, {super.key, this.icon})
      : gradient = null,
        background = RihlaColors.seaTint,
        foreground = RihlaColors.seaBlueDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        gradient: gradient,
        color: background,
        borderRadius: BorderRadius.circular(RihlaSpace.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foreground,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
