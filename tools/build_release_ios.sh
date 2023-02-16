
flutter build ipa --target=lib/main_prod.dart
# flutter build ipa --target=lib/main_prod.dart
xcrun altool --upload-app --type ios -f build/ios/ipa/*.ipa --apiKey CKWL7742M7 --apiIssuer d9def15f-16e9-4b53-a4c4-6abcbda2ff25