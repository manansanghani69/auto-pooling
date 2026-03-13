import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/theme/text_style/app_text_styles.dart';
import '../../../i18n/localization.dart';
import '../../../widgets/app_back_button.dart';
import '../../../widgets/primary_button.dart';
import '../../../widgets/primary_text_field.dart';
import '../../../widgets/styling/app_colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../constants/profile_constants.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      top: false,
      child: ProfileScrollableContent(),
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: const ProfileAppBarTitle(),
      leadingWidth: ProfileConstants.appBarLeadingWidth,
      leading: const Padding(
        padding: EdgeInsets.only(left: ProfileConstants.appBarPadding),
        child: ProfileAppBarBackButton(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileAppBarBackButton extends StatelessWidget {
  const ProfileAppBarBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppBackButton();
  }
}

class ProfileAppBarTitle extends StatelessWidget {
  const ProfileAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEditing = context.select<ProfileBloc, bool>(
      (bloc) => bloc.state.isEditing,
    );
    final String title = isEditing
        ? context.localization.profileEditAppBarTitle
        : context.localization.profileCompleteAppBarTitle;

    return Text(
      title,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: context.currentTheme.textNeutralPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class ProfileScrollableContent extends StatelessWidget {
  const ProfileScrollableContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        ProfileConstants.horizontalPadding,
        0,
        ProfileConstants.horizontalPadding,
        ProfileConstants.bottomContentPadding,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeadlineSection(),
          SizedBox(height: ProfileConstants.subheadBottomSpacing),
          ProfileAvatarSection(),
          SizedBox(height: ProfileConstants.sectionSpacing),
          ProfileFormSection(),
        ],
      ),
    );
  }
}

class ProfileHeadlineSection extends StatelessWidget {
  const ProfileHeadlineSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: ProfileConstants.headlineTopPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeadlineText(),
          SizedBox(height: ProfileConstants.headlineBottomSpacing),
          ProfileSubheadlineText(),
        ],
      ),
    );
  }
}

class ProfileHeadlineText extends StatelessWidget {
  const ProfileHeadlineText({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEditing = context.select<ProfileBloc, bool>(
      (bloc) => bloc.state.isEditing,
    );
    final String headline = isEditing
        ? context.localization.profileEditHeadline
        : context.localization.profileCompleteHeadline;

    return Text(
      headline,
      style: AppTextStyles.h2SemiBold.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.15,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class ProfileSubheadlineText extends StatelessWidget {
  const ProfileSubheadlineText({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isEditing = context.select<ProfileBloc, bool>(
      (bloc) => bloc.state.isEditing,
    );
    final String subtitle = isEditing
        ? context.localization.profileEditSubtitle
        : context.localization.profileCompleteSubtitle;

    return Text(
      subtitle,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: 16,
        height: 1.5,
        color: context.currentTheme.textNeutralSecondary,
      ),
    );
  }
}

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: ProfilePhotoPicker());
  }
}

class ProfilePhotoPicker extends StatelessWidget {
  const ProfilePhotoPicker({super.key});

  Future<void> _openPhotoPicker(BuildContext context) async {
    final ProfilePhotoSource? source =
        await showModalBottomSheet<ProfilePhotoSource>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (context) => const ProfilePhotoSourceSheet(),
    );
    if (source == null) {
      return;
    }
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(
      source: source == ProfilePhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null || !context.mounted) {
      return;
    }
    context
        .read<ProfileBloc>()
        .add(ProfilePhotoChangedEvent(photoPath: file.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileAvatarStack(onTap: () => _openPhotoPicker(context)),
        const SizedBox(height: ProfileConstants.avatarLabelSpacing),
        ProfileAvatarUploadAction(onTap: () => _openPhotoPicker(context)),
      ],
    );
  }
}

