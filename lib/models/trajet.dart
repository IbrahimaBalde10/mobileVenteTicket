class Trajet {
  final String? id;
  final String nom;
  final String pointDepart;
  final String pointArrivee;
  final String prix;
  final String? statut;
  final String? description;
  final String? createdAt;
  final String? updatedAt;

  final List<DateDepart>? datesDeDepart; // Ajouté
  final List<HeureDepart>? heuresDeDepart; // Ajouté

  final List<DateDepart>? datesDeparts;
  final List<HeureDepart>? heuresDeparts;


  final double prixAllerSimple;
  final double prixAllerRetour;

  List<DateDepart>? get getDatesDeDepart => datesDeDepart;
  List<HeureDepart>? get getHeuresDeDepart => heuresDeDepart;
 

  Trajet({
    this.id,
    required this.nom,
    required this.pointDepart,
    required this.pointArrivee,
    required this.prix,
    this.statut,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.datesDeDepart, // Ajouté
    this.heuresDeDepart, // Ajouté
    required this.prixAllerSimple,
    required this.prixAllerRetour,
    this.datesDeparts,
    this.heuresDeparts,
  });

  factory Trajet.fromJson(Map<String, dynamic> json) {
    try {
      return Trajet(
        id: json['id'].toString(),
        nom: json['nom'] ?? '',
        pointDepart: json['point_depart'] ?? '',
        pointArrivee: json['point_arrivee'] ?? '',
        prix: json['prix']?.toString() ??
            '', // Assurez-vous que 'prix' est correctement converti
        description: json['description'] ?? '',
        statut: json['statut'] ?? '',
        createdAt: json['created_at'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        datesDeDepart: (json['dates_de_depart'] as List<dynamic>?)
            ?.map((item) => DateDepart.fromJson(item as Map<String, dynamic>))
            .toList(),
        heuresDeDepart: (json['heures_de_depart'] as List<dynamic>?)
            ?.map((item) => HeureDepart.fromJson(item as Map<String, dynamic>))
            .toList(),

        prixAllerSimple: json['prixAllerSimple']?.toDouble() ?? 0.0, // Ajouté
        prixAllerRetour: json['prixAllerRetour']?.toDouble() ?? 0.0, // Ajouté
      );
    } catch (e, stacktrace) {
      print('Erreur lors du parsing du trajet: $e');
      print('Stacktrace: $stacktrace');
      throw Exception('Erreur lors du parsing du trajet: $e');
    }
  }

  double getPriceForType(String type) {
    double basePrice;
    try {
      basePrice = double.parse(this.prix);
    } catch (e) {
      basePrice = 0.0; // Valeur par défaut si la conversion échoue
    }

    if (type == 'aller_simple') {
      return basePrice;
    } else if (type == 'aller_retour') {
      return basePrice * 2;
    } else {
      return 0.0;
    }
  }

}

class DateDepart {
  final int id;
  final int trajetId;
  final String dateDepart;

  DateDepart({
    required this.id,
    required this.trajetId,
    required this.dateDepart,
  });

  @override
  String toString() {
    return 'DateDepart: $dateDepart'; // Remplacez par la propriété réelle
  }
  factory DateDepart.fromJson(Map<String, dynamic> json) {
    return DateDepart(
      id: json['id'],
      trajetId: json['trajet_id'],
      dateDepart: json['dateDepart'],
    );
  }
}

class HeureDepart {
  final int id;
  final int trajetId;
  final String heureDepart;

  HeureDepart({
    required this.id,
    required this.trajetId,
    required this.heureDepart,
  });
  
  @override
  String toString() {
    return 'HeureDepart: $heureDepart'; // Remplacez par la propriété réelle
  }

  factory HeureDepart.fromJson(Map<String, dynamic> json) {
    return HeureDepart(
      id: json['id'],
      trajetId: json['trajet_id'],
      heureDepart: json['heureDepart'],
    );
  }
}
