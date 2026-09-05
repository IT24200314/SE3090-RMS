class MaintenanceTicket {
  final String id;
  final String propertyId;
  final String tenantId;
  final String issueDescription;
  final String photoUrl;
  final String priority;
  final String status;
  final double estimatedCost;
  final String? aiTriageSummary;
  final String? assignedContractorId;
  final String? latitude;
  final String? longitude;
  final DateTime createdAtUtc;

  MaintenanceTicket({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    required this.issueDescription,
    required this.photoUrl,
    required this.priority,
    required this.status,
    required this.estimatedCost,
    this.aiTriageSummary,
    this.assignedContractorId,
    this.latitude,
    this.longitude,
    required this.createdAtUtc,
  });

  factory MaintenanceTicket.fromJson(Map<String, dynamic> json) {
    return MaintenanceTicket(
      id: json['id'] ?? '',
      propertyId: json['propertyId'] ?? '',
      tenantId: json['tenantId'] ?? '',
      issueDescription: json['issueDescription'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      priority: json['priority'] is int 
          ? (json['priority'] == 0 ? 'Low' : json['priority'] == 1 ? 'Medium' : json['priority'] == 2 ? 'High' : 'Emergency')
          : (json['priority'] ?? 'Medium'),
      status: json['status'] is int
          ? (json['status'] == 0 ? 'Open' : json['status'] == 1 ? 'Assigned' : json['status'] == 2 ? 'PendingManagerApproval' : json['status'] == 3 ? 'InProgress' : 'Resolved')
          : (json['status'] ?? 'Open'),
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble() ?? 0.0,
      aiTriageSummary: json['aiTriageSummary'],
      assignedContractorId: json['assignedContractorId'],
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      createdAtUtc: DateTime.tryParse(json['createdAtUtc'] ?? '') ?? DateTime.now(),
    );
  }
}
