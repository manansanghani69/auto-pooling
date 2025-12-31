import 'profile_state.dart';

abstract class ProfileEvent {
  const ProfileEvent();
}

class ProfileStartedEvent extends ProfileEvent {
  final bool isEditing;

  const ProfileStartedEvent({this.isEditing = false});
}

class ProfileNameChangedEvent extends ProfileEvent {
  final String fullName;

  const ProfileNameChangedEvent({required this.fullName});
}

class ProfileEmailChangedEvent extends ProfileEvent {
  final String email;

  const ProfileEmailChangedEvent({required this.email});
}

class ProfileGenderChangedEvent extends ProfileEvent {
  final ProfileGender gender;

  const ProfileGenderChangedEvent({required this.gender});
}

class ProfilePhotoChangedEvent extends ProfileEvent {
  final String? photoPath;

  const ProfilePhotoChangedEvent({required this.photoPath});
}

class ProfileContinuePressedEvent extends ProfileEvent {
  const ProfileContinuePressedEvent();
}
