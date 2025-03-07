import 'package:geocoding/geocoding.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';

//from lat and lng displays address
Future<String> getAddressFromLatLng(LatLng pos) async {
  try {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    Placemark place = placemarks[0];
    if (place.locality!.length >= 15 || place.street!.length >= 15) {
      return "${place.locality}";
    }
    return "${place.street},${place.locality}";
  } catch (e) {
    print("Error getting address: $e");
    return "Unknown location";
  }
}
