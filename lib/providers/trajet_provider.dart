import 'package:flutter/material.dart';
import '../models/trajet.dart';
import '../services/trajet_service.dart';
import 'dart:async';

class TrajetProvider with ChangeNotifier {
  List<Trajet> _trajets = [];
  bool _isLoading = false;
  String? _errorMessage;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  Trajet? _trajet;
  String? _selectedTime; // Pour stocker l'heure sélectionnée
  Trajet? _selectedTrajet; // Pour stocker le trajet sélectionné

  // Variable pour stocker le timer
  Timer? _debounce;

  // Getters
  Trajet? get trajet => _trajet;
  List<Trajet> get trajets => _trajets;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Trajet? get selectedTrajet => _selectedTrajet;
  String? get selectedTime => _selectedTime;
  String? get selectedDate => _selectedDate;
  // double totalPrice;
  String?
      _selectedDate; // Ajout de la variable pour stocker la date sélectionnée

  final TrajetService _trajetService;

  TrajetProvider(this._trajetService);

  List<String> _clientNames = [];

  List<String> get clientNames => _clientNames;


  void setClientNames(List<String> names) {
    _clientNames = names;
    notifyListeners();
  }

  //
  // Méthode pour récupérer tous les trajets
  Future<void> fetchTrajets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trajets = await _trajetService.getAllTrajets();
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  // Méthode pour récupérer un trajet spécifique par ID
  Future<Trajet> fetchTrajetById(int trajetId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _trajet = await _trajetService.getTrajetById(trajetId);
      _isLoading = false;
      notifyListeners();
      return _trajet!;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow; // Propager l'erreur pour que le FutureBuilder puisse la capturer
    }
  }

// Méthode pour définir le trajet sélectionné
  void setSelectedTrajet(Trajet? trajet) {
    print('Trajet sélectionnée: $trajet');
    _selectedTrajet = trajet;
    _selectedDate = null; // Réinitialiser la date lorsque le trajet change
    _selectedTime = null; // Réinitialiser l'heure lorsque le trajet change
    notifyListeners();
  }

  // Méthode pour définir l'heure sélectionnée
  void setSelectedTime(String? time) {
    // print('Heure sélectionnée: $time');
    _selectedTime = time;
    notifyListeners();
  }

  // Méthode pour définir la date sélectionnée
  void setSelectedDate(String? date) {
    // print('Date sélectionnée: $date');
    _selectedDate = date;
    notifyListeners();
  }

// Trajet Provider - assurez-vous que ces méthodes fonctionnent bien
  List<DateDepart> get availableDates {
    // Assurez-vous que `datesDeparts` est correctement assigné
    return _selectedTrajet?.datesDeDepart ??
        []; // Assurez-vous d'utiliser la bonne variable
  }

  List<HeureDepart> get availableTimes {
    // Assurez-vous que `heuresDeparts` est correctement assigné
    return _selectedTrajet?.heuresDeDepart ??
        []; // Assurez-vous d'utiliser la bonne variable
  }

// Méthode pour calculer le prix en fonction du trajet sélectionné, du type et de la quantité
  double calculatePrice(int quantity, String type) {
    if (_selectedTrajet == null) return 0.0;
    // print('trajetSélectionnée: $_selectedTrajet');
    // print('quantite: $quantity');
    // print('type: $type');
    double basePrice = _selectedTrajet!.getPriceForType(type);
    // return basePrice * quantity;
    _totalPrice = basePrice * quantity;
    return _totalPrice;
  }

// Vendre un ticket

// covertir lheure
String convertToH_iFormat(String heure) {
    try {
      final dateTime = DateTime.parse(
          '2021-01-01 $heure'); // Ajouter une date fixe pour la conversion
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return '00:00'; // Valeur par défaut en cas d'erreur
    }
  }

  Future<void> vendreTicket({
    required int trajetId,
    required String type,
    required int quantity,
    required List<String> passengers,
    required String telephone,
    required String nom,
    required String methodePaiement,
    required String dateDepart,
    required String heureDepart,
  }) async {
    _isLoading = true;
    notifyListeners();

   final formattedHeureDepart = convertToH_iFormat(heureDepart);


    try {
      final response = await _trajetService.vendreTicket(
        trajetId: trajetId,
        type: type,
        quantity: quantity,
        passengers: passengers,
         telephone: telephone,
        nom: nom,
        methodePaiement: methodePaiement,
        dateDepart: dateDepart,
        // heureDepart: heureDepart,
        heureDepart: formattedHeureDepart,

      );

      // Traitez la réponse comme vous le souhaitez
      print('Réponse de l\'API: $response');
      _errorMessage = null; // Réinitialisez les messages d'erreur
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  
// Acheter un ticket

// covertir lheure

  Future<void> acheterTicket({
    required int trajetId,
    required String type,
    required int quantity,
    required List<String> passengers,
    required String methodePaiement,
    required String dateDepart,
    required String heureDepart,
  }) async {
    _isLoading = true;
    notifyListeners();

    final formattedHeureDepart = convertToH_iFormat(heureDepart);

    try {
      final response = await _trajetService.acheterTicket(
        trajetId: trajetId,
        type: type,
        quantity: quantity,
        passengers: passengers,
        methodePaiement: methodePaiement,
        dateDepart: dateDepart,
        heureDepart: formattedHeureDepart,
      );

      // Traitez la réponse comme vous le souhaitez
      print('Réponse de l\'API: $response');
      _errorMessage = null; // Réinitialisez les messages d'erreur
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
