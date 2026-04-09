import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class OnboardingTextField extends StatelessWidget {
  const OnboardingTextField({
    required this.label,
    required this.onChanged,
    this.initialValue,
    this.hintText,
    this.keyboardType,
    this.maxLines = 1,
    this.readOnly = false,
    this.suffix,
    super.key,
  });

  final String label;
  final String? initialValue;
  final String? hintText;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool readOnly;
  final Widget? suffix;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: context.currentTheme.strokeSubtle),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        TextFormField(
          key: ValueKey<String>('$label-${initialValue ?? ''}'),
          initialValue: initialValue,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffix,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: BorderSide(color: context.currentTheme.accentPrimary),
            ),
            fillColor: context.currentTheme.backgroundSurface,
            filled: true,
          ),
        ),
      ],
    );
  }
}
