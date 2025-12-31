enum ProfileStatus {
  initial,
  loading,
  ready,
  saving,
  saved,
}

enum ProfileGender {
  male,
  female,
  other,
}

class ProfileState {
  final ProfileStatus status;
  final String fullName;
  final String email;
  final ProfileGender? gender;
  final String? photoPath;
  final bool isEditing;
  final String errorMessage;

  const ProfileState({
    required this.status,
    required this.fullName,
    required this.email,
    required this.gender,
    required this.photoPath,
    required this.isEditing,
    required this.errorMessage,
  });

  factory ProfileState.initial() => const ProfileState(
        status: ProfileStatus.initial,
        fullName: '',
        email: '',
        gender: null,
        photoPath: null,
        isEditing: false,
        errorMessage: '',
      );

  ProfileState copyWith({
    ProfileStatus? status,
    String? fullName,
    String? email,
    ProfileGender? gender,
    String? photoPath,
    bool? isEditing,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      photoPath: photoPath ?? this.photoPath,
      isEditing: isEditing ?? this.isEditing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
