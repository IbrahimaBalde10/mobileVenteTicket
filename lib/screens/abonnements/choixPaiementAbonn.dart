import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/trajet_provider.dart';

class ChoixpaiementAbonnement extends StatefulWidget {
  @override
  _ChoixpaiementAbonnementState createState() =>
      _ChoixpaiementAbonnementState();
}

class _ChoixpaiementAbonnementState extends State<ChoixpaiementAbonnement> {
  String? _selectedPaymentMethod;
  String? _selectedType;
  int _quantity = 1;
  double _price = 0.0;
  List<TextEditingController> _clientControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _selectedType = args['subscription_type_id']; // ID du type d'abonnement
      _quantity = args['quantity'] ?? 1; // Quantité, si applicable
      _price = args['price'] ?? 0.0; // Prix de l'abonnement
      _selectedPaymentMethod =
          args['payment_method']; // Méthode de paiement si fournie
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    _updateClientControllers(authProvider.user?.nom);
  }

  void _updateClientControllers(String? userName) {
    setState(() {
      _clientControllers.clear();
      for (int i = 0; i < _quantity; i++) {
        _clientControllers.add(TextEditingController(
          text: i == 0 && _quantity == 1 ? userName : '',
        ));
      }
    });
  }

  void _logPaymentDetails(
      AuthProvider authProvider, TrajetProvider trajetProvider) {
    print('--- Purchase and Payment Details ---');
    print('Payment Method: $_selectedPaymentMethod');
    print('Trajet ID: ${trajetProvider.selectedTrajet?.id}');
    print('Trajet Name: ${trajetProvider.selectedTrajet?.nom}');
    print('Client Principal: ${authProvider.user?.nom}');
    print('Telephone: ${authProvider.user?.telephone}');

    if (_quantity > 1) {
      for (int i = 1; i < _quantity; i++) {
        print('Client additionnel $i: ${_clientControllers[i].text}');
      }
    }

    print('Type: $_selectedType');
    print('Quantity: $_quantity');
    print('Selected Date: ${trajetProvider.selectedDate}');
    print('Selected Time: ${trajetProvider.selectedTime}');
    print('Total Price: ${trajetProvider.totalPrice}');
    print('Unit Price:  ${trajetProvider.selectedTrajet?.prix}');
    print('User ID: ${authProvider.user?.id}');
  }

  @override
  Widget build(BuildContext context) {
    final trajetProvider = Provider.of<TrajetProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Choix du paiement'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButton<String>(
                value: _selectedPaymentMethod,
                hint: Text('Sélectionner un mode de paiement'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue;
                  });
                },
                items: <String>['espece', 'carte', 'mobile', 'en_ligne']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              if (_selectedPaymentMethod != null) ...[
                Text(
                  'Détails de l\'achat',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      Text('Client Principal',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${authProvider.user?.nom}'),
                    ]),
                    TableRow(children: [
                      Text('ID Utilisateur',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${authProvider.user?.id}'),
                    ]),
                    TableRow(children: [
                      Text('ID Type d\'Abonnement',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_selectedType}'),
                    ]),
                    TableRow(children: [
                      Text('Prix Unitaire',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_price} CFA'),
                    ]),
                    TableRow(children: [
                      Text('Quantité',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_quantity}'),
                    ]),
                    TableRow(children: [
                      Text('Prix Total',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(_price * _quantity).toStringAsFixed(0)} CFA'),
                    ]),
                    TableRow(children: [
                      Text('Methode de Paiement',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('$_selectedPaymentMethod'),
                    ]),
                  ],
                ),
                SizedBox(height: 20),
                if (_quantity > 1) ...[
                  Text(
                    'Clients additionnels',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Table(
                    border: TableBorder.all(),
                    children: List.generate(_quantity - 1, (index) {
                      return TableRow(children: [
                        Text('Client additionnel ${index + 1}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_clientControllers[index + 1].text),
                      ]);
                    }),
                  ),
                  SizedBox(height: 20),
                ],
              ],
              ElevatedButton(
                onPressed: _selectedPaymentMethod == null
                    ? null
                    : () {
                        _logPaymentDetails(authProvider, trajetProvider);
                        Navigator.pushNamed(context, '/confirmation');
                      },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: const Color.fromARGB(255, 64, 185, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Confirmer l’achat'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/abonnements');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Color.fromARGB(255, 255, 64, 64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Annuler'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
