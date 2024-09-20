// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _identifierController = TextEditingController();
//   final _passwordController = TextEditingController();

//   String? _identifierError;
//   String? _passwordError;

//   @override
//   void dispose() {
//     _identifierController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         await Provider.of<AuthProvider>(context, listen: false).login(
//           _identifierController.text,
//           _passwordController.text,
//         );
//         Navigator.pushNamed(context, '/welcome');
//       } catch (e) {
//         setState(() {
//           if (e.toString().contains('Invalid login details')) {
//             _identifierError = 'Identifiant ou mot de passe incorrect';
//             _passwordError = null;
//           } else {
//             _identifierError = null;
//             _passwordError = 'Erreur de connexion';
//           }
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur lors de la connexion: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 20),
//               Center(
//                 child: Image.asset(
//                   // 'assets/logo.jpg',
//                   'assets/background.jfif',
//                   //'assets/logo.jpg', // Assurez-vous d'avoir un logo dans ce chemin
//                   height: 100,
//                 ),
//               ),
//               SizedBox(height: 40),
//               // Text(
//               //   'Se Connecter',
//               //   style: TextStyle(
//               //     fontSize: 24,
//               //     fontWeight: FontWeight.bold,
//               //     color: Colors.blueAccent,
//               //   ),
//               // ),
//               SizedBox(height: 20),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     TextFormField(
//                       controller: _identifierController,
//                       decoration: InputDecoration(
//                         labelText: 'Email ou Téléphone',
//                         prefixIcon: Icon(Icons.person),
//                         errorText: _identifierError,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Ce champ est requis';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 16.0),
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         labelText: 'Mot de passe',
//                         prefixIcon: Icon(Icons.lock),
//                         errorText: _passwordError,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Ce champ est requis';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20.0),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/resetPassword');
//                         },
//                         child: Text(
//                           'Mot de passe oublié?',
//                           style: TextStyle(color: Colors.blueAccent),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                         backgroundColor: Colors.orangeAccent,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Se Connecter',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/register');
//                         },
//                         child: Text(
//                           'Pas encore de compte? Inscrivez-vous',
//                           style: TextStyle(color: Colors.blueAccent),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// 19/09/24
// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _identifierController = TextEditingController();
//   final _passwordController = TextEditingController();
//   String selectedOption = 'email'; // Par défaut : email
//   String initialCountry = 'SN';
//   PhoneNumber number = PhoneNumber(isoCode: 'SN');
//   String? _identifierError;
//   String? _passwordError;

