import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime configuration from environment variables.
class AppConfig {
  AppConfig._();

  static String get googleMapsApiKey =>
      dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

  static String get googlePlacesApiKey =>
      dotenv.env['GOOGLE_PLACES_API_KEY'] ?? googleMapsApiKey;

  static String get googleDirectionsApiKey =>
      dotenv.env['GOOGLE_DIRECTIONS_API_KEY'] ?? googleMapsApiKey;

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.itrip.app/v1';

  static bool get hasGoogleMapsKey => googleMapsApiKey.isNotEmpty;

  /// Default map center — Bangalore, India
  static const double defaultLatitude = 12.9716;
  static const double defaultLongitude = 77.5946;
}
