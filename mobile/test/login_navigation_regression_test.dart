import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rms_mobile/main.dart';
import 'package:rms_mobile/services/auth_service.dart';

void main() {
  testWidgets('Tenant can sign in again after leaving the dashboard', (tester) async {
    SharedPreferences.setMockInitialValues({
      'jwt_token': 'test-session-token',
      'user_id': 'test-tenant',
      'user_full_name': 'Test Tenant',
      'user_email': 'tenant@rms.lk',
      'user_role': 'Tenant',
    });

    await http.runWithClient(() async {
      await tester.pumpWidget(const RentalManagementApp());
      await tester.pumpAndSettle();
      expect(find.text('Tenant Living Portal'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.logout).first);
      await tester.pumpAndSettle();
      expect(find.text('Sign In to Account'), findsOneWidget);
      expect(AuthService.currentUser, isNull);

      await tester.tap(find.text('Sign In to Account'));
      await tester.pumpAndSettle();
      expect(find.text('Tenant Living Portal'), findsOneWidget);
      expect(AuthService.currentUser?.id, 'test-tenant');
      expect(tester.takeException(), isNull);
    }, () => MockClient((request) async {
      if (request.url.path.endsWith('/auth/login')) {
        return http.Response(jsonEncode({
          'token': 'test-session-token',
          'userId': 'test-tenant',
          'fullName': 'Test Tenant',
          'email': 'tenant@rms.lk',
          'role': 'Tenant',
        }), 200, headers: {'content-type': 'application/json'});
      }
      return http.Response('[]', 200, headers: {'content-type': 'application/json'});
    }));
    await AuthService.logout();
  });
}
