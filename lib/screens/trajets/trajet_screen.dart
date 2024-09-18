import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/trajet_provider.dart';
import '../../providers/auth_provider.dart';
import '../trajets/trajetDetail_page.dart';
import '../login_page.dart';
import '../error_page.dart';

class TrajetListScreen extends StatefulWidget {
  @override
  _TrajetListScreenState createState() => _TrajetListScreenState();
}

class _TrajetListScreenState extends State<TrajetListScreen> {
  @override
  void initState() {
    super.initState();
    // Vérification de l'authentification de l'utilisateur
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
      return;
    }

    // Appelle la méthode fetchTrajets au démarrage du widget
    Provider.of<TrajetProvider>(context, listen: false).fetchTrajets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Trajets'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Consumer<TrajetProvider>(
        builder: (context, trajetProvider, child) {
          if (trajetProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (trajetProvider.errorMessage != null) {
            return Center(child: Text(trajetProvider.errorMessage!));
          } else if (trajetProvider.trajets.isEmpty) {
            return Center(child: Text('Aucun trajet disponible.'));
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: trajetProvider.trajets.length,
              itemBuilder: (context, index) {
                final trajet = trajetProvider.trajets[index];
                return GestureDetector(
                  onTap: () {
                    // Redirection vers la page de détails du trajet
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          final trajetId = int.tryParse(trajet.id ?? '');
                          if (trajetId == null) {
                            return ErrorPage(); // Page d'erreur si l'ID est invalide
                          }
                          return TrajetDetailPage(trajetId: trajetId);
                        },
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      leading: Icon(
                        trajet.statut == 'actif'
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: trajet.statut == 'actif'
                            ? Colors.green
                            : Colors.red,
                        size: 40.0,
                      ),
                      title: Text(
                        trajet.nom,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 1.0,
                        ),
                      ),
                      subtitle: Text(
                        trajet.pointDepart + ' → ' + trajet.pointArrivee,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
