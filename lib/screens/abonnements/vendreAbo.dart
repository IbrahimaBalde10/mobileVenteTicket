import 'package:flutter/material.dart';
import 'package:mobie_app/models/typeAbonnement.dart';
import 'package:provider/provider.dart';
import '../../providers/typeAbonnement_provider.dart';
import '../../providers/auth_provider.dart';

class VendreAboPage extends StatefulWidget {
  @override
  _VendreAboPageState createState() => _VendreAboPageState();
}

class _VendreAboPageState extends State<VendreAboPage> {
  final _formKey = GlobalKey<FormState>();
  final _telephoneController = TextEditingController();
  int? _selectedAbonnementId;
  bool _showPaymentOptions = false;
  String? _selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }

    Provider.of<TypeAbonnementProvider>(context, listen: false)
        .fetchTypesAbonnements();
  }

  @override
  Widget build(BuildContext context) {
    final typeAbonnementProvider = Provider.of<TypeAbonnementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion de vente des Abonnements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _telephoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone du client',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: 'Sélectionner un type d\'abonnement',
                  border: OutlineInputBorder(),
                ),
                value: _selectedAbonnementId,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedAbonnementId = newValue;
                  });
                },
                items: typeAbonnementProvider.typeAbonnements
                    .map<DropdownMenuItem<int>>((TypeAbonnement abonnement) {
                  return DropdownMenuItem<int>(
                    value:
                        int.tryParse(abonnement.id), // Convert String id to int
                    child: Text(abonnement.name),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Veuillez sélectionner un type d\'abonnement';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_showPaymentOptions) ...[
                Text('Méthode de paiement'),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Sélectionner une méthode de paiement',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedPaymentMethod,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPaymentMethod = newValue;
                    });
                  },
                  items: ['espece', 'carte', 'mobile', 'en_ligne']
                      .map<DropdownMenuItem<String>>((String method) {
                    return DropdownMenuItem<String>(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner une méthode de paiement';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // Display summary table
                if (_selectedAbonnementId != null) ...[
                  Text('Résumé de la commande'),
                  SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Téléphone'),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(_telephoneController.text),
                          )),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Abonnement'),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(typeAbonnementProvider.typeAbonnements
                                .firstWhere((abonnement) =>
                                    int.tryParse(abonnement.id) ==
                                    _selectedAbonnementId)
                                .name),
                          )),
                        ],
                      ),
                      TableRow(
                        children: [
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Méthode de paiement'),
                          )),
                          TableCell(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                _selectedPaymentMethod ?? 'Non sélectionnée'),
                          )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ],
              // ElevatedButton(
              //   onPressed: () async {
              //     if (_formKey.currentState!.validate()) {
              //       if (_showPaymentOptions) {
              //         // Vérifier si une méthode de paiement est sélectionnée
              //         if (_selectedPaymentMethod == null) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //                 content: Text(
              //                     'Veuillez sélectionner une méthode de paiement')),
              //           );
              //           return;
              //         }

              //         // Envoyer la requête au serveur pour acheter l'abonnement
              //         final telephone = _telephoneController.text;
              //         final abonnementId = _selectedAbonnementId;

              //         if (abonnementId == null) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //                 content:
              //                     Text('Veuillez sélectionner un abonnement')),
              //           );
              //           return;
              //         }

              //         final abonnementProvider =
              //             Provider.of<TypeAbonnementProvider>(context,
              //                 listen: false);

              //         await abonnementProvider.vendreAbonnement(
              //           telephone: telephone,
              //           subscriptionTypeId: abonnementId,
              //           methodePaiement: _selectedPaymentMethod!,
              //         );

              //         // Gestion des erreurs ou succès
              //         if (abonnementProvider.errorMessage != null) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //                 content: Text(abonnementProvider.errorMessage!)),
              //           );
              //         } else {
              //             // Afficher un message de succès
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text('Abonnement vendu avec succès!'),
              //               backgroundColor: Colors.green,
              //             ),
              //           );
                  
              //           Navigator.pushNamed(context, '/welcome');
              //           // Réinitialiser l'état ou rediriger
              //         }
              //       } else {
              //         // Afficher les options de paiement
              //         setState(() {
              //           _showPaymentOptions = true;
              //         });
              //       }
              //     }
              //   },
              //   child: Text(_showPaymentOptions ? 'Payer' : 'Continuer'),
              // )
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (_showPaymentOptions) {
                      // Vérifier si une méthode de paiement est sélectionnée
                      if (_selectedPaymentMethod == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Veuillez sélectionner une méthode de paiement'),
                          ),
                        );
                        return;
                      }

                      // Envoyer la requête au serveur pour acheter l'abonnement
                      final telephone = _telephoneController.text;
                      final abonnementId = _selectedAbonnementId;

                      if (abonnementId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Veuillez sélectionner un abonnement'),
                          ),
                        );
                        return;
                      }

                      final abonnementProvider =
                          Provider.of<TypeAbonnementProvider>(context,
                              listen: false);

                      await abonnementProvider.vendreAbonnement(
                        telephone: telephone,
                        subscriptionTypeId: abonnementId,
                        methodePaiement: _selectedPaymentMethod!,
                      );

                      // Gestion des erreurs ou succès
                      if (abonnementProvider.errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(abonnementProvider.errorMessage!),
                          ),
                        );
                      } else {
                        // Afficher un message de succès
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Abonnement vendu avec succès!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Rediriger vers une autre page ou réinitialiser l'état
                        Navigator.pushNamed(context, '/welcome');
                      }
                    } else {
                      // Afficher les options de paiement
                      setState(() {
                        _showPaymentOptions = true;
                      });
                    }
                  }
                },
                child: Text(_showPaymentOptions ? 'Payer' : 'Continuer'),
              )

              ,
              if (typeAbonnementProvider.isLoading) ...[
                SizedBox(height: 20),
                Center(child: CircularProgressIndicator()),
              ],
              if (typeAbonnementProvider.errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  typeAbonnementProvider.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _telephoneController.dispose();
    super.dispose();
  }
}
