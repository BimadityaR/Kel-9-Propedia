class Property {
  final int id;
  final String title;
  final double price;
  final String type;
  final String status;
  final String description;
  final String location;

  Property({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
    required this.status,
    required this.description,
    required this.location,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'],
      price:
          json['price'] is String
              ? double.parse(json['price'])
              : (json['price'] as num).toDouble(),
      type: json['type'],
      status: json['status'] ?? 'pending',
      description: json['description'] ?? '',
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'price': price,
      'type': type,
      'status': status,
      'description': description,
      'location': location,
    };
  }
}