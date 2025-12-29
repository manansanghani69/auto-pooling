## Pull Request Title
[FEAT] Auth UI, OTP flow, and validations

---

## Description

### What does this PR do?
- Adds phone number and OTP authentication screens with reusable widgets, validation, and timer/resend UI.
- Implements AuthBloc flows for requesting/verifying OTP, logout, and OTP timer state.
- Introduces ApiClient with auth/logging interceptors, DI wiring, and token persistence in shared prefs.
- Applies json_serializable to auth and existing feature models with generated `.g.dart` files.
- Adds shared PrimaryButton/PrimaryTextField, updates onboarding/splash styling, and adds a placeholder home screen/route.
- Adds AuthBloc unit tests and golden tests covering auth/onboarding/splash/home/notifications/payments/profile/ride screens.
- Updates repository guidance docs (AGENTS and PR description template).

### Why are these changes needed?
- Provide a complete phone-based authentication flow and enable authenticated API calls.
- Standardize UI components and styling for a more consistent UX.
- Add regression coverage for auth state transitions and key UI screens.

### How was this implemented?
- Built dedicated auth screens and decomposed widgets per project guidelines; BLoC handles OTP request/verify and timer updates.
- Added an ApiClient wrapper around Dio with auth and logging interceptors; auth repository persists/clears tokens in prefs.
- Converted models to json_serializable and generated `.g.dart` files; added golden and bloc test suites.

---

## Changes Overview
- [x] Feature addition
- [ ] Bug fix
- [ ] Refactoring / Code improvement
- [x] Documentation update
- [x] Tests added or updated
- [ ] Other (please specify):

---

## Key Files Modified

| File Path | Description of Changes |
|---------------------|------------------------|
| `lib/presentation/auth/auth_screen.dart` | Phone auth screen + Bloc navigation to OTP and error handling. |
| `lib/presentation/auth/auth_otp_screen.dart` | OTP verification screen with success navigation to Home. |
| `lib/presentation/auth/bloc/auth_bloc.dart` | OTP request/verify, logout, and timer state management. |
| `lib/presentation/auth/data/datasources/auth_remote_data_source.dart` | API calls for OTP request/verify/logout via ApiClient. |
| `lib/core/services/api_client.dart` | ApiClient wrapper with auth + logging interceptors. |
| `lib/core/services/injection_container.dart` | DI for prefs, Dio, ApiClient, and auth use case stack. |
| `lib/widgets/primary_button.dart` | New shared primary button component. |
| `lib/widgets/primary_text_field.dart` | New shared text field component. |
| `lib/routes.dart` | Added auth/OTP/home routes. |
| `test/goldens/app_goldens_test.dart` | Golden tests for auth/onboarding/splash and core screens. |
| `test/presentation/auth/bloc/auth_bloc_test.dart` | AuthBloc unit tests for OTP flows and timer updates. |

---

## Testing Done
Testing reported as done; details not provided.

- [x] Manual testing
- [x] Unit tests added/updated
- [ ] Integration tests
- [ ] No tests needed (explain why)

### Steps to test:
1. Details not provided (author noted testing done).

---

## Screenshots (if applicable)
TBD - will add.

---

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated (if required)
- [ ] Tests pass locally
- [ ] No new warnings or errors introduced
- [ ] Branch is up-to-date with `dev`

---

## Additional Notes
- Dev base URL now defaults to `http://localhost:4000` in `lib/utils/app_flavor_env.dart`.
