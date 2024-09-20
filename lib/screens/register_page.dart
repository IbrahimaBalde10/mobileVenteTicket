import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterPage extends StatelessWidget {
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
                'Créer un compte',
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
                validator: (value) {
                  if (value == null || value.length < 7) {
                    return 'Le numéro doit contenir au moins 7 chiffres après l\'indicatif';
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

              // Bouton S'inscrire
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
                    'S\'Inscrire',
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
