import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:auto_pooling/common/theme/app_themes_data.dart';
import 'package:auto_pooling/core/usecase/result.dart';
import 'package:auto_pooling/i18n/app_localizations.dart';
import 'package:auto_pooling/presentation/profile/bloc/profile_bloc.dart';
import 'package:auto_pooling/presentation/profile/bloc/profile_state.dart';
import 'package:auto_pooling/presentation/profile/domain/entities/profile_entity.dart';
import 'package:auto_pooling/presentation/profile/domain/repositories/profile_repository.dart';
import 'package:auto_pooling/presentation/profile/domain/usecases/profile_usecase.dart';
import 'package:auto_pooling/presentation/profile/profile_screen.dart';

class _StubProfileRepository implements ProfileRepository {
  @override
  ResultFuture<ProfileEntity> getProfile() {
    return Future.value(Result.success(_defaultProfileEntity()));
  }

  @override
  ResultFuture<ProfileEntity> updateProfile({
    required String name,
    String? email,
    String? gender,
  }) {
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

ProfileUseCase _buildProfileUseCase() {
  return ProfileUseCase(repository: _StubProfileRepository());
}

Widget _buildProfileScaffold(ProfileBloc bloc) {
  return MaterialApp(
    theme: AppThemesData.lightTheme,
    home: BlocProvider<ProfileBloc>.value(
      value: bloc,
      child: const ProfileScreenScaffold(),
    ),
  );
}

void main() {
  const AppLocalizations l10n = AppLocalizations();

  testWidgets('complete profile copy renders', (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        isEditing: false,
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    expect(find.text(l10n.profileCompleteAppBarTitle), findsOneWidget);
    expect(find.text(l10n.profileCompleteHeadline), findsOneWidget);
  });

  testWidgets('edit profile copy renders', (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        isEditing: true,
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    expect(find.text(l10n.profileEditAppBarTitle), findsOneWidget);
    expect(find.text(l10n.profileEditHeadline), findsOneWidget);
  });

  testWidgets('continue button disabled when name is empty',
      (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: '',
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('continue button disabled while saving',
      (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.saving,
        fullName: 'Jane Doe',
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNull);
  });

  testWidgets('continue button enabled when name provided',
      (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: 'Jane Doe',
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    final ElevatedButton button = tester.widget(find.byType(ElevatedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('invalid email shows validation error',
      (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
        fullName: 'Jane Doe',
        email: 'invalid-email',
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text(l10n.profileEmailInvalidError), findsOneWidget);
  });

  testWidgets('gender selection updates bloc state',
      (WidgetTester tester) async {
    final TestProfileBloc bloc = TestProfileBloc(
      profileUseCase: _buildProfileUseCase(),
    );
    bloc.emitState(
      ProfileState.initial().copyWith(
        status: ProfileStatus.ready,
      ),
    );
    addTearDown(bloc.close);

    await tester.pumpWidget(_buildProfileScaffold(bloc));

    await tester.tap(find.text(l10n.profileGenderMale));
    await tester.pump();

    expect(bloc.state.gender, ProfileGender.male);
  });
}
