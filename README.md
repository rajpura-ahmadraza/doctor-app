# ClinixPro Patient App

Flutter mobile application for patients of ClinixPro clinic.

---

## Features

| Screen | Features |
|---|---|
| **Login** | Password login, Fingerprint / biometric login |
| **Forgot Password** | 3-step OTP-based password reset (Mobile → OTP → New password) |
| **Home** | Patient ID card, health summary, vitals, quick access, upcoming appointment, recent prescription |
| **Medical History** | All past consultations with vitals, symptoms, medicines, advice; all uploaded reports with download |
| **Chat** | Secure messaging with doctor / clinic staff, auto-reply simulation |
| **Book Appointment** | Date picker, time slot grid, visit type, UPI/card/cash payment, booking history, cancel appointment |
| **Notifications** | All notifications with category filter (Follow-up, Vaccination, Medicine, Report, Appointment), mark read |
| **Profile** | Patient details, stats, doctor info, change password, edit profile, sign out |

---

## Build APK

```powershell
# Clean cache first
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\caches" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:USERPROFILE\.gradle\daemon" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue

# Get packages
flutter pub get

# Build
flutter build apk --release --android-skip-build-dependency-validation

# APK location
# build\app\outputs\flutter-apk\app-release.apk
```

---

## Project structure

```
lib/
├── main.dart
├── theme/theme.dart          # ClinixPro brand colors + shared widgets
├── data/sample_data.dart     # Static sample data (replace with API later)
└── screens/
    ├── shell.dart            # Bottom navigation shell
    ├── home_screen.dart      # Dashboard
    ├── auth/
    │   ├── login_screen.dart
    │   └── forgot_password_screen.dart   # Also contains ChangePasswordScreen
    ├── history/history_screen.dart       # Prescriptions + Reports tabs
    ├── chat/chat_screen.dart
    ├── appointment/appointment_screen.dart
    ├── notifications/notifications_screen.dart
    └── profile/profile_screen.dart
```

---

## Making it dynamic (API integration)

All sample data is in `lib/data/sample_data.dart`. Replace each list with API calls:

- `PatientData.patient` → `GET /api/patient/profile`
- `PatientData.consultHistory` → `GET /api/patient/consultations`
- `PatientData.reports` → `GET /api/patient/reports`
- `PatientData.messages` → `GET /api/patient/messages`
- `PatientData.appointments` → `GET /api/patient/appointments`
- `PatientData.notifications` → `GET /api/patient/notifications`
- `PatientData.timeSlots` → `GET /api/appointments/slots?date=YYYY-MM-DD`

---

## Important notes

- `MainActivity` extends `FlutterFragmentActivity` (required for `local_auth` fingerprint)
- `minSdk 23` required for biometric authentication
- All Gradle versions match what was working in ClinixPro doctor app
