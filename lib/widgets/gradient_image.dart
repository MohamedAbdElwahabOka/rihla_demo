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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [RihlaColors.seaBlue, RihlaColors.gold],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
