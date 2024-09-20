// import 'package:flutter/material.dart';
// import 'package:mobie_app/models/typeAbonnement.dart';
// import 'package:provider/provider.dart';
// import '../../providers/typeAbonnement_provider.dart';
// import '../../providers/auth_provider.dart';

// class VendreAboPage extends StatefulWidget {
//   @override
//   _VendreAboPageState createState() => _VendreAboPageState();
// }

// class _VendreAboPageState extends State<VendreAboPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _telephoneController = TextEditingController();
//   int? _selectedAbonnementId;
//   bool _showPaymentOptions = false;
//   String? _selectedPaymentMethod;

//   @override
//   void initState() {
//     super.initState();
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);

//     if (!authProvider.isAuthenticated) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacementNamed(context, '/login');
//       });
//       return;
//     }

//     Provider.of<TypeAbonnementProvider>(context, listen: false)
//         .fetchTypesAbonnements();
//   }

//   void _showSummaryDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Récapitulatif de la commande'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: [
//                 Text('Téléphone : ${_telephoneController.text}'),
//                 Text(
//                     'Abonnement : ${_selectedAbonnementId != null ? Provider.of<TypeAbonnementProvider>(context, listen: false).typeAbonnements.firstWhere((abonnement) => int.tryParse(abonnement.id) == _selectedAbonnementId).name : 'Non sélectionné'}'),
//                 Text(
//                     'Méthode de paiement : ${_selectedPaymentMethod ?? 'Non sélectionnée'}'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Annuler'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Confirmer'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _processPayment();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _processPayment() async {
//     if (_formKey.currentState!.validate()) {
//       final telephone = _telephoneController.text;
//       final abonnementId = _selectedAbonnementId;

//       final abonnementProvider =
//           Provider.of<TypeAbonnementProvider>(context, listen: false);

//       await abonnementProvider.vendreAbonnement(
//         telephone: telephone,
//         subscriptionTypeId: abonnementId!,
//         methodePaiement: _selectedPaymentMethod!,
//       );

//       if (abonnementProvider.errorMessage != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(abonnementProvider.errorMessage!)),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Abonnement vendu avec succès!'),
//               backgroundColor: Colors.green),
//         );
//         Navigator.pushNamed(context, '/welcome');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final typeAbonnementProvider = Provider.of<TypeAbonnementProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Gestion de vente des Abonnements'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextFormField(
//                 controller: _telephoneController,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(
//                   labelText: 'Numéro de téléphone du client',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Veuillez entrer un numéro de téléphone';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               DropdownButtonFormField<int>(
//                 decoration: InputDecoration(
//                   labelText: 'Sélectionner un type d\'abonnement',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                 ),
//                 value: _selectedAbonnementId,
//                 onChanged: (int? newValue) {
//                   setState(() {
//                     _selectedAbonnementId = newValue;
//                   });
//                 },
//                 items: typeAbonnementProvider.typeAbonnements
//                     .map<DropdownMenuItem<int>>((TypeAbonnement abonnement) {
//                   return DropdownMenuItem<int>(
//                     value: int.tryParse(abonnement.id),
//                     child: Text(abonnement.name),
//                   );
//                 }).toList(),
//                 validator: (value) {
//                   if (value == null) {
//                     return 'Veuillez sélectionner un type d\'abonnement';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               if (_showPaymentOptions) ...[
//                 Text('Méthode de paiement'),
//                 DropdownButtonFormField<String>(
//                   decoration: InputDecoration(
//                     labelText: 'Sélectionner une méthode de paiement',
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10)),
//                     filled: true,
//                     fillColor: Colors.grey[200],
//                   ),
//                   value: _selectedPaymentMethod,
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedPaymentMethod = newValue;
//                     });
//                   },
//                   items: ['espece', 'carte', 'mobile', 'en_ligne']
//                       .map<DropdownMenuItem<String>>((String method) {
//                     return DropdownMenuItem<String>(
//                       value: method,
//                       child: Text(method),
//                     );
//                   }).toList(),
//                   validator: (value) {
//                     if (value == null) {
//                       return 'Veuillez sélectionner une méthode de paiement';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//               ],
//               ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     if (_showPaymentOptions) {
//                       _showSummaryDialog();
//                     } else {
//                       setState(() {
//                         _showPaymentOptions = true;
//                       });
//                     }
//                   }
//                 },
//                 child: Text(_showPaymentOptions ? 'Confirmer' : 'Continuer'),
//                 style: ElevatedButton.styleFrom(
//                   // primary: Colors.blueAccent,
//                   backgroundColor: Colors.blueAccent,
//                   padding: EdgeInsets.symmetric(vertical: 12.0),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//               if (typeAbonnementProvider.isLoading) ...[
//                 SizedBox(height: 20),
//                 Center(child: CircularProgressIndicator()),
//               ],
//               if (typeAbonnementProvider.errorMessage != null) ...[
//                 SizedBox(height: 20),
//                 Text(
//                   typeAbonnementProvider.errorMessage!,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _telephoneController.dispose();
//     super.dispose();
//   }
// }

// 2em
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class VendreAboPage extends StatelessWidget {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String initialCountry = 'SN'; // Pays par défaut Sénégal
  PhoneNumber number = PhoneNumber(isoCode: 'SN'); // Indicatif par défaut

  String? completePhoneNumber; // Pour stocker le numéro complet
  String? countryCode; // Pour stocker l'indicatif du pays

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Vendre un Abonnement',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 30),

              // Champs Nom et Prénom
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nomController,
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _prenomController,
                      decoration: InputDecoration(
                        labelText: 'Prénom',
                        prefixIcon: Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Champ téléphone avec indicatif
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  completePhoneNumber = number.phoneNumber; // Numéro complet
                  countryCode = number.isoCode; // Indicatif pays
                  print('Numéro complet: $completePhoneNumber');
                  print('Indicatif du pays: $countryCode');
                },
                onInputValidated: (bool isValid) {
                  print(isValid ? 'Numéro valide' : 'Numéro invalide');
                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DROPDOWN,
                  useEmoji: true,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: _telephoneController,
                inputDecoration: InputDecoration(
                  labelText: 'Téléphone',
                  hintText: 'Entrez votre numéro',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                countries: ['SN', 'GN', 'FR', 'US'],
                validator: (PhoneNumber? value) {
                  if (value == null ||
                      value.phoneNumber == null ||
                      value.phoneNumber!.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone valide';
                  }
                  return null;
                },
                formatInput: false, // Désactiver le formatage auto
              ),
              SizedBox(height: 16),

              // Champ email
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Champ mot de passe
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              // Bouton Vendre
              ElevatedButton(
                onPressed: () async {
                  if (_nomController.text.isEmpty ||
                      _prenomController.text.isEmpty ||
                      _telephoneController.text.isEmpty ||
                      _emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Tous les champs sont obligatoires')),
                    );
                    return;
                  }

                  // Appel de la méthode d'enregistrement
                  try {
                    await authProvider.register(
                      _nomController.text,
                      _prenomController.text,
                      completePhoneNumber ?? '',
                      _emailController.text,
                      _passwordController.text,
                    );
                    Navigator.pushReplacementNamed(context, '/welcome');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur : $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Vendre',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Lien pour se connecter
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text(
                    'Vous avez déjà un compte ? Connectez-vous',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
