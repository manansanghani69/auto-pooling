import 'package:auto_pooling_driver/common/theme/app_text_styles.dart';
import 'package:auto_pooling_driver/core/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

class DriverLoginFooter extends StatelessWidget {
  const DriverLoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
      child: const Column(
        children: <Widget>[
          DriverLoginTermsNote(),
          SizedBox(height: 18),
          DriverLoginHelpButton(),
        ],
      ),
    );
  }
}

class DriverLoginTermsNote extends StatelessWidget {
  const DriverLoginTermsNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.authTermsAgreement,
      textAlign: TextAlign.center,
      style: AppTextStyles.p2Regular.copyWith(
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class DriverLoginHelpButton extends StatelessWidget {
  const DriverLoginHelpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext dialogContext) {
            return const DriverLoginHelpDialog();
          },
        );
      },
      icon: const Icon(Icons.help_outline_rounded),
      label: Text(context.localization.authHelpAction),
    );
  }
}

class DriverLoginHelpDialog extends StatelessWidget {
  const DriverLoginHelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.localization.authHelpTitle),
      content: Text(context.localization.authHelpDescription),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.localization.commonOkAction),
        ),
      ],
    );
  }
}
