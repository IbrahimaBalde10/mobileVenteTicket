import 'package:flutter/material.dart';
import '../services/ticket_service.dart';

class TicketProvider extends ChangeNotifier {
  final TicketService _ticketService;
  // List<dynamic> _ticketTypes = [];
  bool _loading = false;
  String? _errorMessage;
  TicketProvider(this._ticketService);

  // List<dynamic> get ticketTypes => _ticketTypes;
  bool get loading => _loading;

  //
  // final TicketService _ticketService = TicketService();

  // bool _loading = false;
  // String? _errorMessage;

  // bool get loading => _loading;
  // String? get errorMessage => _errorMessage;
  //
  String _status = '';
  String _expirationDate = '';
  String _nomClient = '';
  String _qrCode = '';

  String get status => _status;
  String get expirationDate => _expirationDate;

  String get nomClient => _nomClient;
  String get qrCode => _qrCode;
  String? get errorMessage => _errorMessage;

// verifie mon ticket
  Future<void> fetchSubscriptionStatus() async {
    _loading = true;
    notifyListeners();

    try {
      // Appel de la méthode sans passer de token directement
      final response = await _ticketService.checkTicketStatus();

      // Vérifiez le type de chaque champ et convertissez si nécessaire
      _status = response['status'] ?? '';
      _expirationDate = response['expirationDate'] ?? '';

      ''; // Ajout de vérifications pour éviter les erreurs
      _nomClient = response['nomClient']?.toString() ?? ''; // Idem
      _qrCode = response['qrCode']?.toString() ?? ''; // Idem
      _errorMessage = null;

      //   _idType = response['subscription_id']?.toString() ?? '';
    } catch (e) {
      // Gestion des erreurs
      _errorMessage = e.toString();
    }
    _loading = false;
    notifyListeners();
  }

  // // Acheter un ticket
  // Future<void> acheterTicket({
  //   required int trajetId,
  //   required String type,
  //   required int quantity,
  //   required List<String> passengers,
  //   required String methodePaiement,
  //   required String dateDepart,
  //   required String heureDepart,
  // }) async {
  //   _loading = true;
  //   notifyListeners();

  //   try {
  //     final response = await _ticketService.acheterTicket(
  //       trajetId: trajetId,
  //       type: type,
  //       quantity: quantity,
  //       passengers: passengers,
  //       methodePaiement: methodePaiement,
  //       dateDepart: dateDepart,
  //       heureDepart: heureDepart,
  //     );

  //     // Traitez la réponse comme vous le souhaitez
  //     print('Réponse de l\'API: $response');
  //     _errorMessage = null; // Réinitialisez les messages d'erreur
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   }

  //   _loading = false;
  //   notifyListeners();
  // }
}
