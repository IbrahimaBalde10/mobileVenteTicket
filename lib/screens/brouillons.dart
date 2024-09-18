ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    // Effectuer la suite des opérations
                    final telephone = _telephoneController.text;
                    final abonnementId = _selectedAbonnementId;
                     final vendeurNom = authProvider.user?.nom;
                    final vendeurId = authProvider.user?.id;

                    // Vérifier si l'utilisateur est c
                    // Ici, vous pouvez passer ces informations à une autre méthode pour traiter la vente
                    print(
                      'Nom du vendeur : $vendeurNom' '\n'
                      'Id du vendeur : $vendeurId' '\n'
                      'Téléphone client: $telephone'
                      '\n Abonnement sélectionné : $abonnementId');
                  }
                },
                child: Text('Continuer'),
              ),