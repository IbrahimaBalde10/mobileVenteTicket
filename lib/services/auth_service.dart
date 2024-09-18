import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import '../models/user.dart';
import '../client/dio_client.dart';

class AuthService {
  final Dio _dio;

  AuthService(DioClient dioClient) : _dio = dioClient.dio;

  Future<User> login(String identifier, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'identifier': identifier,
        'password': password,
      });

      if (response.statusCode == 200) {
        print('Réponse de l\'API: ${response.data}');
        var userData = response.data['user'];
        var token = response.data['token'] ?? '';

        if (token.isEmpty) {
          throw Exception('Token non trouvé après la connexion');
        }

        // Stockez le token dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        userData['token'] = token; // Ajoute le token au userData

        // Débogage des valeurs nulles
        print('Nom: ${userData['nom']}');
        print('Email: ${userData['email']}');
        print('Profile Photo: ${userData['profile_photo']}');

        return User.fromJson(userData);
      } else {
        throw Exception('Échec de la connexion: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la connexion : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Erreur lors de la connexion : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }

  // Future<User> login(String identifier, String password) async {
  //   try {
  //     final response = await _dio.post('/login', data: {
  //       'identifier': identifier,
  //       'password': password,
  //     });

  //     if (response.statusCode == 200) {
  //       print('Réponse de l\'API: ${response.data}');
  //       var userData = response.data['user'];
  //       var token = response.data['token'] ?? '';
  //       userData['token'] = token; // Ajoute le token au userData

  //       //  final token = response.data['token'];

  //       // Stockez le token dans SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('auth_token', token);

  //       return User.fromJson(userData);
  //     } else {
  //       throw Exception('Échec de la connexion: ${response.statusMessage}');
  //     }
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       throw Exception(
  //           'Erreur lors de la connexion : ${e.response?.data['message'] ?? e.message}');
  //     } else {
  //       throw Exception('Erreur lors de la connexion : ${e.message}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur lors de la connexion : $e');
  //   }
//   // }
// Future<User> login(String identifier, String password) async {
//     try {
//       final response = await _dio.post('/login', data: {
//         'identifier': identifier,
//         'password': password,
//       });

//       if (response.statusCode == 200) {
//         print('Réponse de l\'API: ${response.data}');
//         var userData = response.data['user'];
//         var token = response.data['token'] ?? '';

//         if (token.isEmpty) {
//           throw Exception('Token non trouvé après la connexion');
//         }

//         // Stockez le token dans SharedPreferences
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('auth_token', token);

//         userData['token'] = token; // Ajoute le token au userData

//         return User.fromJson(userData);
//       } else {
//         throw Exception('Échec de la connexion: ${response.statusMessage}');
//       }
//     } on DioError catch (e) {
//       if (e.response != null) {
//         throw Exception(
//             'Erreur lors de la connexion : ${e.response?.data['message'] ?? e.message}');
//       } else {
//         throw Exception('Erreur lors de la connexion : ${e.message}');
//       }
//     } catch (e) {
//       throw Exception('Erreur lors de la connexion : $e');
//     }
//   }

  Future<User> register(String nom, String prenom, String telephone,
      String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        print('Réponse de l\'API: ${response.data}');
        var userData = response.data['user'];
        var token = response.data['token'] ?? '';
        userData['token'] = token; // Ajoute le token au userData
        return User.fromJson(userData);
      } else {
        throw Exception('Échec de l\'inscription: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de l\'inscription : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Erreur lors de l\'inscription : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'inscription : $e');
    }
  }
}
