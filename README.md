# DDish app

## Ашиглагдсан технологи
  [Flutter](https://flutter.dev/)

## Google Play store д хуулах
  1. `ddish-flutter-app/app/pubspec.yaml` файл доторх `version: 1.0.2+8` ын version ахиулах
  2. `ddish-flutter-app/app/android/app/build.gradle` файл доторх `android -> defaultConfig -> versionCode 33` ын **versionCode** ын утгыг ахиулах
  3. `ddish-flutter-app/app/` directory дотор `flutter build apk --release --split-per-abi` коммандыг ажиллуулах
    Дээрх командын үр дүнд **ddish-flutter-app/app/build/app/outputs/apk/release/** directory дотор `app-arm64-v8a-release.apk` болон `app-armeabi-v7a-release.apk` гэсэн 2 файл үүснэ. 
  4. `Google Play Console` ын App release цэсний `Internal test` release хэсэгт хуулна. Тест алдаагүй бол **Release to** -> **Alpha** -> **Beta** -> **Procuction** байдлаар ахиулж app store т хуулагдана.
  
## Apple App store т хуулах
  1. `ddish-flutter-app/app/` directory дотор `flutter build ios --release` коммандыг ажиллуулах
  2. `Xcode` дээр project оо нээж `Signin&Capabilities` цэсний `Signin` хэсэгт developer эрхээ тохируулна
  3. `General` цэсэнд `Version` ахиулна. Шаардлагатай бол `Build` дугаараа оруулна.
  4. `Build device` аас `Generic iOS Device` ыг сонгоно.
  5. `Product` цэснээс `Archive` сонголтыг хийнэ.
