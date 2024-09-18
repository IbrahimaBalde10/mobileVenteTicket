class TypeAbonnement {
  final String id;
  final String name;
  final double price;
  final String description;
  final String statut;
  final DateTime createdAt;
  final DateTime updatedAt;

  TypeAbonnement({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.statut,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TypeAbonnement.fromJson(Map<String, dynamic> json) {
    return TypeAbonnement(
      id: json['id'].toString(),
      name: json['name'],
      // Utilisation de double.tryParse pour gérer les chaînes comme "180.00"
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : json['price']
              .toDouble(), // Utiliser toDouble si c'est déjà un nombre
      description: json['description'] ?? '',
      statut: json['statut'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

}
