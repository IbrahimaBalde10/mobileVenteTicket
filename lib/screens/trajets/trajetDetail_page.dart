// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/trajet_provider.dart';
// import '../../models/trajet.dart';

// class TrajetDetailPage extends StatelessWidget {
//   final int trajetId;

//   TrajetDetailPage({required this.trajetId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Détails du Trajet ${trajetId}')),
//       body: FutureBuilder<Trajet>(
//         future: Provider.of<TrajetProvider>(context, listen: false)
//             .fetchTrajetById(trajetId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Erreur: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('Aucun détail trouvé pour ce trajet.'));
//           }

//           final trajet = snapshot.data!;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Nom: ${trajet.nom}', style: TextStyle(fontSize: 20)),
//                 Text('Départ: ${trajet.pointDepart}',
//                     style: TextStyle(fontSize: 16)),
//                 Text('Arrivée: ${trajet.pointArrivee}',
//                     style: TextStyle(fontSize: 16)),
//                 Text('Prix: ${trajet.prix} CFA',
//                     style: TextStyle(fontSize: 16)),
//                 Text(
//                     'Description: ${trajet.description ?? "Aucune description"}',
//                     style: TextStyle(fontSize: 16)),
//                   Icon(
//                   trajet.statut == 'actif' ? Icons.check_circle : Icons.cancel,
//                   color: trajet.statut == 'actif' ? Colors.green : Colors.red,
//                   size: 30.0,
//                 ),
//                 SizedBox(height: 20),
//                 Text('Dates de Départ:',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ...trajet.datesDeDepart?.map((dateDepart) => Text(
//                         dateDepart.dateDepart,
//                         style: TextStyle(fontSize: 16))) ??
//                     [Text('Aucune date de départ')],
//                 SizedBox(height: 20),
//                 Text('Heures de Départ:',
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 ...trajet.heuresDeDepart?.map((heureDepart) => Text(
//                         heureDepart.heureDepart,
//                         style: TextStyle(fontSize: 16))) ??
//                     [Text('Aucune heure de départ')],
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trajet_provider.dart';
import '../../models/trajet.dart';
import '../../providers/auth_provider.dart';

class TrajetDetailPage extends StatelessWidget {
  final int trajetId;

  TrajetDetailPage({required this.trajetId});

  @override
  Widget build(BuildContext context) {
    // Vérification de l'authentification
    final isAuthenticated = Provider.of<AuthProvider>(context).isAuthenticated;

    if (!isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed('/login');
      });
      return Scaffold(
        body: Center(
            child:
                CircularProgressIndicator()), // Affichage d'un loader pendant la redirection
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du Trajet ${trajetId}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<Trajet>(
        future: Provider.of<TrajetProvider>(context, listen: false)
            .fetchTrajetById(trajetId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Aucun détail trouvé pour ce trajet.'));
          }

          final trajet = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(
                    title: 'Nom',
                    content: trajet.nom,
                  ),
                  _buildCard(
                    title: 'Départ',
                    content: trajet.pointDepart,
                  ),
                  _buildCard(
                    title: 'Arrivée',
                    content: trajet.pointArrivee,
                  ),
                  _buildCard(
                    title: 'Prix',
                    content: '${trajet.prix} CFA',
                  ),
                  _buildCard(
                    title: 'Description',
                    content: trajet.description ?? 'Aucune description',
                  ),
                  SizedBox(height: 20),
                  _buildTable(
                    title: 'Dates de Départ',
                    data: trajet.datesDeDepart
                            ?.map((date) => date.dateDepart)
                            .toList() ??
                        [],
                    noDataText: 'Aucune date de départ',
                  ),
                  SizedBox(height: 20),
                  _buildTable(
                    title: 'Heures de Départ',
                    data: trajet.heuresDeDepart
                            ?.map((heure) => heure.heureDepart)
                            .toList() ??
                        [],
                    noDataText: 'Aucune heure de départ',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blueGrey,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            content,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(
      {required String title,
      required List<String> data,
      required String noDataText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(height: 8.0),
        data.isNotEmpty
            ? Table(
                columnWidths: {
                  0: FlexColumnWidth(),
                },
                border: TableBorder.all(color: Colors.grey.shade300),
                children: data.map((item) {
                  return TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
            : Text(
                noDataText,
                style: TextStyle(fontSize: 16.0, color: Colors.grey),
              ),
      ],
    );
  }
}
