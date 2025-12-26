import 'package:auto_pooling/common/theme/text_style/app_text_styles.dart';
import 'package:auto_pooling/widgets/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final TextStyle defaultTextStyle;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool enableInteractiveSelection;
  final int? maxLines;
  final int? minLines;
  final TextAlign textAlign;
  final AutovalidateMode? autovalidateMode;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const PrimaryTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.defaultTextStyle = AppTextStyles.p2Regular,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.enableInteractiveSelection = true,
    this.maxLines = 1,
    this.minLines,
    this.textAlign = TextAlign.start,
    this.autovalidateMode,
    this.height = 56.0,
    this.borderRadius = 12.0,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color resolvedFillColor =
        fillColor ?? Theme.of(context).colorScheme.surface;
    final Color resolvedBorderColor =
        borderColor ??
        context.currentTheme.textNeutralSecondary.withAlpha(51);
    final Color resolvedFocusedColor =
        focusedBorderColor ?? context.currentTheme.primary;
    final TextStyle baseTextStyle = textStyle ?? defaultTextStyle;
    final TextStyle resolvedTextStyle = baseTextStyle.copyWith(
      color: baseTextStyle.color ?? context.currentTheme.textNeutralPrimary,
    );
    final TextStyle resolvedHintStyle = hintStyle ??
        defaultTextStyle.copyWith(
          color: context.currentTheme.textNeutralSecondary,
        );
    final BorderRadius resolvedRadius = BorderRadius.circular(borderRadius);
    final BorderSide enabledBorderSide = BorderSide(
      color: resolvedBorderColor,
      width: 2,
    );
    final BorderSide focusedBorderSide = BorderSide(
      color: resolvedFocusedColor,
      width: 2,
    );
    final BorderSide errorBorderSide = BorderSide(
      color: context.currentTheme.error,
      width: 2,
    );

    final InputDecoration decoration = InputDecoration(
      hintText: hintText,
      hintStyle: resolvedHintStyle,
      filled: true,
      fillColor: resolvedFillColor,
      contentPadding: contentPadding,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: resolvedRadius,
        borderSide: enabledBorderSide,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: resolvedRadius,
        borderSide: focusedBorderSide,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: resolvedRadius,
        borderSide: errorBorderSide,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: resolvedRadius,
        borderSide: errorBorderSide,
      ),
    );

    final Widget field = TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      readOnly: readOnly,
      enabled: enabled,
      autocorrect: autocorrect,
      enableSuggestions: enableSuggestions,
      enableInteractiveSelection: enableInteractiveSelection,
      maxLines: maxLines,
      minLines: minLines,
      textAlign: textAlign,
      style: resolvedTextStyle,
      validator: validator,
      autovalidateMode: autovalidateMode,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      decoration: decoration,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
    );

    if (height == null) {
      return field;
    }

    return SizedBox(height: height, child: field);
  }
}
