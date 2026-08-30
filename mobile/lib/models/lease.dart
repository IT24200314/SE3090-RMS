class Lease {
  final String id;
  final String propertyId;
  final String tenantId;
  final DateTime startDate;
  final DateTime endDate;
  final double agreedRent;
  final String status;
  final String? aiDraftedClauses;

  Lease({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.startDate,
    required this.endDate,
    required this.agreedRent,
    required this.status,
    this.aiDraftedClauses,
  });

  factory Lease.fromJson(Map<String, dynamic> json) {
    return Lease(
      id: json['id'] ?? '',
      propertyId: json['propertyId'] ?? '',
      tenantId: json['tenantId'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate: DateTime.tryParse(json['endDate'] ?? '') ?? DateTime.now(),
      agreedRent: (json['agreedRent'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] is int
          ? (json['status'] == 0 ? 'Draft' : json['status'] == 1 ? 'PendingSignature' : json['status'] == 2 ? 'Active' : 'Terminated')
          : (json['status'] ?? 'Active'),
      aiDraftedClauses: json['aiDraftedClauses'],
    );
  }
}
