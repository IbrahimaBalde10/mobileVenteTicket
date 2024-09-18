import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/typeAbonnement.dart';
import '../client/dio_client.dart';

class TypeAbonnementService {
  final Dio _dio;

  TypeAbonnementService(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<TypeAbonnement>> getAllTypesAbonnements() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/subscriptionTypes',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Réponse de l\'API: ${response.data}');

        // Si l'API renvoie un objet JSON avec une clé 'data' contenant la liste
        List<dynamic> typeAbonnementList = response.data['data'];

        return typeAbonnementList
            .map((json) => TypeAbonnement.fromJson(json))
            .toList();
      } else {
        throw Exception(
            'Échec de la récupération des types d\'abonnements: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération des types d\'abonnements : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération des types d\'abonnements : ${e.message}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération des types d\'abonnements : $e');
    }
  }

  Future<TypeAbonnement> getTypesAbonementById(int subscriptionType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/subscriptionTypes/$subscriptionType',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Réponse de l\'API: ${response.data}');

        // Traiter directement la réponse comme un objet
        return TypeAbonnement.fromJson(response.data);
      } else {
        throw Exception(
            'Échec de la récupération de l\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération du type d\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération du type d\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du type d\'abonnement : $e');
    }
  }

// statut de labonnement du user connecté
  Future<Map<String, dynamic>> checkSubscriptionStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/subscriptions/status',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Réponse de l\'API: ${response.data}');

        // Retourner la réponse décodée sous forme de Map
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Échec de la récupération du statut d\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération du statut d\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération du statut d\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du statut d\'abonnement : $e');
    }
  }


// Vérifier le statut de l'abonnement
  Future<Map<String, dynamic>> verifierAbonnementClient(
      String telephone) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/subscriptions/verifierAbonnementClient',
        queryParameters: {
          'telephone': telephone, // Utilisation du numéro de téléphone
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        // On s'assure que les données sont correctement typées
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Échec de la récupération du statut d\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération du statut d\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération du statut d\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du statut d\'abonnement : $e');
    }
  }

  // Renouveler l'abonnement
  Future<void> renewSubscription({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.post(
        '/subscriptions/renouvelerAbonnementClient',
        data: {
          'telephone': telephone,
          'subscription_type_id': subscriptionTypeId,
          'methodePaiement': methodePaiement,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception(
            'Échec du renouvellement de l\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors du renouvellement de l\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors du renouvellement de l\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors du renouvellement de l\'abonnement : $e');
    }
  }


// vendre un abonnement
  // Future<Map<String, dynamic>> vendreAbonnement({
  //   required String telephone,
  //   required int subscriptionTypeId,
  //   required String methodePaiement,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token');

  //     if (token == null || token.isEmpty) {
  //       throw Exception('Token non trouvé ou vide');
  //     }

  //     final response = await _dio.post(
  //       'http://localhost:8000/api/subscriptions/vendreAbonnement',
  //       data: {
  //         'telephone': telephone,
  //         'subscription_type_id': subscriptionTypeId,
  //         'methodePaiement': methodePaiement,
  //       },
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           'Content-Type': 'application/json',
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       return Map<String, dynamic>.from(response.data);
  //     } else {
  //       throw Exception('Échec de la vente d\'abonnement: ${response.statusMessage}');
  //     }
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       throw Exception('Erreur lors de la vente d\'abonnement : ${e.response?.data['message'] ?? e.message}');
  //     } else {
  //       throw Exception('Erreur lors de la vente d\'abonnement : ${e.message}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur lors de la vente d\'abonnement : $e');
  //   }
  // }
Future<Map<String, dynamic>> vendreAbonnement({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.post(
        'http://localhost:8000/api/subscriptions/vendreAbonnement',
        data: {
          'telephone': telephone,
          'subscription_type_id': subscriptionTypeId,
          'methodePaiement': methodePaiement,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Échec de la vente d\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        // Renvoie le message d'erreur de la réponse de l'API
        throw Exception(
            'Erreur lors de la vente d\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        // Erreurs liées au réseau
        throw Exception('Erreur lors de la vente d\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la vente d\'abonnement : $e');
    }
  }
  
// acheter un abonnement
  Future<Map<String, dynamic>> acheterAbonnement({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.post(
        'http://localhost:8000/api/subscriptions/create',
        data: {
          'telephone': telephone,
          'subscription_type_id': subscriptionTypeId,
          'methodePaiement': methodePaiement,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception(
            'Échec lors de l\'achat d\'abonnement: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de l\'achat d\'abonnement : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception('Erreur lors de l\'achat d\'abonnement : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'achat d\'abonnement : $e');
    }
  }

}


