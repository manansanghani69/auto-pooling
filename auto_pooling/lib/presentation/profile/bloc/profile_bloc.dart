import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/errors/api_failure.dart';
import '../../../shared_pref/pref_keys.dart';
import '../../../shared_pref/prefs.dart';
import '../domain/entities/profile_entity.dart';
import '../domain/usecases/profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileUseCase _profileUseCase;

  ProfileBloc({required ProfileUseCase profileUseCase})
      : _profileUseCase = profileUseCase,
        super(ProfileState.initial()) {
    _setupEventListener();
  }

  void _setupEventListener() {
    on<ProfileStartedEvent>(_onProfileStartedEvent);
    on<ProfileNameChangedEvent>(_onProfileNameChangedEvent);
    on<ProfileEmailChangedEvent>(_onProfileEmailChangedEvent);
    on<ProfileGenderChangedEvent>(_onProfileGenderChangedEvent);
    on<ProfilePhotoChangedEvent>(_onProfilePhotoChangedEvent);
    on<ProfileContinuePressedEvent>(_onProfileContinuePressedEvent);
  }

  Future<void> _onProfileStartedEvent(
    ProfileStartedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    final String savedName = await Prefs.getString(PrefKeys.profileName) ?? '';
    final String savedEmail =
        await Prefs.getString(PrefKeys.profileEmail) ?? '';
    final String? savedGenderValue =
        await Prefs.getString(PrefKeys.profileGender);
    final ProfileGender? savedGender = _genderFromString(savedGenderValue);
    final bool isEditing = event.isEditing ||
        savedName.trim().isNotEmpty ||
        savedEmail.trim().isNotEmpty ||
        savedGender != null;

    emit(
      state.copyWith(
        status: ProfileStatus.ready,
        fullName: savedName,
        email: savedEmail,
        gender: savedGender,
        isEditing: isEditing,
        errorMessage: '',
      ),
    );
  }

  void _onProfileNameChangedEvent(
    ProfileNameChangedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (event.fullName == state.fullName) {
      return;
    }
    emit(state.copyWith(fullName: event.fullName, errorMessage: ''));
  }

  void _onProfileEmailChangedEvent(
    ProfileEmailChangedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (event.email == state.email) {
      return;
    }
    emit(state.copyWith(email: event.email, errorMessage: ''));
  }

  void _onProfileGenderChangedEvent(
    ProfileGenderChangedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (event.gender == state.gender) {
      return;
    }
    emit(state.copyWith(gender: event.gender, errorMessage: ''));
  }

  void _onProfilePhotoChangedEvent(
    ProfilePhotoChangedEvent event,
    Emitter<ProfileState> emit,
  ) {
    if (event.photoPath == state.photoPath) {
      return;
    }
    emit(state.copyWith(photoPath: event.photoPath, errorMessage: ''));
  }

  Future<void> _onProfileContinuePressedEvent(
    ProfileContinuePressedEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.status == ProfileStatus.saving) {
      return;
    }
    final String trimmedName = state.fullName.trim();
    if (trimmedName.isEmpty) {
      return;
    }
    if (!_isEmailValid(state.email)) {
      return;
    }

    emit(state.copyWith(status: ProfileStatus.saving, errorMessage: ''));

    final String trimmedEmail = state.email.trim();
    final String? apiEmail = trimmedEmail.isEmpty ? null : trimmedEmail;
    final String? apiGender = _genderToApiValue(state.gender);

    final result = await _profileUseCase.updateProfile(
      name: trimmedName,
      email: apiEmail,
      gender: apiGender,
    );

    final Object? failure = result.error;
    if (failure != null) {
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          errorMessage: _mapFailureMessage(failure),
        ),
      );
      return;
    }

    final ProfileEntity? profile = result.data;
    if (profile == null) {
      emit(
        state.copyWith(
          status: ProfileStatus.ready,
          errorMessage: 'Unknown error',
        ),
      );
      return;
    }
    await _persistProfile(profile);

    emit(
      state.copyWith(
        status: ProfileStatus.saved,
        isEditing: true,
        fullName: profile.name,
        email: profile.email ?? '',
        gender: _genderFromString(profile.gender),
        errorMessage: '',
      ),
    );
  }

  ProfileGender? _genderFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'male':
        return ProfileGender.male;
      case 'female':
        return ProfileGender.female;
      case 'other':
        return ProfileGender.other;
    }
    return null;
  }

  String? _genderToApiValue(ProfileGender? gender) {
    switch (gender) {
      case ProfileGender.male:
        return 'Male';
      case ProfileGender.female:
        return 'Female';
      case ProfileGender.other:
        return 'Other';
      case null:
        return null;
    }
  }

  String _genderToString(ProfileGender gender) {
    switch (gender) {
      case ProfileGender.male:
        return 'male';
      case ProfileGender.female:
        return 'female';
      case ProfileGender.other:
        return 'other';
    }
  }

  bool _isEmailValid(String email) {
    final String trimmed = email.trim();
    if (trimmed.isEmpty) {
      return true;
    }
    final RegExp regex =
        RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
    return regex.hasMatch(trimmed);
  }

  Future<void> _persistProfile(ProfileEntity profile) async {
    final String trimmedName = profile.name.trim();
    if (trimmedName.isEmpty) {
      await Prefs.remove(PrefKeys.profileName);
    } else {
      await Prefs.setString(PrefKeys.profileName, trimmedName);
    }

    final String trimmedEmail = profile.email?.trim() ?? '';
    if (trimmedEmail.isEmpty) {
      await Prefs.remove(PrefKeys.profileEmail);
    } else {
      await Prefs.setString(PrefKeys.profileEmail, trimmedEmail);
    }

    final ProfileGender? parsedGender = _genderFromString(profile.gender);
    if (parsedGender == null) {
      await Prefs.remove(PrefKeys.profileGender);
    } else {
      await Prefs.setString(
        PrefKeys.profileGender,
        _genderToString(parsedGender),
      );
    }
  }

  String _mapFailureMessage(Object failure) {
    if (failure is APIFailure) {
      return failure.errorMessage;
    }
    return failure.toString();
  }
}
