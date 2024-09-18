import 'package:dio/dio.dart';

class DioClient {
  Dio dio;

  DioClient() : dio = Dio() {
    dio.options.baseUrl =
        'http://localhost:8000/api'; // Remplace par l'URL de ton API
        // 'http://10.0.2.2:8000/api'; // Utilisez 10.0.2.2 pour les émulateurs Android

    // dio.options.connectTimeout = 5000; // Timeout pour les connexions
    // dio.options.receiveTimeout = 3000; // Timeout pour la réception des données
    dio.interceptors.add(LogInterceptor(
        responseBody: true)); // Ajoute un intercepteur pour loguer les requêtes
  }
}
