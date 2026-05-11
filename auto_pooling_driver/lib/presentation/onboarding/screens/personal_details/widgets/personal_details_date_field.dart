import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class PersonalDetailsDateField extends StatelessWidget {
  const PersonalDetailsDateField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.errorText,
    super.key,
  });

  final String label;
  final String value;
  final String placeholder;
  final VoidCallback onTap;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final bool hasValue = value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: AppTextStyles.p3Medium.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: context.currentTheme.backgroundSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.currentTheme.strokeSubtle),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    hasValue ? value : placeholder,
                    style: AppTextStyles.p1Medium.copyWith(
                      color: hasValue
                          ? context.currentTheme.textNeutralPrimary
                          : context.currentTheme.textNeutralSecondary,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: context.currentTheme.textNeutralSecondary,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...<Widget>[
          const SizedBox(height: 6),
          PersonalDetailsDateFieldError(errorText: errorText!),
        ],
      ],
    );
  }
}

class PersonalDetailsDateFieldError extends StatelessWidget {
  const PersonalDetailsDateFieldError({required this.errorText, super.key});

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorText,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.accentSecondary,
      ),
    );
  }
}
