import 'package:flutter/material.dart';
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
  List<TextEditingController> _clientControllers = [];

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Redirect to login if not authenticated
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    // Fetch available trajets
    Provider.of<TrajetProvider>(context, listen: false).fetchTrajets();

    // Initialize client controllers
    _updateClientControllers();
  }

  // Update the client controllers based on the quantity
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

  void _logPurchaseDetails(
      AuthProvider authProvider, TrajetProvider trajetProvider) {
    print('--- Purchase Details ---');
    print('Trajet ID: ${trajetProvider.selectedTrajet?.id}');
    print('Trajet Name: ${trajetProvider.selectedTrajet?.nom}');
    print('Client Principal: ${authProvider.user?.nom}');
    print('Telephone: ${authProvider.user?.telephone}');

    if (_quantity > 1) {
      for (int i = 1; i < _quantity; i++) {
        print('Client additionnel $i: ${_clientControllers[i - 1].text}');
      }
    }

    print('Selected Date: ${trajetProvider.selectedDate}');
    print('Selected Time: ${trajetProvider.selectedTime}');
    print('Type: $_selectedType');
    print('Quantity: $_quantity');
    print('Total Price: $_totalPrice');
    print('Unit Price: ${trajetProvider.selectedTrajet?.prix}');
    print('User ID: ${authProvider.user?.id}');
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

    // If everything is valid, proceed to the next page
    _logPurchaseDetails(authProvider, trajetProvider);
    Navigator.pushNamed(
      context,
      '/choixpaiement',
      arguments: {
        'type': _selectedType,
        'quantity': _quantity,
      },
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

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
                        // Dropdown to select a trajet
                        DropdownButton<Trajet>(
                          value: trajetProvider.selectedTrajet,
                          hint: Text('Sélectionner un trajet'),
                          onChanged: (Trajet? newValue) {
                            setState(() {
                              trajetProvider.setSelectedTrajet(newValue!);
                              trajetProvider
                                  .setSelectedDate(null); // Reset date
                              trajetProvider
                                  .setSelectedTime(null); // Reset time
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

                        // Row to display date and time selectors
                        if (trajetProvider.selectedTrajet != null) ...[
                          Row(
                            children: [
                              // Date Dropdown
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
                              // Time Dropdown
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

                        // Row to display quantity and type on a single line
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

                        // Fields to enter additional client names (no principal client field)
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

                        // Total price
                        Text(
                          'Prix total: $_totalPrice',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),

                        // Continue button
                        ElevatedButton(
                          onPressed: () {
                            _validateAndProceed(authProvider, trajetProvider);
                          },
                          child: Text('Continuer l\'achat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            // primary: Colors.red,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Annuler l'achat
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Annuler'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            // primary: Colors.red,
                          ),
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
