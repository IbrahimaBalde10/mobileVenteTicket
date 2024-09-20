// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/background.jfif'), // Chemin vers votre image de fond
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.6)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children:  [
//               Text(
//                 'Bienvenue sur SUNUAPP',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Vente de tickets et recharge d\'abonnement',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white70,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                       backgroundColor: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     onPressed: () => Navigator.pushNamed(context, '/login'),
//                     child: Text(
//                       'Se Connecter',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   SizedBox(width: 20),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                       backgroundColor: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                     onPressed: () => Navigator.pushNamed(context, '/register'),
//                     child: Text(
//                       'S\'Inscrire',
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// 20/09/24
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jfif'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Effet de gradient pour rendre le texte plus visible
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.5),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenu de la page
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Titre avec animation
              FadeInDown(
                duration: Duration(seconds: 1),
                child: Text(
                  'Bienvenue sur SUNUAPP',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        blurRadius: 15,
                        color: Colors.black54,
                        offset: Offset(3, 3),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              // Sous-titre avec animation
              FadeInUp(
                duration: Duration(seconds: 1),
                child: Text(
                  'Vente de tickets et recharge d\'abonnement',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 50),
              // Boutons avec animations et icônes
              FadeIn(
                duration: Duration(seconds: 1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Bouton Connexion
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black38,
                      ),
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text(
                        'Se Connecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    // Bouton Inscription
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        backgroundColor: Colors.orangeAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.black38,
                      ),
                      onPressed: () =>
                          Navigator.pushNamed(context, '/register'),
                      icon: Icon(Icons.person_add, color: Colors.white),
                      label: Text(
                        'S\'Inscrire',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              // Effet de hover sur les boutons
              MouseRegion(
                onEnter: (_) => print('Hovering!'),
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
