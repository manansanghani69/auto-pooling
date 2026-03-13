import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:auto_pooling/core/errors/api_failure.dart';
import 'package:auto_pooling/core/services/injection_container.dart';
import 'package:auto_pooling/core/usecase/result.dart';
import 'package:auto_pooling/presentation/profile/bloc/profile_bloc.dart';
import 'package:auto_pooling/presentation/profile/bloc/profile_event.dart';
import 'package:auto_pooling/presentation/profile/bloc/profile_state.dart';
import 'package:auto_pooling/presentation/profile/domain/entities/profile_entity.dart';
import 'package:auto_pooling/presentation/profile/domain/repositories/profile_repository.dart';
import 'package:auto_pooling/presentation/profile/domain/usecases/profile_usecase.dart';
import 'package:auto_pooling/shared_pref/pref_keys.dart';
import 'package:auto_pooling/shared_pref/prefs.dart';

typedef UpdateProfileHandler = ResultFuture<ProfileEntity> Function(
  String name,
  String? email,
  String? gender,
);
typedef GetProfileHandler = ResultFuture<ProfileEntity> Function();

class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({
    GetProfileHandler? onGetProfile,
    UpdateProfileHandler? onUpdateProfile,
  })  : _onGetProfile = onGetProfile,
        _onUpdateProfile = onUpdateProfile;

  final GetProfileHandler? _onGetProfile;
  final UpdateProfileHandler? _onUpdateProfile;

  int getProfileCallCount = 0;
  int updateProfileCallCount = 0;

  String? lastName;
  String? lastEmail;
  String? lastGender;

  @override
  ResultFuture<ProfileEntity> getProfile() {
    getProfileCallCount += 1;
    final handler = _onGetProfile;
    if (handler != null) {
      return handler();
    }
    return Future.value(Result.success(_defaultProfileEntity()));
  }

  @override
  ResultFuture<ProfileEntity> updateProfile({
    required String name,
    String? email,
    String? gender,
  }) {
    updateProfileCallCount += 1;
    lastName = name;
    lastEmail = email;
    lastGender = gender;
    final handler = _onUpdateProfile;
    if (handler != null) {
      return handler(name, email, gender);
    }
    return Future.value(
      Result.success(
        _defaultProfileEntity(name: name, email: email, gender: gender),
      ),
    );
  }
}

class TestProfileBloc extends ProfileBloc {
  TestProfileBloc({required super.profileUseCase});

  void emitState(ProfileState state) {
    emit(state);
  }
}

ProfileBloc _buildBloc(FakeProfileRepository repository) {
  return ProfileBloc(profileUseCase: ProfileUseCase(repository: repository));
}

ProfileEntity _defaultProfileEntity({
  String name = 'Jane Doe',
  String? email = 'jane@example.com',
  String? gender = 'Female',
}) {
  return ProfileEntity(
    id: 'profile-1',
    phone: '+1234567890',
    name: name,
    email: email,
    profilePhoto: null,
    gender: gender,
    role: 'rider',
    createdAt: DateTime.utc(2024, 1, 1),
  );
}

Future<void> _registerPrefs({Map<String, Object> values = const {}}) async {
  SharedPreferences.setMockInitialValues(values);
  final prefs = await SharedPreferences.getInstance();
  if (sl.isRegistered<SharedPreferences>()) {
    sl.unregister<SharedPreferences>();
  }
  sl.registerSingleton<SharedPreferences>(prefs);
}

