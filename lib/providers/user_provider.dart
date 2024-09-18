import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class UserProvider with ChangeNotifier {
  final UserService _userService;

   User? _user;
  User? get user => _user;

  // User? _user;
  // User? get user => _user;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  UserProvider(this._userService);

  // Méthode pour récupérer les informations de l'utilisateur connecté
  Future<void> fetchUserProfile() async {
    try {
      _user = await _userService.fetchUserProfile();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
      notifyListeners();
      throw Exception(
          'Erreur lors de la récupération du profil utilisateur: $e');
    }
  }

  // Méthode pour mettre à jour les informations de l'utilisateur connecté
  
  Future<void> updateUserProfile(
    BuildContext context,
    String nom,
    String prenom,
    String email,
    String telephone,
  ) async {
    try {
      // Appeler la méthode de service pour mettre à jour le profil
      await _userService.updateUserProfile(nom, prenom, email, telephone);

      // Mettre à jour l'utilisateur dans le provider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(
        User(nom: nom, prenom: prenom, email: email, telephone: telephone),
      );

      notifyListeners();
    } catch (e) {
      _user = null;
      notifyListeners();
      throw Exception(
          'Erreur lors de la modification du profil utilisateur: $e');
    }
  }
}
