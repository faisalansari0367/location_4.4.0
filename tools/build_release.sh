
NAME="Bioplus Prod.apk"
APKPATH="build/app/outputs/flutter-apk/$NAME"
echo "Building $NAME"
flutter build apk --target=lib/main_prod.dart
# cd build/app/outputs/flutter-apk
echo "Changing to $NAME"
mv app-release.apk $NAME
# mv "app-release.apk" "Hoho Staff.apk";
# cp $NAME /Users/mohdfaisal/Desktop/GoGoGoGoa;   

echo "$NAME Link:"
python3 tools/we_transfer.py upload $APKPATH