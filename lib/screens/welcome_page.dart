// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// import './login_page.dart';
// import 'home_screen.dart';
// import 'tickets_screen.dart';
// import 'abonnements/subscriptions_screen.dart';
// import 'profile_screen.dart';
// import 'trajets/trajet_screen.dart';
// import './transactions/maConso.dart';

// class WelcomePage extends StatefulWidget {
//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   int _selectedIndex = 0;

//   static List<Widget> _pages = <Widget>[
//     HomeScreen(), // Accueil
//     TrajetListScreen(), // Trajets
//     TicketsScreen(), // Tickets
//     SubscriptionsScreen(), // Abonnements
//     ProfileScreen(),
//     MaConsoScreen() // Profil
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     // Vérification si l'utilisateur est authentifié
//     if (!authProvider.isAuthenticated) {
//       // Rediriger vers la page de connexion s'il n'est pas authentifié
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//       });
//       return Scaffold(); // Retourne une page vide temporaire
//     }

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 150.0,
//         backgroundColor: Colors.blue,
//         title: Row(
//           children: [
//             // IconButton(
//             //   icon: Icon(Icons.menu, color: Colors.white),
//             //   onPressed: () {
//             //     Scaffold.of(context).openDrawer();
//             //   },
//             // ),
//             SizedBox(width: 8), // Espace entre l'icône du Drawer et les textes
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Bienvenue, ${authProvider.user?.prenom ?? 'Utilisateur'}',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 Text(
//                   'SunuAPP',
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Rechercher...',
//                     hintStyle: TextStyle(color: Colors.white70),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 8.0,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.white),
//               onPressed: () {
//                 // Action pour la recherche
//               },
//             ),
//           ],
//         ),
//       ),
//       // drawer: Drawer(
//       //   // backgroundColor: Colors.white,
//       //   // icon: Icon(Icons.menu, color: Colors.white),
//       //   child: ListView(
//       //     padding: EdgeInsets.zero,
//       //     children: <Widget>[
//       //       UserAccountsDrawerHeader(
//       //         accountName: Text(authProvider.user?.nom ?? 'Nom'),
//       //         accountEmail: Text(authProvider.user?.email ?? 'Email'),
//       //         currentAccountPicture: CircleAvatar(
//       //           backgroundColor: Colors.white,
//       //           child: Text(
//       //             authProvider.user?.prenom?.substring(0, 1) ?? '',
//       //             style: TextStyle(fontSize: 40.0),
//       //           ),
//       //         ),
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.event),
//       //         title: Text('Gestion des Tickets'),
//       //         onTap: () {
//       //           Navigator.pushNamed(context, '/manageTickets');
//       //         },
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.event),
//       //         title: Text('Gestion des Trajets'),
//       //         onTap: () {
//       //           Navigator.pushNamed(context, '/manageTrajets');
//       //         },
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.subscriptions),
//       //         title: Text('Gestion des Abonnements'),
//       //         onTap: () {
//       //           Navigator.pushNamed(context, '/manageSubscriptions');
//       //         },
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.person),
//       //         title: Text('Profil'),
//       //         onTap: () {
//       //           Navigator.pushNamed(context, '/profile');
//       //         },
//       //       ),
//       //       ListTile(
//       //         leading: Icon(Icons.logout),
//       //         title: Text('Déconnexion'),
//       //         onTap: () {
//       //           authProvider.logout();
//       //           Navigator.pushReplacementNamed(context, '/');
//       //         },
//       //       ),
//       //     ],
//       //   ),
//       // ),

//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Row(
//                 children: [
//                   Expanded(
//                     child: Text(authProvider.user?.nom ?? 'Nom'),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/profile');
//                     },
//                   ),
//                 ],
//               ),
//               accountEmail: Text(authProvider.user?.email ?? 'Email'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   authProvider.user?.prenom?.substring(0, 1) ?? '',
//                   style: TextStyle(fontSize: 40.0),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.event),
//               title: Text('Gestion des Tickets'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/manageTickets');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.event),
//               title: Text('Gestion des Trajets'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/manageTrajets');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.subscriptions),
//               title: Text('Gestion des Abonnements'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/abonnements');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profil'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Ma conso'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/maConso');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Déconnexion'),
//               onTap: () {
//                 authProvider.logout();
//                 Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.only(bottom: 16.0),
//         child: _pages[_selectedIndex],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Trajets',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Tickets',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.subscriptions),
//             label: 'Abonnements',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.white,
//         backgroundColor: Colors.blue,
//         onTap: _onItemTapped,
//         selectedIconTheme: IconThemeData(color: Colors.black, size: 30),
//         unselectedIconTheme: IconThemeData(color: Colors.white, size: 24),
//         selectedLabelStyle:
//             TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         unselectedLabelStyle: TextStyle(fontSize: 12),
//         showUnselectedLabels: true,
//         type: BottomNavigationBarType.fixed,
//       ),
//     );
//   }
// }



