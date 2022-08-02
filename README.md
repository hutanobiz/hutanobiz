# Hutano

Patient App: It supports both android and ios and you can download the app from the urls mentioned below:

* For Android: https://play.google.com/store/apps/details?id=xyz.appening.hutano
* For iOS: https://apps.apple.com/in/app/hutano-patient/id1540596812

## Running Flutter Gallery on Flutter's dev channel

The Flutter Gallery targets Flutter's dev channel. As such, it can take advantage
of new SDK features that haven't landed in the stable channel.

Install [Flutter](https://flutter.io/docs/get-started/install)

If you'd like to run Kargoo, make sure to switch to the master channel
first:

```bash
flutter channel dev
flutter upgrade
```

## Install required packages

Go to project root and execute the following commands in console to get the required packages: 

```bash
flutter pub get 
```

## Folder Structure

Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- assets
|- build
|- fonts
|- images
|- ios
|- lib
```

Here is the folder structure we have been using in this project.

```
lib/
|- apis/
|- app/
|- models/
|- screens/
|- utils/
|- widgets/
|- colors.dart
|- dimens.dart
|- main.dart
|- routes.dart
|- strings.dart
|- text_style.dart
|- theme.dart
```

## Publishing the Android release
* Ensure you have the correct signing certificates.
* Create the app bundle with `flutter build appbundle`.
* The release bundle for your app is created at <app dir>/build/app/outputs/bundle/release/app.aab.
* Upload to the Play store console.

## Publishing the iOS release
* In Xcode, open Runner.xcworkspace in your app’s ios folder.
* Ensure you have correct signing certificates installed in your keychain.
* Ensure correct provisioning profiles are installed in your Xcode project settings. 
* Select Product > Scheme > Runner.
* Select Product > Destination > Any iOS Device.
* Select Runner in the Xcode project navigator, then select the Runner target in the settings view sidebar.
* Select Product > Archive to produce a build archive.
* After the archive has been successfully validated, click Distribute App to upload.
