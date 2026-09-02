class TenantApplication {
  final String id;
  final String tenantId;
  final String propertyId;
  final double monthlyIncome;
  final String identityDocUrl;
  final String status;
  final int aiRiskScore;
  final String? aiScreeningNotes;
  final DateTime createdAtUtc;

  TenantApplication({
    required this.id,
    required this.tenantId,
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
      propertyId: json['propertyId'] ?? '',
      monthlyIncome: (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0,
      identityDocUrl: json['identityDocUrl'] ?? '',
      status: json['status'] is int
          ? (json['status'] == 0 ? 'Pending' : json['status'] == 1 ? 'Approved' : json['status'] == 2 ? 'Rejected' : 'ReviewRequired')
          : (json['status'] ?? 'Pending'),
      aiRiskScore: json['aiRiskScore'] ?? 0,
      aiScreeningNotes: json['aiScreeningNotes'],
      createdAtUtc: DateTime.tryParse(json['createdAtUtc'] ?? '') ?? DateTime.now(),
    );
  }
}