class ProfileAvatarStack extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileAvatarStack({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const SizedBox(
        height: ProfileConstants.avatarSize,
        width: ProfileConstants.avatarSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ProfileAvatarFrame(),
            Positioned(
              bottom: -2,
              right: -2,
              child: ProfileAvatarCameraBadge(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileAvatarFrame extends StatelessWidget {
  const ProfileAvatarFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ProfileConstants.avatarSize,
      width: ProfileConstants.avatarSize,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: ProfileConstants.avatarBorderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: ProfileConstants.avatarShadowBlur,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const ClipOval(child: ProfileAvatarContent()),
    );
  }
}

class ProfileAvatarContent extends StatelessWidget {
  const ProfileAvatarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final String? photoPath = context.select<ProfileBloc, String?>(
      (bloc) => bloc.state.photoPath,
    );
    if (photoPath == null || photoPath.isEmpty) {
      return const ProfileAvatarPlaceholder();
    }
    return ProfileAvatarImage(path: photoPath);
  }
}

class ProfileAvatarImage extends StatelessWidget {
  final String path;

  const ProfileAvatarImage({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
    );
  }
}

class ProfileAvatarPlaceholder extends StatelessWidget {
  const ProfileAvatarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.currentTheme.textNeutralSecondary.withAlpha(25),
      child: const Center(child: ProfileAvatarPlaceholderIcon()),
    );
  }
}

class ProfileAvatarPlaceholderIcon extends StatelessWidget {
  const ProfileAvatarPlaceholderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.person,
      size: 64,
      color: context.currentTheme.textNeutralSecondary.withAlpha(120),
    );
  }
}

class ProfileAvatarCameraBadge extends StatelessWidget {
  const ProfileAvatarCameraBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ProfileConstants.avatarBadgeSize,
      width: ProfileConstants.avatarBadgeSize,
      decoration: BoxDecoration(
        color: context.currentTheme.primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: ProfileConstants.avatarBadgeBorderWidth,
        ),
      ),
      child: const Center(child: ProfileAvatarCameraIcon()),
    );
  }
}

class ProfileAvatarCameraIcon extends StatelessWidget {
  const ProfileAvatarCameraIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.photo_camera,
      size: ProfileConstants.avatarBadgeIconSize,
      color: Colors.white,
    );
  }
}

class ProfileAvatarUploadAction extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileAvatarUploadAction({required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        context.localization.profileUploadPhoto,
        style: AppTextStyles.p3Medium.copyWith(
          color: context.currentTheme.primary,
        ),
      ),
    );
  }
}

class ProfileFormSection extends StatelessWidget {
  const ProfileFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileNameField(),
        SizedBox(height: ProfileConstants.fieldSpacing),
        ProfileEmailField(),
        SizedBox(height: ProfileConstants.fieldSpacing),
        ProfileGenderSection(),
      ],
    );
  }
}

class ProfileNameField extends StatefulWidget {
  const ProfileNameField({super.key});

  @override
  State<ProfileNameField> createState() => _ProfileNameFieldState();
}

class _ProfileNameFieldState extends State<ProfileNameField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(String value) {
    if (_controller.text == value) {
      return;
    }
    _controller.value = _controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  String? _validateName(BuildContext context, String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return context.localization.profileNameRequiredError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = context.select<ProfileBloc, String>(
      (bloc) => bloc.state.fullName,
    );
    _syncController(fullName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFieldLabel(text: context.localization.profileFullNameLabel),
        const SizedBox(height: ProfileConstants.fieldLabelSpacing),
        PrimaryTextField(
          controller: _controller,
          height: ProfileConstants.inputFieldHeight,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          validator: (value) => _validateName(context, value),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileNameChangedEvent(fullName: value)),
          hintText: context.localization.profileFullNameHint,
          textStyle: AppTextStyles.p2Regular.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
          borderRadius: ProfileConstants.inputFieldRadius,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: const ProfileFieldSuffixIcon(icon: Icons.person),
        ),
      ],
    );
  }
}

class ProfileEmailField extends StatefulWidget {
  const ProfileEmailField({super.key});

  @override
  State<ProfileEmailField> createState() => _ProfileEmailFieldState();
}

class _ProfileEmailFieldState extends State<ProfileEmailField> {
  late final TextEditingController _controller;
  static final RegExp _emailRegex =
      RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _syncController(String value) {
    if (_controller.text == value) {
      return;
    }
    _controller.value = _controller.value.copyWith(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
      composing: TextRange.empty,
    );
  }

