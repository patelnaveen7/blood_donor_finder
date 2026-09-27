# Blood Donor Finder

A fully offline Flutter app for registering and finding blood donors.
All data is stored **only on the device** using `SharedPreferences` —
there is no Firebase, no SQL database, and no server of any kind.

## Features

- **Register donors** — name, blood group, phone number, city/location, optional notes
- **Search donors** by blood group and by city/location (partial, case-insensitive match)
- **View donor details**
- **Call a donor** directly from the app (opens the phone dialer)
- **Delete donor records** (with a confirmation dialog)

## Tech

- Flutter / Dart, Material 3
- `shared_preferences` — local on-device storage (JSON-encoded list)
- `url_launcher` — launches the phone dialer for `tel:` links
- `uuid` — generates unique IDs for donor records

No internet permission is required for the app's core functionality — the
`INTERNET` permission declared in the manifest is a standard Flutter
scaffolding default and isn't used by any app feature.

## Project structure

```
lib/
  main.dart                        # App entry point & theme
  models/donor.dart                # Donor data model
  services/donor_service.dart      # SharedPreferences persistence layer
  screens/home_screen.dart         # Search + donor list
  screens/register_donor_screen.dart
  screens/donor_detail_screen.dart # View / call / delete
  widgets/donor_list_item.dart
android/                           # Standard Flutter Android project
.github/workflows/build-apk.yml    # GitHub Actions: builds a release APK
```

## Building the APK with GitHub Actions (no local Flutter install needed)

1. Create a new **public or private repository** on GitHub.
2. Upload/push the entire contents of this project to that repository
   (keep the folder structure as-is, including the hidden `.github` folder).
3. Go to the **Actions** tab of your repository. The `Build APK` workflow
   runs automatically on every push to `main`, or you can trigger it
   manually via **Run workflow**.
4. When the run finishes, open it and download the
   **blood-donor-finder-release-apk** artifact from the "Artifacts"
   section at the bottom of the run summary page. Unzip it to get
   `app-release.apk`.
5. Copy `app-release.apk` to your phone and install it (you'll need to
   allow "install from unknown sources" for your file manager/browser).

### Building locally instead (optional)

If you do have Flutter installed:

```bash
flutter pub get
flutter build apk --release
```

The APK will be at `build/app/outputs/flutter-apk/app-release.apk`.

## Notes

- The release build is signed with Flutter's default debug key so the
  workflow builds successfully out of the box. This is fine for personal
  use and sideloading, but if you ever publish to the Play Store you'll
  need to set up your own signing key and update
  `android/app/build.gradle` accordingly.
- The Flutter version pinned in the workflow (`3.24.0`) can be bumped any
  time by editing `.github/workflows/build-apk.yml`.
