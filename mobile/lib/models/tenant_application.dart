// =================================================================================================
// File: tenant_application.dart
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Mobile Layer - Domain Model for Tenant Onboarding Applications
// Purpose: Models applicant submissions, income statements, KYC document references, and AI risk scores.
// =================================================================================================

class TenantApplication {
  final String id;
  final String tenantId;
  final String applicantName;
  final String propertyId;
  final double monthlyIncome;
  final String identityDocUrl;
  final String status;
  final int aiRiskScore;
  final String? aiScreeningNotes;
  final DateTime createdAtUtc;

  double get declaredMonthlyIncome => monthlyIncome;
  int get creditRiskScore => aiRiskScore;

  TenantApplication({
    required this.id,
    required this.tenantId,
    this.applicantName = 'Prospective Tenant',
    required this.propertyId,
    required this.monthlyIncome,
    required this.identityDocUrl,
    required this.status,
    required this.aiRiskScore,
    this.aiScreeningNotes,
    required this.createdAtUtc,
  });

  factory TenantApplication.fromJson(Map<String, dynamic> json) {
    return TenantApplication(
      id: json['id'] ?? '',
      tenantId: json['tenantId'] ?? '',
      applicantName: json['applicantName'] ?? json['tenantName'] ?? 'Prospective Tenant',
      propertyId: json['propertyId'] ?? '',
      monthlyIncome: (json['monthlyIncome'] ?? json['declaredMonthlyIncome'] as num?)?.toDouble() ?? 0.0,
      identityDocUrl: json['identityDocUrl'] ?? json['idDocumentUrl'] ?? '',
      status: json['status'] is int
          ? (json['status'] == 0 ? 'Pending' : json['status'] == 1 ? 'Approved' : json['status'] == 2 ? 'Rejected' : 'ReviewRequired')
          : (json['status'] ?? 'Pending'),
      aiRiskScore: json['aiRiskScore'] ?? json['creditRiskScore'] ?? 0,
      aiScreeningNotes: json['aiScreeningNotes'],
      createdAtUtc: DateTime.tryParse(json['createdAtUtc'] ?? '') ?? DateTime.now(),
    );
  }
}
