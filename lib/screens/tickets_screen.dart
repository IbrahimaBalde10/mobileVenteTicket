import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../providers/trajet_provider.dart';
import '../../providers/ticket_provider.dart';
import '../../providers/auth_provider.dart';

class TicketsScreen extends StatefulWidget {
  @override
  _TicketsScreenState createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
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

    // Déterminer si l'utilisateur est un vendeur
    isVendor = authProvider.user?.role == 'Vendeur';

    Provider.of<TrajetProvider>(context, listen: false).fetchTrajets();
    Provider.of<TicketProvider>(context, listen: false)
        .fetchSubscriptionStatus();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:
          isVendor ? 2 : 3, // Ajuster le nombre d'onglets en fonction du rôle
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gestion des Tickets'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Trajets disponibles'),
              if (!isVendor) Tab(text: 'Mon Ticket'),
              if (isVendor) Tab(text: 'Vendre un Ticket'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Onglet 1: Liste des trajets
            Consumer<TrajetProvider>(
              builder: (context, trajetProvider, child) {
                if (trajetProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (trajetProvider.errorMessage != null) {
                  return Center(child: Text(trajetProvider.errorMessage!));
                } else if (trajetProvider.trajets.isEmpty) {
                  return Center(child: Text('Aucun trajet disponible.'));
                } else {
                  return ListView.builder(
                    itemCount: trajetProvider.trajets.length,
                    itemBuilder: (context, index) {
                      final trajet = trajetProvider.trajets[index];
                      return ListTile(
                        title: Text('Trajet: ${trajet.nom}'),
                        trailing: Icon(Icons.more_vert),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Trajet: ${trajet.nom}'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        'Description: ${trajet.description ?? 'Non spécifiée'}'),
                                    Text('Prix: ${trajet.prix} CFA'),
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
                                      Navigator.pushNamed(
                                          context, '/choixpaiementTrajet',
                                          arguments: {
                                            'trajet_id': trajet.id,
                                            'price': trajet.prix,
                                          });
                                    },
                                    child: Text('Acheter Ticket'),
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

            // Onglet 2: Statut du ticket (uniquement pour les non-vendeurs)
            if (!isVendor)
              Consumer<TicketProvider>(
                builder: (context, ticketProvider, child) {
                  if (ticketProvider.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (ticketProvider.errorMessage != null) {
                    return Center(child: Text(ticketProvider.errorMessage!));
                  } else if (ticketProvider.status.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Vous n\'avez pas encore de ticket.'),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/achatTicket');
                            },
                            child: Text('Acheter un ticket'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${ticketProvider.nomClient}'),
                          Text('Votre ticket est: ${ticketProvider.status}'),
                          Text(
                              'Date d\'expiration: ${ticketProvider.expirationDate}'),
                          SizedBox(height: 20),
                          if (ticketProvider.qrCode != null &&
                              ticketProvider.qrCode!.isNotEmpty)
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Détails du Ticket'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                              'Hello: ${ticketProvider.nomClient}'),
                                          Text(
                                              'Statut: ${ticketProvider.status}'),
                                          Text(
                                              'Date d\'expiration: ${ticketProvider.expirationDate}'),
                                          SizedBox(height: 10),
                                          Text('QR Code:'),
                                          SizedBox(height: 10),
                                          SvgPicture.memory(
                                            base64Decode(
                                                ticketProvider.qrCode!),
                                            height: 160,
                                            width: 160,
                                            fit: BoxFit.cover,
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
                              child: Text('Afficher les détails du ticket'),
                            ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/achatTicket');
                            },
                            child: Text('Acheter un ticket'),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),

            // Onglet 3: Vendre un ticket (uniquement pour les vendeurs)
            if (isVendor)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/verifyTicket');
                    },
                    child: Text('Vérifier le ticket par numéro'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/vendreTicket');
                    },
                    child: Text('Vendre un Ticket'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
