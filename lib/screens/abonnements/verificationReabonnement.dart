import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/typeAbonnement_provider.dart';
import '../../providers/auth_provider.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Vérifier si l'utilisateur est connecté
    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeAbonnementProvider = Provider.of<TypeAbonnementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Abonnements'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Numéro de téléphone'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer votre numéro de téléphone';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        await _verifySubscription(context);
                      }
                    },
                    child: Text('Vérifier l\'abonnement'),
                  ),
                  SizedBox(height: 20),
                  if (typeAbonnementProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        typeAbonnementProvider.errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (typeAbonnementProvider.status == 'not_found')
                    Text(
                      'Utilisateur introuvable.',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (typeAbonnementProvider.status == 'no_subscription')
                    Text(
                      'Cet utilisateur n\'a pas d\'abonnement existant.',
                      style: TextStyle(color: Colors.red),
                    ),
                  if (typeAbonnementProvider.status == 'valid')
                    Text(
                      'Votre abonnement est encore valide jusqu\'au ${typeAbonnementProvider.endDate}.',
                      style: TextStyle(color: Colors.green),
                    ),
                  if (typeAbonnementProvider.status == 'expired') ...[
                    Text(
                      'Votre abonnement est expiré.',
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/renewSubscription');
                      },
                      child: Text('Renouveler l\'abonnement'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _verifySubscription(BuildContext context) async {
    final provider =
        Provider.of<TypeAbonnementProvider>(context, listen: false);

    // Appel de la méthode checkSubscriptionStatus avec le téléphone de l'utilisateur
    await provider.checkSubscriptionStatus(_phoneController.text);

    if (provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Statut de l\'abonnement vérifié avec succès.'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(provider.errorMessage!),
      ));
    }
  }
}

