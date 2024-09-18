class User {
  final String? id;
  final String nom;
  final String prenom;
  final String telephone;
  final String? role;
  final String email;
 
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? token;
  final String? password;
  final String? profilePhoto; // Field for profile photo URL

  User({
     this.id,
    required this.nom,
    required this.prenom,
    required this.telephone,
     this.role,
    required this.email,
     this.password,
    this.emailVerifiedAt,
     this.createdAt,
     this.updatedAt,
    this.token, // Le token peut être null au début
    this.profilePhoto, // Initialize profile photo here
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nom: json['nom'],
      prenom: json['prenom'],
      telephone: json['telephone'],
      role: json['role'],
      email: json['email'],
      password: json['password'],
      emailVerifiedAt:
          json['email_verified_at'] as String?, // Gérer les valeurs nulles
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      token: json['token'] as String?, // Gérer les valeurs nulles
     
    );
  }
}
