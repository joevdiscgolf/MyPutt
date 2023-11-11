flutter clean
flutter pub get
flutter build ipa

# IPA file is created here
file=build/ios/ipa/myputt.ipa

issuerId=24ae4dc4-d9d5-4bd7-9911-9b14b8860946

myputtAdminKeyId=K7GJCQZG7C

xcrun altool --upload-app -f $file -t ios --apiKey $myputtAdminKeyId --apiIssuer $issuerId
