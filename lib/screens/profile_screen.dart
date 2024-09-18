import 'package:flutter/material.dart';
import 'package:mobie_app/screens/welcome_page.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login_page.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserProfile().catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${error.toString()}'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    //  final authProvider = Provider.of<AuthProvider>(context);

    // Vérification si l'utilisateur est authentifié
    if (!authProvider.isAuthenticated) {
      // Rediriger vers la page de connexion s'il n'est pas authentifié
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
      return Scaffold(); // Retourne une page vide temporaire
    }

    final User? user = userProvider.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Profil'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final nomController = TextEditingController(text: user.nom);
    final prenomController = TextEditingController(text: user.prenom);
    final emailController = TextEditingController(text: user.email);
    final telephoneController = TextEditingController(text: user.telephone);
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Informations de ${authProvider.user?.nom} ${authProvider.user?.prenom}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture with Edit Button
            CircleAvatar(
              radius: 50,
              backgroundImage: user.profilePhoto != null
                  ? NetworkImage(user.profilePhoto!)
                  : AssetImage('assets/background.jfif') as ImageProvider,
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                // Action pour modifier la photo de profil
              },
              icon: Icon(Icons.edit),
              label: Text('Modifier la photo'),
            ),
            SizedBox(height: 20),

            // Formulaire de profil
            Form(
              key: _formKey,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre nom';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: prenomController,
                        decoration: InputDecoration(
                          labelText: 'Prénom',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre prénom';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: telephoneController,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre téléphone';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      // Mot de passe
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        style: TextStyle(
                            color: Colors
                                .black), // This ensures the password is in black dots
                      ),
                      SizedBox(height: 20),
                     
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            userProvider
                                .updateUserProfile(
                              context, // Passer le contexte ici
                              // nomController.text,
                              // prenomController.text,
                              // emailController.text,
                              // telephoneController.text,
                              // passwordController.text,
                               nomController.text.isNotEmpty
                                  ? nomController.text
                                  : '',
                              prenomController.text.isNotEmpty
                                  ? prenomController.text
                                  : '',
                              emailController.text.isNotEmpty
                                  ? emailController.text
                                  : '',
                              telephoneController.text.isNotEmpty
                                  ? telephoneController.text
                                  : '',
                              // passwordController.text.isNotEmpty
                              //     ? passwordController.text
                              //     : '',
                            )
                                .then((_) {
                              // Afficher un message de succès
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Profil mis à jour avec succès!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // Rediriger vers une autre page si nécessaire
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           WelcomePage()), // Ou la page de destination
                              // );
                              Navigator.pushNamed(context, '/welcome');
                            }).catchError((error) {
                              // Afficher un message d'erreur
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Erreur lors de la mise à jour: ${error.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            });
                          }
                        },
                        child: Text('Mettre à jour'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

