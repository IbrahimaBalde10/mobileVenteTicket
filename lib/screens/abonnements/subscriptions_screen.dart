import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/typeAbonnement_provider.dart';
import '../../providers/auth_provider.dart';

class SubscriptionsScreen extends StatefulWidget {
  @override
  _SubscriptionsScreenState createState() => _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends State<SubscriptionsScreen> {
  String? selectedSubscriptionTypeId;
  double? subscriptionPrice;
  bool isVendor = false;

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

    // Determine if the user is a vendor
    isVendor = authProvider.user?.role == 'Vendeur';

    Provider.of<TypeAbonnementProvider>(context, listen: false)
        .fetchTypesAbonnements();
    Provider.of<TypeAbonnementProvider>(context, listen: false)
        .fetchSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: isVendor ? 2 : 3, // Adjust tab length based on role
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestion des abonnements'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Types d\'abonnements'),
              if (!isVendor) Tab(text: 'Mon abonnement'),
              if (isVendor) Tab(text: 'Vendre un abonnement'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet 1: Liste des types d'abonnement
            Consumer<TypeAbonnementProvider>(
              builder: (context, typeAbonnementProvider, child) {
                if (typeAbonnementProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (typeAbonnementProvider.errorMessage != null) {
                  return Center(
                      child: Text(typeAbonnementProvider.errorMessage!));
                } else if (typeAbonnementProvider.typeAbonnements.isEmpty) {
                  return Center(
                      child: Text('Aucun type d\'abonnement disponible.'));
                } else {
                  return ListView.builder(
                    itemCount: typeAbonnementProvider.typeAbonnements.length,
                    itemBuilder: (context, index) {
                      final typeAbonnement =
                          typeAbonnementProvider.typeAbonnements[index];
                      return ListTile(
                        title: Text('Nom: ${typeAbonnement.name}'),
                        trailing: Icon(Icons.more_vert),
                        onTap: () {
                          selectedSubscriptionTypeId = typeAbonnement.id;
                          subscriptionPrice = typeAbonnement.price;
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Nom: ${typeAbonnement.name}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Prix: ${typeAbonnement.price} CFA'),
                                    Text(
                                        'Description: ${typeAbonnement.description ?? 'Non spécifiée'}'),
                                    Text(
                                        'Statut: ${typeAbonnement.statut ?? 'Non spécifié'}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Fermer'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final authProvider =
                                          Provider.of<AuthProvider>(context,
                                              listen: false);
                                      Navigator.pushNamed(
                                        context,
                                        '/choixpaiementAbonnement',
                                        arguments: {
                                          'user_id': authProvider.user?.id,
                                          'subscription_type_id':
                                              selectedSubscriptionTypeId,
                                          'price': subscriptionPrice,
                                        },
                                      );
                                    },
                                    child: Text('Souscrire'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),

            // Onglet 2: Statut de l'abonnement (only for non-vendors)
            if (!isVendor)
              Consumer<TypeAbonnementProvider>(
                builder: (context, subscriptionProvider, child) {
                  if (subscriptionProvider.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (subscriptionProvider.errorMessage != null) {
                    return Center(
                        child: Text(subscriptionProvider.errorMessage!));
                  } else if (subscriptionProvider.status.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Vous n\'avez jamais eu d\'abonnement.'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/acheterAbo');
                            },
                            child: Text('Souscrire un abonnement'),
                          ),
                        ],
                      ),
                    );
                  } else if (subscriptionProvider.status == 'expire') {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Votre abonnement a expiré le: ${subscriptionProvider.endDate}'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/acheterAbo');
                            },
                            child: Text('Souscrire un abonnement'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Votre abonnement est: ${subscriptionProvider.status}'),
                          Text('Expire le: ${subscriptionProvider.endDate}'),
                          Text('Code QR: ${subscriptionProvider.qrCode}'),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Détails de votre abonnement'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            'Nom de type d\'abonnement: ${subscriptionProvider.nomType}'),
                                        Text(
                                            'Expire le: ${subscriptionProvider.endDate}'),
                                        Text(
                                            'Statut: ${subscriptionProvider.status}'),
                                        if (subscriptionProvider.qr_code !=
                                                null &&
                                            subscriptionProvider
                                                .qr_code!.isNotEmpty)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('QR Code:'),
                                              SizedBox(height: 10),
                                              SvgPicture.memory(
                                                base64Decode(
                                                    subscriptionProvider
                                                        .qr_code!),
                                                height: 150,
                                                width: 150,
                                                fit: BoxFit.cover,
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Fermer'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Voir les détails de l\'abonnement'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

            // Onglet 3: Vendre un abonnement (only for vendors)
            if (isVendor)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Logic to verify subscription using phone number
                      Navigator.pushNamed(context, '/verifySubscription');
                    },
                    child: Text('Vérifier l\'abonnement par numéro'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Logic to subscribe a new user
                      Navigator.pushNamed(context, '/vendreAbo');
                    },
                    child: Text('Abonner utilisateur'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
