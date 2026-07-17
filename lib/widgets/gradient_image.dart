import 'package:flutter/material.dart';
import '../theme.dart';

/// Placeholder-photo substitute: a sea-blue -> gold gradient with a category
/// icon and label. Used everywhere a real photo would appear (SRS demo has
/// no binary assets and no network imagery).
class GradientImage extends StatelessWidget {
  final IconData icon;
  final String label;
  final double? height;
  final double borderRadius;

  const GradientImage({
    super.key,
    required this.icon,
    required this.label,
    this.height,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: const BoxDecoration(gradient: RihlaColors.seaGradient),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Soft radial highlight in the upper-left for depth / a "sunlit
            // water" feel, so the placeholder never reads as a flat swatch.
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(-0.5, -0.7),
                  radius: 1.2,
                  colors: [Color(0x33FFFFFF), Color(0x00FFFFFF)],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white.withValues(alpha: 0.95), size: 40),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
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
