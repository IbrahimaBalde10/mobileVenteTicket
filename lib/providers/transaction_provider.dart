import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService;

  TransactionProvider(this._transactionService);

  List<AppTransaction> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppTransaction> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchAllTransactions() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _transactionService.getAllUserTransactions();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Map<String, dynamic> _statistics = {};
  // bool _isLoading = false;
  // String? _errorMessage;

  Map<String, dynamic> get statistics => _statistics;
  // bool get isLoading => _isLoading;
  // String? get errrMessage => _errorMessage;

  Future<void> fetchAllStatistiques() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Récupération des données brutes
      final data = await _transactionService.getAllUserStatistiques();

      // Assurez-vous que les données sont bien un Map<String, dynamic>
      if (data is Map<String, dynamic>) {
        _statistics = data; // Stocker directement le Map
      } else {
        _errorMessage = 'Les données récupérées ne sont pas au format attendu.';
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