// 17/09/24
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';
// import '../providers/transaction_provider.dart';

// import './login_page.dart';
// import 'home_screen.dart';
// import 'tickets_screen.dart';
// import 'abonnements/subscriptions_screen.dart';
// import 'profile_screen.dart';
// import 'trajets/trajet_screen.dart';
// import './transactions/maConso.dart';

// class WelcomePage extends StatefulWidget {
//   @override
//   _WelcomePageState createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   int _selectedIndex = 0;

//   static List<Widget> _pages = <Widget>[
//     HomeScreen(),
//     TrajetListScreen(),
//     TicketsScreen(),
//     SubscriptionsScreen(),
//     ProfileScreen(),
//     MaConsoScreen()
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     // Récupérer les statistiques au démarrage de la page
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<TransactionProvider>(context, listen: false)
//           .fetchAllStatistiques();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final transactionProvider = Provider.of<TransactionProvider>(context);

//     if (!authProvider.isAuthenticated) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//       });
//       return Scaffold();
//     }

//     Widget _buildStatCard(String title, String value, Color color) {
//       return Container(
//         height: 30,
//         width: 30,
//         margin: EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: color,
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 title,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 8.0),
//               Text(
//                 value,
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         toolbarHeight: 150.0,
//         backgroundColor: Colors.blue,
//         title: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.menu, color: Colors.white),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             ),
//             SizedBox(width: 8),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Bienvenue, ${authProvider.user?.prenom ?? 'Utilisateur'}',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//                 Text(
//                   'SunuAPP',
//                   style: TextStyle(fontSize: 14, color: Colors.white70),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Rechercher...',
//                     hintStyle: TextStyle(color: Colors.white70),
//                     filled: true,
//                     fillColor: Colors.white.withOpacity(0.2),
//                     contentPadding: EdgeInsets.symmetric(
//                       horizontal: 16.0,
//                       vertical: 8.0,
//                     ),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.search, color: Colors.white),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             UserAccountsDrawerHeader(
//               accountName: Row(
//                 children: [
//                   Expanded(
//                     child: Text(authProvider.user?.nom ?? 'Nom'),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.edit, color: Colors.white),
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/profile');
//                     },
//                   ),
//                 ],
//               ),
//               accountEmail: Text(authProvider.user?.email ?? 'Email'),
//               currentAccountPicture: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Text(
//                   authProvider.user?.prenom?.substring(0, 1) ?? '',
//                   style: TextStyle(fontSize: 40.0),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.event),
//               title: Text('Gestion des Tickets'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/manageTickets');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.event),
//               title: Text('Gestion des Trajets'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/manageTrajets');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.subscriptions),
//               title: Text('Gestion des Abonnements'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/abonnements');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Profil'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('Ma conso'),
//               onTap: () {
//                 Navigator.pushNamed(context, '/maConso');
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Déconnexion'),
//               onTap: () {
//                 authProvider.logout();
//                 Navigator.pushReplacementNamed(context, '/');
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Bienvenue dans SunuApp, une application pour gérer vos tickets, abonnements, trajets et plus encore !',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//               ),
//               SizedBox(height: 20),
//               if (transactionProvider.isLoading)
//                 Center(child: CircularProgressIndicator())
//               else if (transactionProvider.errorMessage != null)
//                 Center(
//                     child: Text('Erreur: ${transactionProvider.errorMessage}'))
//               else
//                 GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: 6,
//                   shrinkWrap: true, // Important for nested GridView
//                   physics:
//                       NeverScrollableScrollPhysics(), // Disable scrolling for nested GridView
//                   itemBuilder: (context, index) {
//                     final stat = transactionProvider.statistics;

//                     final titles = [
//                       'Tickets',
//                       'Abonnements',
//                       'Transactions',
//                       'Montant Total',
//                       'Trajets',
//                       'Types Abonnements'
//                     ];

//                     final keys = [
//                       'nombre_tickets',
//                       'nombre_abonnements',
//                       'nombre_transactions',
//                       'montant_total',
//                       'nombreTrajets',
//                       'nombreTypeAbonnements'
//                     ];

