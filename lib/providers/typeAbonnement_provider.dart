import 'dart:ui';

import 'package:flutter/material.dart';
import '../models/typeAbonnement.dart';
import '../services/typeAbonnement_service.dart';
import 'dart:async';

class TypeAbonnementProvider with ChangeNotifier {
  List<TypeAbonnement> _typesAbonnements = [];
  TypeAbonnement? _typeAbonnement;
  bool _isLoading = false;
  String? _errorMessage;

  // Variable pour stocker le timer
  // Timer? _debounce;

  // Getters
  TypeAbonnement? get typeAbonnement => _typeAbonnement;
  List<TypeAbonnement> get typeAbonnements => _typesAbonnements;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final TypeAbonnementService _typeAbonnementService;

  TypeAbonnementProvider(this._typeAbonnementService);
  String _status = '';
  String _endDate = '';
  String _idType = '';
  String _nomType = '';
  String _qr_code = '';

  String get status => _status;
  String get endDate => _endDate;
  String get idType => _idType;

  String get nomType => _nomType;
  String get qr_code => _qr_code;
//

  String _qrCode = '';

  String get qrCode => _qrCode;


  // Méthode pour récupérer tous les types dabonnements
  Future<void> fetchTypesAbonnements() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _typesAbonnements = await _typeAbonnementService.getAllTypesAbonnements();
      _isLoading = false;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  // Méthode pour récupérer un trajet spécifique par ID
  Future<TypeAbonnement> fetchTypeAbonnementById(int subscriptionType) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _typeAbonnement =
          await _typeAbonnementService.getTypesAbonementById(subscriptionType);
      _isLoading = false;
      notifyListeners();
      return _typeAbonnement!;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow; // Propager l'erreur pour que le FutureBuilder puisse la capturer
    }
  }

// verifie mon abonnement
  Future<void> fetchSubscriptionStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Appel de la méthode sans passer de token directement
      final response = await _typeAbonnementService.checkSubscriptionStatus();

      // Vérifiez le type de chaque champ et convertissez si nécessaire
      _status = response['status'] ?? '';
      _endDate = response['end_date'] ?? '';

      _idType = response['idType']?.toString() ??
          ''; // Ajout de vérifications pour éviter les erreurs
      _nomType = response['nomType']?.toString() ?? ''; // Idem
      _qr_code = response['qr_code']?.toString() ?? ''; // Idem
//  'qr_code' => $subscription->qr_code,
      _errorMessage = null;
    } catch (e) {
      // Gestion des erreurs
      _errorMessage = e.toString();
    }
    // mariama.DAIALLO21@ESTM.EDU.SN

    _isLoading = false;
    notifyListeners();
  }

  // //verifier
  Future<void> checkSubscriptionStatus(String telephone) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response =
          await _typeAbonnementService.verifierAbonnementClient(telephone);

      // Analyse de la réponse de l'API
      if (response['message'] == "Son abonnement est encore valide.") {
        _status = 'valid';
        _endDate = response['end_date'] ?? '';
        _nomType = response['subscription_type'] ?? '';
        _errorMessage = null;
      } else if (response['message'] == "Abonnement expiré.") {
        _status = 'expired';
        _endDate = response['end_date'] ?? '';
        _idType = response['subscription_id']?.toString() ?? '';
        _nomType = response['subscription_type'] ?? '';
        _errorMessage = null;
      } else if (response['message'] == "Cet utilisateur n'existe pas.") {
        _status = 'not_found';
        _errorMessage = response['message'];
        _endDate = '';
        _nomType = '';
      } else if (response['message'] ==
          "Cet utilisateur n'a pas d'abonnement existant.") {
        _status = 'no_subscription';
        _errorMessage = response['message'];
        _endDate = '';
        _nomType = '';
      } else {
        _status = '';
        _errorMessage = 'Erreur inconnue';
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

//
  Future<void> renewSubscription({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _typeAbonnementService.renewSubscription(
        telephone: telephone,
        subscriptionTypeId: subscriptionTypeId,
        methodePaiement: methodePaiement,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

// vendre un abonnement
  // Future<void> vendreAbonnement({
  //   required String telephone,
  //   required int subscriptionTypeId,
  //   required String methodePaiement,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     final response = await _typeAbonnementService.vendreAbonnement(
  //       telephone: telephone,
  //       subscriptionTypeId: subscriptionTypeId,
  //       methodePaiement: methodePaiement,
  //     );

  //     // Traitez la réponse comme vous le souhaitez
  //     print('Réponse de l\'API: $response');
  //     _errorMessage = null; // Réinitialisez les messages d'erreur
  //   } catch (e) {
  //     _errorMessage = e.toString();
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }
Future<void> vendreAbonnement({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    _isLoading = true;
    _errorMessage = null; // Réinitialiser les messages d'erreur avant l'appel
    notifyListeners();

    try {
      final response = await _typeAbonnementService.vendreAbonnement(
        telephone: telephone,
        subscriptionTypeId: subscriptionTypeId,
        methodePaiement: methodePaiement,
      );

      // Traitez la réponse si nécessaire
      print('Réponse de l\'API: $response');
      _errorMessage = null; // Si tout est OK, réinitialiser l'erreur
    } catch (e) {
      // Stocker le message d'erreur capturé pour l'afficher
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  
// acheter un abonnement
  Future<void> acheterAbonnement({
    required String telephone,
    required int subscriptionTypeId,
    required String methodePaiement,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _typeAbonnementService.acheterAbonnement(
        telephone: telephone,
        subscriptionTypeId: subscriptionTypeId,
        methodePaiement: methodePaiement,
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
