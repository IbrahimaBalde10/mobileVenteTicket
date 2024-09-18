import 'package:flutter/material.dart';
import 'package:mobie_app/models/transaction.dart';
import 'package:mobie_app/providers/transaction_provider.dart';
import 'package:mobie_app/screens/abonnements/acheterAbo.dart';
import 'package:mobie_app/screens/abonnements/choixPaiementAbonn.dart';
import 'package:mobie_app/screens/abonnements/vendreAbo.dart';
import 'package:mobie_app/screens/tickets/vendreTicket.dart';

import 'package:mobie_app/screens/abonnements/verificationReabonnement.dart';
import 'package:mobie_app/screens/transactions/maConso.dart';
import 'package:mobie_app/services/transaction_service.dart';

import 'package:provider/provider.dart';
import 'client/dio_client.dart';

import 'services/auth_service.dart';
import 'services/ticket_service.dart';
import 'services/trajet_service.dart';
import 'services/user_service.dart';
import 'services/typeAbonnement_service.dart';

import 'providers/auth_provider.dart';
import 'providers/ticket_provider.dart';
import 'providers/trajet_provider.dart';
import 'providers/user_provider.dart';
import 'providers/typeAbonnement_provider.dart';

import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/welcome_page.dart';
import 'screens/home_page.dart';
import 'screens/abonnements/subscriptions_screen.dart';
import 'screens/trajets/trajet_screen.dart';
import 'screens/tickets/acheterTicket_page.dart';

import 'screens/profile_screen.dart';

void main() {
  // final userService = UserService(DioClient());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(
          create: (_) => DioClient(), // Fournissez DioClient
        ),
        ProxyProvider<DioClient, AuthService>(
          update: (_, dioClient, __) =>
              AuthService(dioClient), // Utilisez DioClient
        ),
        ProxyProvider<DioClient, TicketService>(
          update: (_, dioClient, __) =>
              TicketService(dioClient), // Utilisez DioClient
        ),
        ProxyProvider<DioClient, TrajetService>(
          update: (_, dioClient, __) =>
              TrajetService(dioClient), // Utilisez DioClient
        ),
        ProxyProvider<DioClient, UserService>(
          update: (_, dioClient, __) =>
              UserService(dioClient), // Utilisez DioClient
        ),
        ProxyProvider<DioClient, TypeAbonnementService>(
          update: (_, dioClient, __) =>
              TypeAbonnementService(dioClient), // Utilisez DioClient
        ),
        ProxyProvider<DioClient, TransactionService>(
          update: (_, dioClient, __) =>
              TransactionService(), // Utilisez DioClient
        ),
        ChangeNotifierProvider(
          create: (context) =>
              AuthProvider(Provider.of<AuthService>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => TicketProvider(
              Provider.of<TicketService>(context, listen: false)),
        ),
        ChangeNotifierProvider(
          create: (context) => TrajetProvider(
              Provider.of<TrajetService>(context, listen: false)),
        ),

         ChangeNotifierProvider(
          create: (context) => TransactionProvider(
              Provider.of<TransactionService>(context, listen: false)),
        ),
         ChangeNotifierProvider(
          create: (context) => UserProvider(
              Provider.of<UserService>(context, listen: false)),
        ),
          ChangeNotifierProvider(
          create: (context) =>
              TypeAbonnementProvider(Provider.of<TypeAbonnementService>(context, listen: false)),
        ),
      ],
      child: MaterialApp(
        title: 'Mon Application',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/welcome': (context) => WelcomePage(),
          // '/manageTickets': (context) => TicketTypesPage(),
          '/manageTrajets': (context) => TrajetListScreen(),
          '/profile': (context) => ProfileScreen(),
           '/abonnements': (context) => SubscriptionsScreen(),
           '/choixpaiementAbonnement' : (context) => ChoixpaiementAbonnement(),
          '/maConso' : (context) => MaConsoScreen(),
          '/verifySubscription' : (context) => SubscriptionPage(),
          '/vendreAbo' : (context) => VendreAboPage(),
           '/acheterAbo': (context) => AcheterAboPage(),
          '/achatTicket': (context) => AchatTicketPage(),
          '/vendreTicket': (context) => VendreTicketPage(),
        }, 
      ),
    );
  }
}
