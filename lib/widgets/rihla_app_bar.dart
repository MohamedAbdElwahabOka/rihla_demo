import 'package:flutter/material.dart';
import '../theme.dart';

/// Branded app bar with the sea gradient wash behind it. Drop-in replacement
/// for [AppBar] on pushed screens so the whole app shares one header language.
class RihlaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final PreferredSizeWidget? bottom;

  const RihlaAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = false,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: RihlaColors.seaGradient),
      child: AppBar(
        backgroundColor: Colors.transparent,
        title: title,
        actions: actions,
        leading: leading,
        centerTitle: centerTitle,
        bottom: bottom,
      ),
    );
  }
}
