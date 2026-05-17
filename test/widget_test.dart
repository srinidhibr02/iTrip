import 'package:flutter_test/flutter_test.dart';
import 'package:itrip/core/constants/app_constants.dart';

void main() {
  test('App constants are defined', () {
    expect(AppConstants.appName, 'iTrip');
    expect(AppConstants.appTagline, isNotEmpty);
  });
}
