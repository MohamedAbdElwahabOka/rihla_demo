import 'package:flutter/material.dart';
import 'gradient_image.dart';

/// A bundled asset photo that uses [GradientImage] as its fallback whenever the
/// asset is missing — an empty [path], or a category whose photos haven't been
/// added yet (e.g. spa). It never shows a broken-image glyph, so an offline
/// demo always looks intentional. Drop-in replacement for [GradientImage] plus
/// an asset [path].
class LocalImage extends StatelessWidget {
  final String path;
  final IconData icon;
  final String label;
  final double? height;
  final double borderRadius;

  const LocalImage({
    super.key,
    required this.path,
    required this.icon,
    required this.label,
    this.height,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = GradientImage(icon: icon, label: label, height: height, borderRadius: borderRadius);
    if (path.isEmpty) return fallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          path,
          fit: BoxFit.cover,
          height: height,
          width: double.infinity,
          errorBuilder: (context, error, stack) => fallback,
        ),
      ),
    );
  }
}
