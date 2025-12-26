import 'package:flutter/material.dart';

import 'package:auto_pooling/common/theme/text_style/app_text_styles.dart';
import 'package:auto_pooling/widgets/styling/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final IconData? icon;
  final double width;
  final double height;
  final double borderRadius;
  final double iconSize;
  final double iconSpacing;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    required this.onPressed,
    super.key,
    required this.buttonText,
    this.icon,
    this.width = double.infinity,
    this.height = 48.0,
    this.borderRadius = 12.0,
    this.iconSize = 16.0,
    this.iconSpacing = 8.0,
    this.elevation = 4.0,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedBackground =
        backgroundColor ?? context.currentTheme.primary;
    final Color resolvedForeground = foregroundColor ?? Colors.white;
    final Color resolvedShadow =
        shadowColor ?? resolvedBackground.withAlpha(76);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: resolvedBackground,
          foregroundColor: resolvedForeground,
          elevation: elevation,
          shadowColor: resolvedShadow,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: PrimaryButtonContent(
          buttonText: buttonText,
          icon: icon,
          iconSize: iconSize,
          iconSpacing: iconSpacing,
          textStyle: textStyle,
          foregroundColor: resolvedForeground,
        ),
      ),
    );
  }
}

class PrimaryButtonContent extends StatelessWidget {
  final String buttonText;
  final IconData? icon;
  final double iconSize;
  final double iconSpacing;
  final TextStyle? textStyle;
  final Color foregroundColor;

  const PrimaryButtonContent({
    super.key,
    required this.buttonText,
    required this.icon,
    required this.iconSize,
    required this.iconSpacing,
    required this.textStyle,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [
      PrimaryButtonLabel(
        buttonText: buttonText,
        textStyle: textStyle,
        foregroundColor: foregroundColor,
      ),
    ];
    if (icon != null) {
      children.add(SizedBox(width: iconSpacing));
      children.add(
        PrimaryButtonIcon(
          icon: icon!,
          iconSize: iconSize,
          foregroundColor: foregroundColor,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class PrimaryButtonLabel extends StatelessWidget {
  final String buttonText;
  final TextStyle? textStyle;
  final Color foregroundColor;

  const PrimaryButtonLabel({
    super.key,
    required this.buttonText,
    required this.textStyle,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle resolvedStyle =
        (textStyle ?? AppTextStyles.p2Regular.copyWith(
          fontWeight: FontWeight.w600,
        )).copyWith(color: foregroundColor);

    return Text(buttonText, style: resolvedStyle);
  }
}

class PrimaryButtonIcon extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color foregroundColor;

  const PrimaryButtonIcon({
    super.key,
    required this.icon,
    required this.iconSize,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: iconSize, color: foregroundColor);
  }
}