//                     return _buildStatCard(
//                       titles[index],
//                       '${stat[keys[index]] ?? '0'}',
//                       [
//                         Colors.blue,
//                         Colors.green,
//                         Colors.orange,
//                         Colors.red,
//                         Colors.purple,
//                         Colors.cyan
//                       ][index],
//                     );
//                   },
//                 ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Trajets',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.event),
//             label: 'Tickets',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.subscriptions),
//             label: 'Abonnements',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.local_offer),
//             label: 'Ma conso',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.blue,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// 18/09/24

import 'package:flutter/material.dart';
import 'package:mobie_app/models/typeAbonnement.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';

import './login_page.dart';
import 'home_screen.dart';
import 'tickets_screen.dart';
import 'abonnements/subscriptions_screen.dart';
import 'profile_screen.dart';
import 'trajets/trajet_screen.dart';
import './transactions/maConso.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    HomeScreen(),
    TrajetListScreen(),
    TicketsScreen(),
    SubscriptionsScreen(),
    ProfileScreen(),
    MaConsoScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .fetchAllStatistiques();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      });
      return Scaffold();
    }

    Widget _buildStatCard(String title, String value, Color color) {
      return Container(
        height: 80, // Réduit la hauteur des cases
        width: 120, // Réduit la largeur des cases
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // Réduit la taille de la police
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                  height: 4.0), // Réduit l'espace entre le titre et la valeur
              Text(
                value,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Réduit la taille de la police
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150.0,
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // 'Bienvenue, ${authProvider.user?.prenom ?? 'Utilisateur'}',
                    'Bienvenue, ${authProvider.user?.nom ?? 'Utilisateur'}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  'SunuAPP',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher...',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Row(
                children: [
                  Expanded(
                    child: Text(authProvider.user?.nom ?? 'Nom'),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                ],
              ),
              accountEmail: Text(authProvider.user?.email ?? 'Email'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  authProvider.user?.nom?.substring(0, 1) ?? '',
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Gestion des Tickets'),
              onTap: () {
                Navigator.pushNamed(context, '/manageTickets');
              },
            ),
            ListTile(
              leading: Icon(Icons.event),
              title: Text('Gestion des Trajets'),
              onTap: () {
                Navigator.pushNamed(context, '/manageTrajets');
              },
            ),
            ListTile(
              leading: Icon(Icons.subscriptions),
              title: Text('Gestion des Abonnements'),
              onTap: () {
                Navigator.pushNamed(context, '/abonnements');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Ma conso'),
              onTap: () {
                Navigator.pushNamed(context, '/maConso');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Déconnexion'),
              onTap: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bienvenue dans SunuApp, une application pour gérer vos tickets, abonnements, trajets et plus encore !',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              if (transactionProvider.isLoading)
                Center(child: CircularProgressIndicator())
              else if (transactionProvider.errorMessage != null)
                Center(
                    child: Text('Erreur: ${transactionProvider.errorMessage}'))
              else
            GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
  ),
  itemCount: 6,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
  itemBuilder: (context, index) {
    final stat = transactionProvider.statistics;

    final titles = [
      'Tickets',
      'Abonnements',
      'Transactions',
      'Montant Total',
      'Trajets',
      'Types Abonnements'
    ];

    final keys = [
      'nombre_tickets',
      'nombre_abonnements',
      'nombre_transactions',
      'montant_total',
      'nombreTrajets',
      'nombreTypeAbonnements'
    ];

    return GestureDetector(
      onTap: () {
        // Navigation vers la page correspondante
        switch (index) {
          case 0:
            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketsScreen()));
            break;
          case 1:
            Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionsScreen()));
            break;
          case 2:
            Navigator.push(context, MaterialPageRoute(builder: (context) => MaConsoScreen()));
            break;
          case 3:
            Navigator.push(context, MaterialPageRoute(builder: (context) => MaConsoScreen()));
            break;
          case 4:
            Navigator.push(context, MaterialPageRoute(builder: (context) => TrajetListScreen()));
            break;
          case 5:
            Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionsScreen()));
            break;
          default:
            break;
        }
      },
      child: _buildStatCard(
        titles[index],
        '${stat[keys[index]] ?? '0'}',
        [
          Colors.blue,
          Colors.green,
          Colors.orange,
          Colors.red,
          Colors.purple,
          Colors.cyan
        ][index],
      ),
    );
  },
)
            ],
          ),
        ),
      ),
          bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Trajets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions),
            label: 'Abonnements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.blue,
        onTap: _onItemTapped,
        selectedIconTheme: IconThemeData(color: Colors.black, size: 30),
        unselectedIconTheme: IconThemeData(color: Colors.white, size: 24),
        selectedLabelStyle:
            TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}