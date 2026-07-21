import 'package:flutter/material.dart';

/// The favorite/heart glyph, with a brief scale-pop when it becomes favorited
/// and a smooth crossfade between the outline/filled states either way.
/// Visual only — callers keep their own tap handling (`IconButton`,
/// `GestureDetector`, etc.) so this drops into any of them unchanged.
class AnimatedFavoriteIcon extends StatefulWidget {
  final bool isFavorite;
  final double size;
  final Color color;

  const AnimatedFavoriteIcon({
    super.key,
    required this.isFavorite,
    required this.color,
    this.size = 20,
  });

  @override
  State<AnimatedFavoriteIcon> createState() => _AnimatedFavoriteIconState();
}

class _AnimatedFavoriteIconState extends State<AnimatedFavoriteIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      weight: 40,
      tween: Tween(begin: 1.0, end: 1.3).chain(CurveTween(curve: Curves.easeOutQuart)),
    ),
    TweenSequenceItem(
      weight: 60,
      tween: Tween(begin: 1.3, end: 1.0).chain(CurveTween(curve: Curves.easeOutQuart)),
    ),
  ]).animate(_controller);

  @override
  void didUpdateWidget(covariant AnimatedFavoriteIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only the "liking" transition gets the pop; un-favoriting just crossfades.
    if (widget.isFavorite &&
        !oldWidget.isFavorite &&
        !MediaQuery.of(context).disableAnimations) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final icon = Icon(
      widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
      key: ValueKey(widget.isFavorite),
      size: widget.size,
      color: widget.color,
    );
    final crossfaded = AnimatedSwitcher(
      duration: reduceMotion ? Duration.zero : const Duration(milliseconds: 180),
      child: icon,
    );
    if (reduceMotion) return crossfaded;
    return AnimatedBuilder(
      animation: _scale,
      builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
      child: crossfaded,
    );
  }
}
