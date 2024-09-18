import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  // User? user;
  User? _user;
  User? get user => _user;

  //  User? get user => user;
  
  String? nom;

  // AuthProvider({this.nom});

  // If nom comes from a user object, make sure it's correctly fetched
  String? get userNom => nom;
   bool _isAuthenticated = false;

  String _token = '';

  String get token => _token;
  bool get isAuthenticated => _isAuthenticated;
  // bool get isAuthenticated => _token.isNotEmpty;
  AuthProvider(this._authService);

  Future<void> login(String identifier, String password) async {
    try {
      _user = await _authService.login(identifier, password);
       _isAuthenticated = true;
      notifyListeners();
      // notifyListeners();
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      throw Exception('Erreur lors de la connexion: $e');
    }
  }

  Future<void> register(String nom, String prenom, String telephone,
      String email, String password) async {
    try {
      _user =
          await _authService.register(nom, prenom, telephone, email, password);
      notifyListeners();
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      throw Exception('Erreur lors de l\'inscription: $e');
    }
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  // Setter pour la propriété user
  set user(User? updatedUser) {
    _user = updatedUser;
    notifyListeners(); // Notifie les auditeurs que les données de l'utilisateur ont changé
  }

  // Méthode pour mettre à jour les informations de l'utilisateur
  // void updateUser(User updatedUser) {
  //   user = updatedUser;
  // }
   void updateUser(User updatedUser) {
    _user = updatedUser;
    notifyListeners(); // Notifie les auditeurs que les données de l'utilisateur ont changé
  }

}
