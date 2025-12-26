import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../widgets/styling/app_colors.dart';
import '../constants/auth_constants.dart';

class AuthBackButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AuthBackButton({this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AuthConstants.backButtonSize,
      width: AuthConstants.backButtonSize,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: context.currentTheme.backgroundPrimary.withAlpha(102),
            borderRadius: BorderRadius.circular(AuthConstants.backButtonRadius),
            border: Border.all(
              color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(AuthConstants.backButtonRadius),
            onTap: onPressed ?? () => context.router.maybePop(),
            child: Center(
              child: Icon(
                Icons.arrow_back,
                color: context.currentTheme.textNeutralPrimary,
                size: AuthConstants.backButtonIconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
