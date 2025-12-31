import 'package:flutter/material.dart';

import 'styling/app_colors.dart';

class AppBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;

  const AppBackButton({
    this.onPressed,
    this.size = 40.0,
    this.iconSize = 22.0,
    this.borderRadius = 20.0,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground =
        backgroundColor ?? context.currentTheme.backgroundPrimary.withAlpha(102);
    final Color resolvedBorder =
        borderColor ?? context.currentTheme.textNeutralSecondary.withAlpha(51);
    final Color resolvedIcon =
        iconColor ?? context.currentTheme.textNeutralPrimary;

    return SizedBox(
      height: size,
      width: size,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: resolvedBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: resolvedBorder),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: onPressed ?? () => Navigator.of(context).maybePop(),
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: resolvedIcon,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
