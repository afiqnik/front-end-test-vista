class Company {
  final int id;
  final String name;
  final String registrationNumber;
  final List<Service> services;

  Company({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.services,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      registrationNumber: json['registrationNumber'] as String,
      services: (json['services'] as List<dynamic>? ?? [])
          .map((item) => Service.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Service {
  final int id;
  final int companyId;
  final String name;
  final String description;
  final String price;

  Service({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as int,
      companyId: json['companyId'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'].toString(),
    );
  }
}
