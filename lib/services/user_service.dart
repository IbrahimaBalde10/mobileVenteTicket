import 'package:dio/dio.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../client/dio_client.dart';

class UserService {
  final Dio _dio;

  UserService(DioClient dioClient) : _dio = dioClient.dio;
  
  Future<User> fetchUserProfile() async {
    try {
      // Récupérer le token depuis le stockage persistant
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/users/showProfile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // La réponse semble être directement l'objet utilisateur
      var userData = response.data;

      print('Réponse de l\'API: $userData');
      print('Email: ${userData['email']}');

      // Retourner l'objet User à partir des données JSON
      return User.fromJson(userData);
    } catch (e) {
      print('Erreur lors de la récupération du profil : $e');
      throw Exception('Erreur lors de la récupération du profil : $e');
    }
  }

// editer
  // Future<User> updateUserProfile(String nom, String prenom, String email,
  //     String telephone, String password) async {
  // Future<User> updateUserProfile(String nom, String prenom, String email,
  //     String telephone) async {
  //   try {
  //     // Récupérer le token depuis le stockage persistant
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token');

  //     if (token == null || token.isEmpty) {
  //       throw Exception('Token non trouvé ou vide');
  //     }
      
      
  //     final response = await _dio.put(
  //       '/users/updateProfile',
  //       data: {
  //         'nom': nom,
  //         'prenom': prenom,
  //         'email': email,
  //         'telephone': telephone,
  //         // 'password': password,
  //       },
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //     );

  //     // La réponse semble être directement l'objet utilisateur
  //     var userData = response.data;

  //     print('Réponse de l\'API: $userData');
  //     print('Email: ${userData['email']}');

  //     // Retourner l'objet User à partir des données JSON
  //     return User.fromJson(userData);
  //   } catch (e) {
  //     print('Erreur lors de la modification du profil : $e');
  //     throw Exception('Erreur lors de la modification du profil : $e');
  //   }
  // }



  Future<void> updateUserProfile(
    String nom,
    String prenom,
    String email,
    String telephone,
  ) async {
    try {
      // Récupérer le token depuis le stockage persistant
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      // Envoyer la requête PUT à l'API
      final response = await _dio.put(
        '/users/updateProfile',
        data: {
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'telephone': telephone,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      // Vérifier la réponse
      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la mise à jour du profil');
      }

      print('Réponse de l\'API: ${response.data}');
    } catch (e) {
      print('Erreur lors de la modification du profil : $e');
      throw Exception('Erreur lors de la modification du profil : $e');
    }
  }


}
