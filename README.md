# FriendLink

FriendLink is a minimalist chat application built with Flutter, where friends can gather and communicate within a single group. The app is designed for Android, iOS, Web, and Windows platforms, using Firebase services for backend functionalities such as authentication, data storage, and media management.

## Technologies Used

- **Flutter**: Cross-platform UI toolkit to build mobile, web, and desktop apps.
- **Firebase Authentication**: Secure authentication for user login, supporting email/password login.
- **Firebase Firestore**: Real-time NoSQL database for storing and managing chat messages.
- **Firebase Storage**: For handling media uploads like images and files.
- **ImagePicker**: For allowing users to upload profile or shared photos directly from their device.
- **Platform Support**: Android, iOS, Web, Windows.

## Authentication Configuration for Platforms

### Android
1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Add a new Android app using your package name.
3. Download the `google-services.json` file.
4. Place it in the `android/app` directory of your Flutter project.
5. Update your `android/build.gradle` and `android/app/build.gradle` to include Firebase dependencies.
6. Enable Firebase Authentication in the Firebase Console.

### iOS
1. Add a new iOS app in the [Firebase Console](https://console.firebase.google.com/).
2. Download the `GoogleService-Info.plist` file.
3. Add the `.plist` file to the `ios/Runner` folder in your project.
4. In Xcode, open the `ios/Runner.xcworkspace` file.
5. Configure the `Info.plist` with Firebase settings.
6. Add Firebase dependencies to your `Podfile` and run `pod install`.
7. Enable Firebase Authentication in the Firebase Console.

### Web
1. Add a new web app in the [Firebase Console](https://console.firebase.google.com/).
2. Copy the Firebase configuration and paste it into the `index.html` file in the `/web` directory.
3. Enable Firebase Authentication in the Firebase Console.
4. Install the Firebase SDK for web by adding dependencies to `pubspec.yaml`:
   ```yaml
   firebase_core: latest_version
   firebase_auth: latest_version
   cloud_firestore: latest_version
   firebase_storage: latest_version
