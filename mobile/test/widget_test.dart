import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rms_mobile/main.dart';
import 'package:rms_mobile/screens/home_nav_screen.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Rental Management App login screen smoke test', (WidgetTester tester) async {
    // 1. Build root app and pump fixed frame duration
    await tester.pumpWidget(const RentalManagementApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // 2. Verify AuthGate displays login screen controls and examiner presets
    expect(find.text('Rental Management System'), findsOneWidget);
    expect(find.text('Sign In to Account'), findsOneWidget);
    expect(find.text('Examiner Quick-Fill Presets:'), findsOneWidget);
    expect(find.byType(TextField), findsAtLeastNWidgets(2));
  });

  testWidgets('Rental Management App HomeNavScreen navigation test', (WidgetTester tester) async {
    // 1. Pump HomeNavScreen inside MaterialApp
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeNavScreen(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    // 2. Verify role-aware app bar title and navigation destinations
    expect(find.text('Tenant Living Portal'), findsOneWidget);
    expect(find.text('Explore Homes'), findsOneWidget);
    expect(find.text('My Applications'), findsOneWidget);
    expect(find.text('My Lease'), findsOneWidget);
    expect(find.text('Maintenance'), findsAtLeastNWidgets(1));
    expect(find.byIcon(Icons.apartment), findsWidgets);
  });
}
