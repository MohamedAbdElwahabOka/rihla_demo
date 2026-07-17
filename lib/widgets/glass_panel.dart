import 'dart:ui';
import 'package:flutter/material.dart';

/// A frosted-glass surface: translucent, backdrop-blurred, with a hairline
/// highlight border. Designed to float over imagery — e.g. the info panel on
/// the experience cards on the Home screen. Content placed inside should use
/// light (white) text, since the panel sits over photography.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double blur;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 14,
    this.blur = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            // A whisper of deep-sea tint under the frost keeps white text
            // legible over bright photography while staying translucent.
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.22),
                const Color(0xFF023E58).withValues(alpha: 0.28),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          child: child,
        ),
      ),
    );
  }
}
