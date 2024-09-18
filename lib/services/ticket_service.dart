import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/trajet.dart';
import '../client/dio_client.dart';

class TicketService {
  final Dio _dio;

  TicketService(DioClient dioClient) : _dio = dioClient.dio;

  Future<List<Trajet>> getAllTrajets() async {
    try {
      // Récupérer le token depuis le stockage persistant
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/trajets',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Réponse de l\'API: ${response.data}');

        // Extraire la liste des trajets à partir de la clé 'data'
        List<dynamic> trajetList = response.data['data'] as List<dynamic>;

        // Retourner la liste des trajets mappée aux objets Trajet
        return trajetList.map((json) => Trajet.fromJson(json)).toList();
      } else {
        throw Exception(
            'Échec de la récupération des trajets: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération des trajets : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération des trajets : ${e.message}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des trajets : $e');
    }
  }


// statut de ticket du user connecté
  Future<Map<String, dynamic>> checkTicketStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        '/tickets/status',
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
            'Échec de la récupération du statut du ticket: ${response.statusMessage}');
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(
            'Erreur lors de la récupération du statut du ticket : ${e.response?.data['message'] ?? e.message}');
      } else {
        throw Exception(
            'Erreur lors de la récupération du statut du ticket : ${e.message}');
      }
    } catch (e) {
      throw Exception(
          'Erreur lors de la récupération du statut du ticket : $e');
    }
  }

  // // Acheter un ticket
  // Future<Map<String, dynamic>> acheterTicket({
  //   required int trajetId,
  //   required String type,
  //   required int quantity,
  //   required List<String> passengers,
  //   required String methodePaiement,
  //   required String dateDepart,
  //   required String heureDepart,
  // }) async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('auth_token');

  //     if (token == null || token.isEmpty) {
  //       throw Exception('Token non trouvé ou vide');
  //     }

  //     final response = await _dio.post(
  //       'http://localhost:8000/api/tickets/create',
  //       data: {
  //         'trajet_id': trajetId,
  //         'type': type,
  //         'quantity': quantity,
  //         'passengers': passengers,
  //         'methodePaiement': methodePaiement,
  //         'date_depart': dateDepart,
  //         'heure_depart': heureDepart,
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
  //       throw Exception(
  //           'Échec lors de l\'achat du ticket: ${response.statusMessage}');
  //     }
  //   } on DioError catch (e) {
  //     if (e.response != null) {
  //       throw Exception(
  //           'Erreur lors de l\'achat du ticket: ${e.response?.data['message'] ?? e.message}');
  //     } else {
  //       throw Exception('Erreur lors de l\'achat du ticket: ${e.message}');
  //     }
  //   } catch (e) {
  //     throw Exception('Erreur lors de l\'achat du ticket: $e');
  //   }
  // }
}

