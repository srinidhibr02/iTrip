/// Application-wide constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'iTrip';
  static const String appTagline = 'Taste the journey, before it begins';
  static const String defaultCountry = 'India';

  // Firebase collections
  static const String usersCollection = 'users';
  static const String tripsCollection = 'trips';
  static const String routesCollection = 'routes';
  static const String reviewsCollection = 'reviews';
  static const String packagesCollection = 'packages';
  static const String postsCollection = 'posts';
  static const String notificationsCollection = 'notifications';
  static const String savedPlacesCollection = 'saved_places';
  static const String expensesCollection = 'expenses';

  // Hive boxes
  static const String tripsBox = 'trips_box';
  static const String routesBox = 'routes_box';
  static const String settingsBox = 'settings_box';

  // Defaults
  static const double defaultFuelPricePerLiter = 102.0;
  static const double defaultBikeMileage = 40.0;
  static const double defaultCarMileage = 15.0;
  static const int paginationLimit = 20;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
