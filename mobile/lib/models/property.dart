class Property {
  final String id;
  final String title;
  final String description;
  final String address;
  final double monthlyRent;
  final double securityDeposit;
  final String status; // "Available", "Occupied", "UnderMaintenance"
  final String landlordId;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.address,
    required this.monthlyRent,
    required this.securityDeposit,
    required this.status,
    required this.landlordId,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0.0,
      securityDeposit: (json['securityDeposit'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] is int 
          ? (json['status'] == 0 ? 'Available' : json['status'] == 1 ? 'Occupied' : 'UnderMaintenance')
          : (json['status'] ?? 'Available'),
      landlordId: json['landlordId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'address': address,
    'monthlyRent': monthlyRent,
    'securityDeposit': securityDeposit,
    'status': status,
    'landlordId': landlordId,
  };
}
