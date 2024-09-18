import 'package:flutter/material.dart';
import 'package:mobie_app/providers/ticket_provider.dart';
import 'package:provider/provider.dart';
import '../../models/trajet.dart';
import '../../providers/trajet_provider.dart';
import '../../providers/auth_provider.dart';

class AchatTicketPage extends StatefulWidget {
  @override
  _AchatTicketPageState createState() => _AchatTicketPageState();
}

class _AchatTicketPageState extends State<AchatTicketPage> {
  String? _selectedType;
  int _quantity = 1;
  double _totalPrice = 0.0;
  String? _selectedPaymentMethod;
  List<TextEditingController> _clientControllers = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    Provider.of<TrajetProvider>(context, listen: false).fetchTrajets();
    _updateClientControllers();
  }

  void _updateClientControllers() {
    setState(() {
      _clientControllers.clear();
      for (int i = 1; i < _quantity; i++) {
        _clientControllers.add(TextEditingController());
      }
    });
  }

  void _calculatePrice(TrajetProvider trajetProvider) {
    setState(() {
      _totalPrice =
          trajetProvider.calculatePrice(_quantity, _selectedType ?? '');
    });
  }

  void _validateAndProceed(
      AuthProvider authProvider, TrajetProvider trajetProvider) {
    if (trajetProvider.selectedTrajet == null) {
      _showErrorMessage('Veuillez sélectionner un trajet.');
      return;
    }

    if (trajetProvider.selectedDate == null) {
      _showErrorMessage('Veuillez sélectionner une date.');
      return;
    }

    if (trajetProvider.selectedTime == null) {
      _showErrorMessage('Veuillez sélectionner une heure.');
      return;
    }

    if (_selectedType == null) {
      _showErrorMessage('Veuillez sélectionner un type de billet.');
      return;
    }

    for (int i = 1; i < _quantity; i++) {
      if (_clientControllers[i - 1].text.isEmpty) {
        _showErrorMessage('Veuillez entrer le nom du client additionnel ${i}.');
        return;
      }
    }

    if (_selectedPaymentMethod == null) {
      _showErrorMessage('Veuillez sélectionner un mode de paiement.');
      return;
    }

    // Si tout est valide, afficher le récapitulatif de l'achat
    _showRecap(authProvider, trajetProvider);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showRecap(AuthProvider authProvider, TrajetProvider trajetProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Récapitulatif de l\'achat'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Trajet: ${trajetProvider.selectedTrajet?.nom}'),
                Text('Date: ${trajetProvider.selectedDate}'),
                Text('Heure: ${trajetProvider.selectedTime}'),
                Text('Type de billet: $_selectedType'),
                Text('Quantité: $_quantity'),
                if (_quantity > 1)
                  ...List.generate(_quantity - 1, (index) {
                    return Text(
                        'Client additionnel ${index + 1}: ${_clientControllers[index].text}');
                  }),
                Text('Mode de paiement: $_selectedPaymentMethod'),
                Text('Prix total: $_totalPrice'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Logique de paiement ici
                _processPayment();
              },
              child: Text('Payer'),
            ),
          ],
        );
      },
    );
  }

//
  void _processPayment() async {
    try {
      final paymentProvider =
          Provider.of<TrajetProvider>(context, listen: false);

      await paymentProvider.acheterTicket(
        trajetId: int.tryParse(
                Provider.of<TrajetProvider>(context, listen: false)
                        .selectedTrajet
                        ?.id ??
                    '') ??
            0, // Utilisez une valeur par défaut si l'ID est null ou invalide
        type: _selectedType!,
        quantity: _quantity,
        passengers:
            _clientControllers.map((controller) => controller.text).toList(),
        methodePaiement: _selectedPaymentMethod!,
        dateDepart:
            Provider.of<TrajetProvider>(context, listen: false).selectedDate!,
        heureDepart:
            Provider.of<TrajetProvider>(context, listen: false).selectedTime!,
      );

      // Affiche un message de succès et redirige vers la page /welcome
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Paiement réussi !'),
         backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacementNamed(context, '/welcome');

    } catch (e) {
      // Gestion des erreurs
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du paiement : $e')),
      );
    }
  }

//
  @override
  Widget build(BuildContext context) {
    final trajetProvider = Provider.of<TrajetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Réservation de ticket de voyage'),
        backgroundColor: Colors.blueAccent,
      ),
      body: trajetProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        DropdownButton<Trajet>(
                          value: trajetProvider.selectedTrajet,
                          hint: Text('Sélectionner un trajet'),
                          onChanged: (Trajet? newValue) {
                            setState(() {
                              trajetProvider.setSelectedTrajet(newValue!);
                              trajetProvider.setSelectedDate(null);
                              trajetProvider.setSelectedTime(null);
                              _calculatePrice(trajetProvider);
                            });
                          },
                          items: trajetProvider.trajets
                              .map<DropdownMenuItem<Trajet>>((Trajet trajet) {
                            return DropdownMenuItem<Trajet>(
                              value: trajet,
                              child: Text(trajet.nom),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        if (trajetProvider.selectedTrajet != null) ...[
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButton<String>(
                                  value: trajetProvider.selectedDate,
                                  hint: Text('Sélectionner une date'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      trajetProvider.setSelectedDate(newValue);
                                    });
                                  },
                                  items: trajetProvider.availableDates
                                      .map<DropdownMenuItem<String>>(
                                          (DateDepart dateDepart) {
                                    return DropdownMenuItem<String>(
                                      value: dateDepart.dateDepart,
                                      child: Text(dateDepart.dateDepart),
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: trajetProvider.selectedTime,
                                  hint: Text('Sélectionner une heure'),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      trajetProvider.setSelectedTime(newValue);
                                    });
                                  },
                                  items: trajetProvider.availableTimes
                                      .map<DropdownMenuItem<String>>(
                                          (HeureDepart heureDepart) {
                                    return DropdownMenuItem<String>(
                                      value: heureDepart.heureDepart,
                                      child: Text(heureDepart.heureDepart),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                        ],
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButton<String>(
                                value: _selectedType,
                                hint: Text('Sélectionner un type de billet'),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedType = newValue;
                                  });
                                  _calculatePrice(trajetProvider);
                                },
                                items: <String>[
                                  'aller_simple',
                                  'aller_retour'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_quantity > 1) {
                                          _quantity--;
                                          _updateClientControllers();
                                        }
                                      });
                                      _calculatePrice(trajetProvider);
                                    },
                                  ),
                                  Text('$_quantity'),
                                  IconButton(
                                    icon: Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _quantity++;
                                        _updateClientControllers();
                                      });
                                      _calculatePrice(trajetProvider);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        ...List.generate(_quantity - 1, (index) {
                          return TextField(
                            controller: _clientControllers[index],
                            decoration: InputDecoration(
                              labelText:
                                  'Nom du client additionnel ${index + 1}',
                            ),
                          );
                        }),
                        SizedBox(height: 20),
                        Text(
                          'Prix total: $_totalPrice',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        DropdownButton<String>(
                          value: _selectedPaymentMethod,
                          hint: Text('Sélectionner un mode de paiement'),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedPaymentMethod = newValue;
                            });
                          },
                          items: <String>[
                            'espece',
                            'carte',
                            'mobile',
                            'en_ligne'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () =>
                              _validateAndProceed(authProvider, trajetProvider),
                          child: Text('Continuer'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
