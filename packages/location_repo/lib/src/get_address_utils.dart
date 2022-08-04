import 'package:geocoding/geocoding.dart';

class GetAddressUtils {
  static bool compareStrings(String? a, String? b) {
    final result = a?.toLowerCase() == b?.toLowerCase();
    return result;
  }

  static String getAddressFromPlaceMark(List<Placemark> placemarks) {
    var currentLocation = '';
    for (var item in placemarks) {
      if (item.thoroughfare?.isNotEmpty ?? false) {
        currentLocation = item.thoroughfare!;
      }
    }
    final address = _getAccurateLocality(placemarks);
    currentLocation += address;
    return currentLocation;
  }

  static String _getAccurateLocality(List<Placemark> placemarks) {
    var address = '';
    final subLocalityMap = {};
    final localityMap = {};
    for (var item in placemarks) {
      var localityCount = 0;
      var subLocalityCount = 0;
      for (var subItem in placemarks) {
        final matchedSubLocalities = compareStrings(subItem.subLocality, item.subLocality);
        final matchedLocalities = compareStrings(subItem.locality, item.locality);
        if (matchedLocalities) {
          localityCount++;
          localityMap[subItem.locality] = localityCount;
        }
        if (matchedSubLocalities) {
          subLocalityCount++;
          subLocalityMap[subItem.subLocality] = subLocalityCount;
        }
      }
    }
    final locality = _getMoreAccurateValue(localityMap);
    final subLocality = _getMoreAccurateValue(subLocalityMap);
    if (subLocality.isNotEmpty) address += ' $subLocality';
    if (locality.isNotEmpty) address += ', $locality';
    return address;
  }

  static String _getMoreAccurateValue(Map map) {
    var thevalue = 0, thekey;
    map.forEach((k, v) {
      if (v > thevalue) {
        thevalue = v;
        thekey = k;
      }
    });
    return thekey;
  }
}
