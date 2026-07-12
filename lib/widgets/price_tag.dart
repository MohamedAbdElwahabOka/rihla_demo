import 'package:flutter/material.dart';
import '../theme.dart';
import '../utils/format.dart';

/// Struck-through original price + discounted price, per FR-021/036/060.
class PriceTag extends StatelessWidget {
  final num original;
  final num discounted;
  final double discountedFontSize;

  const PriceTag({
    super.key,
    required this.original,
    required this.discounted,
    this.discountedFontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatEur(original),
          style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey),
        ),
        const SizedBox(width: 6),
        Text(
          formatEur(discounted),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: RihlaColors.seaBlueDark,
            fontSize: discountedFontSize,
          ),
        ),
      ],
    );
  }
}
