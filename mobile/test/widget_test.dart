import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rms_mobile/main.dart';

void main() {
  testWidgets('Rental Management App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RentalManagementApp());
    await tester.pump();

    // Verify app bar title and module destinations render
    expect(find.text('Property & Lease Management'), findsOneWidget);
    expect(find.text('Properties'), findsOneWidget);
    expect(find.text('Screening'), findsOneWidget);
    expect(find.text('Maintenance'), findsAtLeastNWidgets(1));
    expect(find.text('AI Telemetry'), findsOneWidget);
    expect(find.byIcon(Icons.apartment), findsWidgets);
  });
}
