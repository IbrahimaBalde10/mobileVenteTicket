import 'package:mobie_app/models/transaction.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionService {
  final Dio _dio = Dio();

  Future<List<AppTransaction>> getAllUserTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        'http://localhost:8000/api/transactions/maConso',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(
          'Response: ${response.data}'); // Vérifiez la réponse dans la console

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        List<dynamic> transactions =
            data['transactions']; // Extraire la liste des transactions
        return transactions
            .map((item) => AppTransaction.fromJson(item))
            .toList();
      } else {
        throw Exception('Erreur lors de la récupération des transactions');
      }
    } on DioError catch (e) {
      print('DioError: ${e.response?.data}');
      throw Exception(
          'Erreur Dio: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur: $e');
    }
  }

Future<Map<String, dynamic>> getAllUserStatistiques() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception('Token non trouvé ou vide');
      }

      final response = await _dio.get(
        'http://localhost:8000/api/transactions/statistiquesUser',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(
          'Response: ${response.data}'); // Vérifiez la réponse dans la console

      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data;
        return data; // Retourner les données directement
      } else {
        throw Exception('Erreur lors de la récupération des statistiquesUser');
      }
    } on DioError catch (e) {
      print('DioError: ${e.response?.data}');
      throw Exception(
          'Erreur Dio: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      print('Erreur: $e');
      throw Exception('Erreur: $e');
    }
  }

}
