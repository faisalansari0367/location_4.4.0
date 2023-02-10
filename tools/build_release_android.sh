# flutter build apk --target=lib/main_prod.dart --flavor=dev
# flutter build apk --target=lib/main_dev.dart --flavor=dev





NAME="Bioplus Prod.apk"
APKPATH="build/app/outputs/flutter-apk/$NAME"
echo "Building $NAME"
flutter build apk --target=lib/main_prod.dart --flavor=dev

# cd build/app/outputs/flutter-apk
echo "Changing to $NAME"
mv app-release.apk $NAME

open $APKPATH
# mv "app-release.apk" "Hoho Staff.apk";
# cp $NAME /Users/mohdfaisal/Desktop/GoGoGoGoa;   

echo "$NAME Link:"
python3 tools/we_transfer.py upload $APKPATH