//   @override
//   void dispose() {
//     _identifierController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _login() async {
//     if (_formKey.currentState?.validate() ?? false) {
//       try {
//         // Valider et envoyer les données en fonction de l'option choisie
//         await Provider.of<AuthProvider>(context, listen: false).login(
//           _identifierController.text,
//           _passwordController.text,
//         );
//         Navigator.pushNamed(context, '/welcome');
//       } catch (e) {
//         setState(() {
//           if (e.toString().contains('Invalid login details')) {
//             _identifierError = 'Identifiant ou mot de passe incorrect';
//             _passwordError = null;
//           } else {
//             _identifierError = null;
//             _passwordError = 'Erreur de connexion';
//           }
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Erreur lors de la connexion: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.blueAccent,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: <Widget>[
//               SizedBox(height: 20),
//               Text(
//                 'Se connecter à votre compte',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               SizedBox(height: 40),

//               // Choix du type de connexion : Email ou Téléphone
//               DropdownButton<String>(
//                 value: selectedOption,
//                 items: [
//                   DropdownMenuItem(
//                     child: Text('Connexion par email'),
//                     value: 'email',
//                   ),
//                   DropdownMenuItem(
//                     child: Text('Connexion par téléphone'),
//                     value: 'phone',
//                   ),
//                 ],
//                 onChanged: (String? value) {
//                   setState(() {
//                     selectedOption = value ?? 'email';
//                     _identifierController.clear(); // Réinitialiser le champ
//                   });
//                 },
//               ),

//               SizedBox(height: 20),
//               Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     // Connexion par téléphone
//                     if (selectedOption == 'phone')
//                       InternationalPhoneNumberInput(
//                         onInputChanged: (PhoneNumber number) {
//                           print(number.phoneNumber);
//                         },
//                         onInputValidated: (bool isValid) {
//                           print(isValid ? 'Numéro valide' : 'Numéro invalide');
//                         },
//                         selectorConfig: SelectorConfig(
//                           selectorType: PhoneInputSelectorType.DROPDOWN,
//                           useEmoji: true,
//                         ),
//                         initialValue: number,
//                         textFieldController: _identifierController,
//                         inputDecoration: InputDecoration(
//                           labelText: 'Téléphone',
//                           prefixIcon: Icon(Icons.phone),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         countries: ['SN', 'GN', 'FR', 'US'], // Liste de pays
//                         validator: (value) {
//                           if (value == null || value.length < 7) {
//                             return 'Le numéro doit contenir au moins 7 chiffres après l\'indicatif';
//                           }
//                           return null;
//                         },
//                         formatInput: false,
//                       ),

//                     // Connexion par email
//                     if (selectedOption == 'email')
//                       TextFormField(
//                         controller: _identifierController,
//                         decoration: InputDecoration(
//                           labelText: 'Email',
//                           prefixIcon: Icon(Icons.email),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Ce champ est requis';
//                           }
//                           if (!value.contains('@')) {
//                             _identifierController.text = value + '@gmail.com';
//                           }
//                           return null;
//                         },
//                       ),

//                     SizedBox(height: 16.0),

//                     // Champ mot de passe
//                     TextFormField(
//                       controller: _passwordController,
//                       decoration: InputDecoration(
//                         labelText: 'Mot de passe',
//                         prefixIcon: Icon(Icons.lock),
//                         errorText: _passwordError,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       obscureText: true,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Ce champ est requis';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20.0),

//                     // Lien "Mot de passe oublié"
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/resetPassword');
//                         },
//                         child: Text(
//                           'Mot de passe oublié?',
//                           style: TextStyle(color: Colors.blueAccent),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     // Bouton de connexion (couleur bleue)
//                     ElevatedButton(
//                       onPressed: _login,
//                       style: ElevatedButton.styleFrom(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 15),
//                         backgroundColor:
//                             Colors.blue, // Changer la couleur en bleu
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                       child: Center(
//                         child: Text(
//                           'Se Connecter',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     // Lien pour créer un compte
//                     Center(
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, '/register');
//                         },
//                         child: Text(
//                           'Pas encore de compte? Inscrivez-vous',
//                           style: TextStyle(color: Colors.blueAccent),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// 2eme
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true; // État pour gérer l'affichage du mot de passe
  String selectedOption = 'email'; // Par défaut : email
  String initialCountry = 'SN';
  PhoneNumber number = PhoneNumber(isoCode: 'SN');
  String? _identifierError;
  String? _passwordError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode pour masquer/afficher le mot de passe
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }
void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        String identifier;

        if (selectedOption == 'phone') {
          // Combinez l'indicatif avec le numéro entré
          identifier = number.dialCode! + _identifierController.text;
        } else {
          // Email
          identifier = _identifierController.text.contains('@')
              ? _identifierController.text
              : _identifierController.text + '@gmail.com';
        }

        print(
            'Tentative de connexion avec : $identifier et mot de passe : ${_passwordController.text}');

        await Provider.of<AuthProvider>(context, listen: false).login(
          identifier,
          _passwordController.text,
        );
        Navigator.pushNamed(context, '/welcome');
      } catch (e) {
        setState(() {
          if (e.toString().contains('Invalid login details')) {
            _identifierError = 'Identifiant ou mot de passe incorrect';
            _passwordError = null;
          } else {
            _identifierError = null;
            _passwordError = 'Erreur de connexion';
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la connexion: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Se connecter à votre compte',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 40),

              // Choix du type de connexion : Email ou Téléphone
              DropdownButton<String>(
                value: selectedOption,
                items: [
                  DropdownMenuItem(
                    child: Text('Connexion par email'),
                    value: 'email',
                  ),
                  DropdownMenuItem(
                    child: Text('Connexion par téléphone'),
                    value: 'phone',
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    selectedOption = value ?? 'email';
                    _identifierController.clear(); // Réinitialiser le champ
                  });
                },
              ),

              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Connexion par téléphone
                    if (selectedOption == 'phone')
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          this.number = number;
                        },
                        onInputValidated: (bool isValid) {
                          print(isValid ? 'Numéro valide' : 'Numéro invalide');
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                          useEmoji: true,
                        ),
                        initialValue: number,
                        textFieldController: _identifierController,
                        inputDecoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        countries: ['SN', 'GN', 'FR', 'US'], // Liste de pays
                        validator: (value) {
                          if (value == null || value.length < 7) {
                            return 'Le numéro doit contenir au moins 7 chiffres après l\'indicatif';
                          }
                          return null;
                        },
                        formatInput: false,
                      ),

                    // Connexion par email
                    if (selectedOption == 'email')
                      TextFormField(
                        controller: _identifierController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est requis';
                          }
                          if (!value.contains('@')) {
                            _identifierController.text = value + '@gmail.com';
                          }
                          return null;
                        },
                      ),

                    SizedBox(height: 16.0),

                    // Champ mot de passe avec option d'affichage/masquage
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        errorText: _passwordError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      obscureText:
                          _obscurePassword, // Masquer ou afficher le texte
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ce champ est requis';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),

                    // Lien "Mot de passe oublié"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/resetPassword');
                        },
                        child: Text(
                          'Mot de passe oublié?',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Bouton de connexion (couleur bleue)
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor:
                            Colors.blue, // Changer la couleur en bleu
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Lien pour créer un compte
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          'Pas encore de compte? Inscrivez-vous',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
