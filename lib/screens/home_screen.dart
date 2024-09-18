import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Center(
      child: Text('Bienvenue, ${authProvider.user?.prenom ?? 'Utilisateur'}!'),
    );
  }
}