  String? _validateEmail(BuildContext context, String? value) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return context.localization.profileEmailInvalidError;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final String email = context.select<ProfileBloc, String>(
      (bloc) => bloc.state.email,
    );
    _syncController(email);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileFieldLabel(text: context.localization.profileEmailLabel),
        const SizedBox(height: ProfileConstants.fieldLabelSpacing),
        PrimaryTextField(
          controller: _controller,
          height: ProfileConstants.inputFieldHeight,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          validator: (value) => _validateEmail(context, value),
          onChanged: (value) => context
              .read<ProfileBloc>()
              .add(ProfileEmailChangedEvent(email: value)),
          hintText: context.localization.profileEmailHint,
          textStyle: AppTextStyles.p2Regular.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: AppTextStyles.p2Regular.copyWith(
            color: context.currentTheme.textNeutralSecondary,
          ),
          borderRadius: ProfileConstants.inputFieldRadius,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          suffixIcon: const ProfileFieldSuffixIcon(icon: Icons.mail),
        ),
      ],
    );
  }
}

class ProfileFieldLabel extends StatelessWidget {
  final String text;

  const ProfileFieldLabel({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.p3Medium.copyWith(
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}

class ProfileFieldSuffixIcon extends StatelessWidget {
  final IconData icon;

  const ProfileFieldSuffixIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 20,
      color: context.currentTheme.textNeutralSecondary,
    );
  }
}

class ProfileGenderSection extends StatelessWidget {
  const ProfileGenderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProfileGenderLabel(),
        SizedBox(height: ProfileConstants.fieldLabelSpacing),
        ProfileGenderOptionsRow(),
      ],
    );
  }
}

class ProfileGenderLabel extends StatelessWidget {
  const ProfileGenderLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle = AppTextStyles.p3Medium.copyWith(
      color: context.currentTheme.textNeutralPrimary,
    );
    final TextStyle optionalStyle = AppTextStyles.p3Medium.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: context.currentTheme.textNeutralSecondary,
    );

    return Text.rich(
      TextSpan(
        text: context.localization.profileGenderLabel,
        children: [
          TextSpan(
            text: ' (${context.localization.profileOptionalLabel})',
            style: optionalStyle,
          ),
        ],
      ),
      style: labelStyle,
    );
  }
}

class ProfileGenderOptionsRow extends StatelessWidget {
  const ProfileGenderOptionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ProfileGenderOption(
            gender: ProfileGender.male,
            icon: Icons.male,
            label: context.localization.profileGenderMale,
          ),
        ),
        const SizedBox(width: ProfileConstants.genderOptionSpacing),
        Expanded(
          child: ProfileGenderOption(
            gender: ProfileGender.female,
            icon: Icons.female,
            label: context.localization.profileGenderFemale,
          ),
        ),
        const SizedBox(width: ProfileConstants.genderOptionSpacing),
        Expanded(
          child: ProfileGenderOption(
            gender: ProfileGender.other,
            icon: Icons.transgender,
            label: context.localization.profileGenderOther,
          ),
        ),
      ],
    );
  }
}

class ProfileGenderOption extends StatelessWidget {
  final ProfileGender gender;
  final IconData icon;
  final String label;

