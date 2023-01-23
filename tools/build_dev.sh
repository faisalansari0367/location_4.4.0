
NAME="Bioplus Dev.apk"
APKPATH="build/app/outputs/flutter-apk/$NAME"
echo "Building $NAME"
flutter build apk --target=lib/main_dev.dart
cd build/app/outputs/flutter-apk
open .
echo "Changing to $NAME"
mv app-release.apk "$NAME"

cd ../../../../

# mv "app-release.apk" "Hoho Staff.apk";
# cp $NAME /Users/mohdfaisal/Desktop/GoGoGoGoa;   

echo "$NAME Link:"
echo $APKPATH
open $APKPATH