void main() {
  const String name = 'Jane Doe';
  const String email = 'jane@example.com';
  const String errorMessage = 'Unable to update profile';

  setUp(() async {
    await _registerPrefs();
  });

  tearDown(() {
    if (sl.isRegistered<SharedPreferences>()) {
      sl.unregister<SharedPreferences>();
    }
  });

  test('initial state has empty values', () {
    final bloc = _buildBloc(FakeProfileRepository());
    addTearDown(bloc.close);

    expect(bloc.state.status, ProfileStatus.initial);
    expect(bloc.state.fullName, '');
    expect(bloc.state.email, '');
    expect(bloc.state.gender, isNull);
    expect(bloc.state.photoPath, isNull);
    expect(bloc.state.isEditing, false);
    expect(bloc.state.errorMessage, '');
  });

  test('ProfileStartedEvent loads saved values and marks editing', () async {
    await _registerPrefs(
      values: <String, Object>{
        PrefKeys.profileName: name,
        PrefKeys.profileEmail: email,
        PrefKeys.profileGender: 'female',
      },
    );

    final bloc = _buildBloc(FakeProfileRepository());
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.loading,
          ),
          isA<ProfileState>()
              .having((state) => state.status, 'status', ProfileStatus.ready)
              .having((state) => state.fullName, 'fullName', name)
              .having((state) => state.email, 'email', email)
              .having((state) => state.gender, 'gender', ProfileGender.female)
              .having((state) => state.isEditing, 'isEditing', true)
              .having((state) => state.errorMessage, 'errorMessage', ''),
        ],
      ),
    );

    bloc.add(const ProfileStartedEvent());
    await expectation;
  });

  test('ProfileStartedEvent respects isEditing flag when prefs are empty',
      () async {
    await _registerPrefs();

    final bloc = _buildBloc(FakeProfileRepository());
    addTearDown(bloc.close);

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.loading,
          ),
          isA<ProfileState>()
              .having((state) => state.status, 'status', ProfileStatus.ready)
              .having((state) => state.fullName, 'fullName', '')
              .having((state) => state.email, 'email', '')
              .having((state) => state.gender, 'gender', isNull)
              .having((state) => state.isEditing, 'isEditing', true),
        ],
      ),
    );

    bloc.add(const ProfileStartedEvent(isEditing: true));
    await expectation;
  });

  test('ProfileNameChangedEvent updates full name and clears error', () async {
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: FakeProfileRepository()),
    );
    addTearDown(bloc.close);
    bloc.emitState(ProfileState.initial().copyWith(errorMessage: 'Error'));

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<ProfileState>()
            .having((state) => state.fullName, 'fullName', name)
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const ProfileNameChangedEvent(fullName: name));
    await expectation;
  });

  test('ProfileEmailChangedEvent updates email and clears error', () async {
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: FakeProfileRepository()),
    );
    addTearDown(bloc.close);
    bloc.emitState(ProfileState.initial().copyWith(errorMessage: 'Error'));

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<ProfileState>()
            .having((state) => state.email, 'email', email)
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const ProfileEmailChangedEvent(email: email));
    await expectation;
  });

  test('ProfileGenderChangedEvent updates gender and clears error', () async {
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: FakeProfileRepository()),
    );
    addTearDown(bloc.close);
    bloc.emitState(ProfileState.initial().copyWith(errorMessage: 'Error'));

    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<ProfileState>()
            .having((state) => state.gender, 'gender', ProfileGender.male)
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const ProfileGenderChangedEvent(gender: ProfileGender.male));
    await expectation;
  });

  test('ProfilePhotoChangedEvent updates photo path and clears error', () async {
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: FakeProfileRepository()),
    );
    addTearDown(bloc.close);
    bloc.emitState(ProfileState.initial().copyWith(errorMessage: 'Error'));

    const String path = '/tmp/photo.png';
    final expectation = expectLater(
      bloc.stream,
      emits(
        isA<ProfileState>()
            .having((state) => state.photoPath, 'photoPath', path)
            .having((state) => state.errorMessage, 'errorMessage', ''),
      ),
    );

    bloc.add(const ProfilePhotoChangedEvent(photoPath: path));
    await expectation;
  });

  test('ProfileContinuePressedEvent ignores when name is empty', () async {
    final repository = FakeProfileRepository();
    final bloc = _buildBloc(repository);
    addTearDown(bloc.close);

    bloc.add(const ProfileContinuePressedEvent());
    await Future<void>.delayed(Duration.zero);

    expect(repository.updateProfileCallCount, 0);
    expect(bloc.state.status, ProfileStatus.initial);
  });

  test('ProfileContinuePressedEvent ignores invalid email', () async {
    final repository = FakeProfileRepository();
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: repository),
    );
    addTearDown(bloc.close);
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: name,
        email: 'invalid-email',
      ),
    );

    bloc.add(const ProfileContinuePressedEvent());
    await Future<void>.delayed(Duration.zero);

    expect(repository.updateProfileCallCount, 0);
    expect(bloc.state.status, ProfileStatus.ready);
  });

  test('ProfileContinuePressedEvent ignores while saving', () async {
    final repository = FakeProfileRepository();
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: repository),
    );
    addTearDown(bloc.close);
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.saving,
        fullName: name,
        email: email,
      ),
    );

    bloc.add(const ProfileContinuePressedEvent());
    await Future<void>.delayed(Duration.zero);

    expect(repository.updateProfileCallCount, 0);
    expect(bloc.state.status, ProfileStatus.saving);
  });

  test('ProfileContinuePressedEvent saves profile on success', () async {
    final repository = FakeProfileRepository();
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: repository),
    );
    addTearDown(bloc.close);
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: '  $name  ',
        email: '  $email  ',
        gender: ProfileGender.male,
      ),
    );

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.saving,
          ),
          isA<ProfileState>()
              .having((state) => state.status, 'status', ProfileStatus.saved)
              .having((state) => state.isEditing, 'isEditing', true)
              .having((state) => state.fullName, 'fullName', name)
              .having((state) => state.email, 'email', email)
              .having((state) => state.gender, 'gender', ProfileGender.male),
        ],
      ),
    );

    bloc.add(const ProfileContinuePressedEvent());
    await expectation;

    expect(repository.updateProfileCallCount, 1);
    expect(repository.lastName, name);
    expect(repository.lastEmail, email);
    expect(repository.lastGender, 'Male');

    expect(await Prefs.getString(PrefKeys.profileName), name);
    expect(await Prefs.getString(PrefKeys.profileEmail), email);
    expect(await Prefs.getString(PrefKeys.profileGender), 'male');
  });

  test('ProfileContinuePressedEvent clears email and gender when empty',
      () async {
    await _registerPrefs(
      values: <String, Object>{
        PrefKeys.profileEmail: email,
        PrefKeys.profileGender: 'female',
      },
    );

    final repository = FakeProfileRepository(
      onUpdateProfile: (_, __, ___) => Future.value(
        Result.success(
          _defaultProfileEntity(email: null, gender: null),
        ),
      ),
    );
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: repository),
    );
    addTearDown(bloc.close);
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: name,
        email: '',
      ),
    );

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.saving,
          ),
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.saved,
          ),
        ],
      ),
    );

    bloc.add(const ProfileContinuePressedEvent());
    await expectation;

    expect(await Prefs.getString(PrefKeys.profileEmail), isNull);
    expect(await Prefs.getString(PrefKeys.profileGender), isNull);
  });

  test('ProfileContinuePressedEvent emits failure on error', () async {
    final repository = FakeProfileRepository(
      onUpdateProfile: (_, __, ___) => Future.value(
        const Result.failure(
          APIFailure(errorMessage: errorMessage, statusCode: 400),
        ),
      ),
    );
    final bloc = TestProfileBloc(
      profileUseCase: ProfileUseCase(repository: repository),
    );
    addTearDown(bloc.close);
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: name,
      ),
    );

    final expectation = expectLater(
      bloc.stream,
      emitsInOrder(
        [
          isA<ProfileState>().having(
            (state) => state.status,
            'status',
            ProfileStatus.saving,
          ),
          isA<ProfileState>()
              .having((state) => state.status, 'status', ProfileStatus.ready)
              .having((state) => state.errorMessage, 'errorMessage', errorMessage),
        ],
      ),
    );

    bloc.add(const ProfileContinuePressedEvent());
    await expectation;

    expect(repository.updateProfileCallCount, 1);
    expect(await Prefs.getString(PrefKeys.profileName), isNull);
  });
}
