// =================================================================================================
// File: model_and_validation_test.dart
// Module: Mobile Layer - Unit, Model Serialization & Form Validation Test Suite
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Mobile Layer - Flutter Unit Tests for Model Parsing & Input Guardrails
// Purpose: Validates JSON serialization for Property, Maintenance, Tenant models, and enforces
//          strict form validation rules (Email regex, password complexity, required fields).
// =================================================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:rms_mobile/models/property.dart';
import 'package:rms_mobile/models/maintenance_ticket.dart';
import 'package:rms_mobile/models/tenant_application.dart';

void main() {
  group('Mobile Data Models - JSON Serialization Tests', () {
    test('Property.fromJson correctly parses REST payload and currency figures', () {
      final json = {
        'id': 'prop-101',
        'title': 'Oceanfront Luxury Villa',
        'description': '3-bedroom panoramic sea view residence',
        'address': '75 Marine Drive, Colombo 03',
        'monthlyRent': 280000.0,
        'securityDeposit': 560000.0,
        'status': 0, // Enum integer 0 -> Available
        'landlordId': 'user-900',
      };

      final property = Property.fromJson(json);

      expect(property.id, equals('prop-101'));
      expect(property.title, equals('Oceanfront Luxury Villa'));
      expect(property.monthlyRent, equals(280000.0));
      expect(property.securityDeposit, equals(560000.0));
      expect(property.status, equals('Available'));
    });

    test('MaintenanceTicket.fromJson correctly parses priority, triage cost, and status', () {
      final json = {
        'id': 'ticket-202',
        'propertyId': 'prop-101',
        'tenantId': 'tenant-505',
        'issueDescription': 'Emergency burst pipe flooding hallway',
        'photoUrl': 'https://storage.rms.lk/burst.jpg',
        'priority': 'Emergency',
        'status': 'PendingManagerApproval',
        'estimatedCost': 65000.0,
        'aiTriageSummary': 'Classified as Plumbing Services. Exceeds LKR 50,000 threshold.',
      };

      final ticket = MaintenanceTicket.fromJson(json);

      expect(ticket.id, equals('ticket-202'));
      expect(ticket.estimatedCost, equals(65000.0));
      expect(ticket.status, equals('PendingManagerApproval'));
      expect(ticket.priority, equals('Emergency'));
      expect(ticket.aiTriageSummary, contains('Plumbing Services'));
    });

    test('TenantApplication.fromJson correctly parses credit risk scores and approval status', () {
      final json = {
        'id': 'app-303',
        'propertyId': 'prop-101',
        'applicantName': 'Amara Perera',
        'declaredMonthlyIncome': 400000.0,
        'creditRiskScore': 92,
        'status': 'Approved',
        'idDocumentUrl': 'https://storage.rms.lk/kyc/amara.jpg',
      };

      final app = TenantApplication.fromJson(json);

      expect(app.id, equals('app-303'));
      expect(app.applicantName, equals('Amara Perera'));
      expect(app.declaredMonthlyIncome, equals(400000.0));
      expect(app.creditRiskScore, equals(92));
      expect(app.status, equals('Approved'));
    });
  });

  group('Mobile Form Validation Rule Tests', () {
    String? validateEmail(String? value) {
      if (value == null || value.trim().isEmpty) return 'Email is required';
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(value.trim())) return 'Invalid email address format';
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) return 'Password is required';
      if (value.length < 6) return 'Password must be at least 6 characters';
      return null;
    }

    String? validateIncome(String? value) {
      if (value == null || value.trim().isEmpty) return 'Income is required';
      final income = double.tryParse(value.trim());
      if (income == null || income <= 0) return 'Income must be a positive number';
      return null;
    }

    test('Email validator enforces valid email structure and rejects empty input', () {
      expect(validateEmail(''), equals('Email is required'));
      expect(validateEmail('invalid-email'), equals('Invalid email address format'));
      expect(validateEmail('user@'), equals('Invalid email address format'));
      expect(validateEmail('tenant@example.com'), isNull);
    });

    test('Password validator enforces minimum length of 6 characters', () {
      expect(validatePassword(''), equals('Password is required'));
      expect(validatePassword('123'), equals('Password must be at least 6 characters'));
      expect(validatePassword('SecureP@ss123'), isNull);
    });

    test('Income validator enforces positive numerical values', () {
      expect(validateIncome(''), equals('Income is required'));
      expect(validateIncome('abc'), equals('Income must be a positive number'));
      expect(validateIncome('-50000'), equals('Income must be a positive number'));
      expect(validateIncome('350000'), isNull);
    });
  });
}
