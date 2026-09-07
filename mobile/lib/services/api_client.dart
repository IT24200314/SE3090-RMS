import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/property.dart';
import '../models/tenant_application.dart';
import '../models/maintenance_ticket.dart';

class ApiClient {
  // Configured for local development: 10.0.2.2 on Android emulator, localhost on Web
  static String get baseUrl {
    if (kIsWeb) return 'http://localhost:5000/api';
    try {
      if (Platform.isAndroid) return 'http://10.0.2.2:5000/api';
    } catch (_) {}
    return 'http://localhost:5000/api';
  }

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Property & Lease APIs (Upamada - Component A)
  static Future<List<Property>> getProperties({String search = ''}) async {
    try {
      final uri = Uri.parse('$baseUrl/properties?search=${Uri.encodeComponent(search)}');
      final response = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 1));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Property.fromJson(json)).toList();
      }
    } catch (_) {
      // Fallback local mock data for testing/offline mode
    }
    return _mockProperties;
  }

  static Future<bool> terminateLease(String propertyId, String reason) async {
    try {
      final uri = Uri.parse('$baseUrl/leases/$propertyId/terminate');
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode({'terminationReason': reason}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return true; // Local simulation
    }
  }

  // Tenant Onboarding & Screening APIs (Nethmi - Component B)
  static Future<TenantApplication> submitApplication({
    required String propertyId,
    required double monthlyIncome,
    required String identityDocUrl,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/tenants/applications');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'tenantId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
          'propertyId': propertyId,
          'monthlyIncome': monthlyIncome,
          'identityDocUrl': identityDocUrl,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return TenantApplication.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}

    return TenantApplication(
      id: 'app-${DateTime.now().millisecondsSinceEpoch}',
      tenantId: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      propertyId: propertyId,
      monthlyIncome: monthlyIncome,
      identityDocUrl: identityDocUrl,
      status: 'ReviewRequired',
      aiRiskScore: 65,
      aiScreeningNotes: 'Flagged for Manager Approval as rent ratio is approx 38%.',
      createdAtUtc: DateTime.now(),
    );
  }

  // Maintenance & Work-Orders APIs (Hashini - Component C)
  static Future<MaintenanceTicket> createMaintenanceTicket({
    required String propertyId,
    required String issueDescription,
    required String photoUrl,
    required int priority,
    String? latitude,
    String? longitude,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/maintenance/tickets');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode({
          'propertyId': propertyId,
          'tenantId': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
          'issueDescription': issueDescription,
          'photoUrl': photoUrl,
          'priority': priority,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      }
    } catch (_) {}

    return MaintenanceTicket(
      id: 'mt-${DateTime.now().millisecondsSinceEpoch}',
      propertyId: propertyId,
      tenantId: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
      issueDescription: issueDescription,
      photoUrl: photoUrl,
      priority: priority == 3 ? 'Emergency' : priority == 2 ? 'High' : 'Medium',
      status: 'Open',
      estimatedCost: 18000,
      aiTriageSummary: "Triaged: Auto-approved within operational limits.",
      latitude: latitude,
      longitude: longitude,
      createdAtUtc: DateTime.now(),
    );
  }

  static final List<Property> _mockProperties = [
    Property(
      id: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
      title: 'Oceanfront Luxury Suite',
      description: 'Modern 3-bedroom apartment with panoramic sea view.',
      address: '142 Marine Drive, Colombo 03',
      monthlyRent: 220000,
      securityDeposit: 440000,
      status: 'Available',
      landlordId: '8f9e0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b',
    ),
    Property(
      id: 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
      title: 'Cinnamon Gardens Townhouse',
      description: 'Colonial style refurbished 4-bedroom villa.',
      address: '28 Flower Road, Colombo 07',
      monthlyRent: 350000,
      securityDeposit: 700000,
      status: 'Occupied',
      landlordId: '9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d',
    ),
  ];
}
