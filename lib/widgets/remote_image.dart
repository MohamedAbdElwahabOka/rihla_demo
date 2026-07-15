import 'package:flutter/material.dart';
import 'gradient_image.dart';

/// A network photo that uses [GradientImage] as both its loading placeholder
/// and its error fallback. If there is no connectivity (e.g. during an
/// offline demo) it silently degrades to the gradient look — never a broken
/// image glyph. Drop-in replacement for [GradientImage] plus a [url].
class RemoteImage extends StatelessWidget {
  final String url;
  final IconData icon;
  final String label;
  final double? height;
  final double borderRadius;

  const RemoteImage({
    super.key,
    required this.url,
    required this.icon,
    required this.label,
    this.height,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = GradientImage(icon: icon, label: label, height: height, borderRadius: borderRadius);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          height: height,
          width: double.infinity,
          loadingBuilder: (context, child, progress) => progress == null ? child : fallback,
          errorBuilder: (context, error, stack) => fallback,
        ),
      ),
    );
  }
}