  const ProfileGenderOption({
    required this.gender,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProfileGender? selectedGender =
        context.select<ProfileBloc, ProfileGender?>(
      (bloc) => bloc.state.gender,
    );
    final bool isSelected = selectedGender == gender;
    final Color borderColor = isSelected
        ? context.currentTheme.primary
        : context.currentTheme.textNeutralSecondary.withAlpha(51);
    final Color backgroundColor = isSelected
        ? context.currentTheme.primary.withAlpha(20)
        : Theme.of(context).colorScheme.surface;
    final Color foregroundColor = isSelected
        ? context.currentTheme.primary
        : context.currentTheme.textNeutralPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ProfileConstants.inputFieldRadius),
        onTap: () => context
            .read<ProfileBloc>()
            .add(ProfileGenderChangedEvent(gender: gender)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius:
                BorderRadius.circular(ProfileConstants.inputFieldRadius),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProfileGenderIcon(icon: icon, color: foregroundColor),
              const SizedBox(height: 6),
              ProfileGenderText(label: label, color: foregroundColor),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileGenderIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const ProfileGenderIcon({
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 24, color: color);
  }
}

class ProfileGenderText extends StatelessWidget {
  final String label;
  final Color color;

  const ProfileGenderText({
    required this.label,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.p3Medium.copyWith(color: color),
      textAlign: TextAlign.center,
    );
  }
}

class ProfileBottomBar extends StatelessWidget {
  const ProfileBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(ProfileConstants.bottomBarPadding),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProfileContinueButton(),
              SizedBox(height: ProfileConstants.bottomBarSpacing),
              ProfileTermsText(),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileContinueButton extends StatelessWidget {
  const ProfileContinueButton({super.key});

  void _handleTap(BuildContext context) {
    final FormState? formState = Form.of(context);
    if (formState == null || !formState.validate()) {
      return;
    }
    context.read<ProfileBloc>().add(const ProfileContinuePressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final bool canContinue = context.select<ProfileBloc, bool>((bloc) {
      final ProfileState state = bloc.state;
      return state.fullName.trim().isNotEmpty &&
          state.status != ProfileStatus.saving;
    });
    final bool isEditing = context.select<ProfileBloc, bool>(
      (bloc) => bloc.state.isEditing,
    );
    final String buttonText = isEditing
        ? context.localization.profileSaveButton
        : context.localization.profileContinueButton;

    return PrimaryButton(
      onPressed: canContinue ? () => _handleTap(context) : null,
      buttonText: buttonText,
      icon: Icons.arrow_forward,
    );
  }
}

class ProfileTermsText extends StatelessWidget {
  const ProfileTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    final TextStyle baseStyle = AppTextStyles.p3Medium.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: context.currentTheme.textNeutralSecondary,
    );
    final TextStyle linkStyle = baseStyle.copyWith(
      decoration: TextDecoration.underline,
      decorationColor: context.currentTheme.textNeutralSecondary.withAlpha(120),
      color: context.currentTheme.textNeutralSecondary,
    );

    return Text.rich(
      TextSpan(
        text: context.localization.profileTermsPrefix,
        style: baseStyle,
        children: [
          TextSpan(
            text: context.localization.profileTermsOfService,
            style: linkStyle,
          ),
          TextSpan(text: context.localization.profileTermsAnd),
          TextSpan(
            text: context.localization.profileTermsPrivacy,
            style: linkStyle,
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}

enum ProfilePhotoSource {
  camera,
  gallery,
}

class ProfilePhotoSourceSheet extends StatelessWidget {
  const ProfilePhotoSourceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfilePhotoSourceOption(
              source: ProfilePhotoSource.camera,
              icon: Icons.photo_camera,
              label: context.localization.profilePhotoCamera,
            ),
            const SizedBox(height: 12),
            ProfilePhotoSourceOption(
              source: ProfilePhotoSource.gallery,
              icon: Icons.photo_library,
              label: context.localization.profilePhotoGallery,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePhotoSourceOption extends StatelessWidget {
  final ProfilePhotoSource source;
  final IconData icon;
  final String label;

  const ProfilePhotoSourceOption({
    required this.source,
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(ProfileConstants.inputFieldRadius),
        onTap: () => Navigator.of(context).pop(source),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(ProfileConstants.inputFieldRadius),
            border: Border.all(
              color: context.currentTheme.textNeutralSecondary.withAlpha(51),
            ),
          ),
          child: Row(
            children: [
              ProfilePhotoSourceIcon(icon: icon),
              const SizedBox(width: 12),
              ProfilePhotoSourceLabel(label: label),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePhotoSourceIcon extends StatelessWidget {
  final IconData icon;

  const ProfilePhotoSourceIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: context.currentTheme.primary,
      size: 22,
    );
  }
}

class ProfilePhotoSourceLabel extends StatelessWidget {
  final String label;

  const ProfilePhotoSourceLabel({required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.p2Regular.copyWith(
        fontSize: 16,
        color: context.currentTheme.textNeutralPrimary,
      ),
    );
  }
}
