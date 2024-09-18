// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/transaction_provider.dart';
// import '../login_page.dart';

// class MaConsoScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final transactionProvider = Provider.of<TransactionProvider>(context);

//     if (!authProvider.isAuthenticated) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => LoginPage()),
//         );
//       });
//       return Scaffold();
//     }

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (!transactionProvider.isLoading &&
//           transactionProvider.transactions.isEmpty) {
//         transactionProvider.fetchAllTransactions();
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Mes Transactions'),
//       ),
//       body: Consumer<TransactionProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (provider.errorMessage != null) {
//             return Center(child: Text('Erreur: ${provider.errorMessage}'));
//           }

//           if (provider.transactions.isEmpty) {
//             return Center(
//                 child: Text('Vous n\'avez pas effectué de transactions.'));
//           }

//           return ListView.builder(
//             itemCount: provider.transactions.length,
//             itemBuilder: (context, index) {
//               final transaction = provider.transactions[index];

//               return Card(
//                 margin:
//                     const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 child: ExpansionTile(
//                   title: Text('Transaction: ${transaction.transactionName}'),
//                   subtitle: Text('Montant: ${transaction.totalAmount}'),
//                   children: [
//                     ListTile(
//                       title: Text('Nom de la transaction'),
//                       subtitle: Text(transaction.transactionName),
//                     ),
//                     ListTile(
//                       title: Text('Montant total'),
//                       subtitle: Text('${transaction.totalAmount}'),
//                     ),
//                     ListTile(
//                       title: Text('Date'),
//                       subtitle: Text(transaction.date),
//                     ),
//                     if (transaction.details != null)
//                       ...transaction.details!.entries.map(
//                         (detail) => ListTile(
//                           title: Text(detail.key),
//                           subtitle: Text(detail.value.toString()),
//                         ),
//                       ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mobie_app/models/transaction.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../login_page.dart';

class MaConsoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    if (!authProvider.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      });
      return Scaffold();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!transactionProvider.isLoading &&
          transactionProvider.transactions.isEmpty) {
        transactionProvider.fetchAllTransactions();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Transactions'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Erreur: ${provider.errorMessage}'));
          }

          if (provider.transactions.isEmpty) {
            return Center(
                child: Text('Vous n\'avez pas effectué de transactions.'));
          }

          return ListView.builder(
            itemCount: provider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = provider.transactions[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text('Transaction: ${transaction.transactionName}'),
                  subtitle: Text('Montant: ${transaction.totalAmount}'),
                  onTap: () {
                    _showDetailsDialog(context, transaction);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, AppTransaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Détails de la transaction'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Nom de la transaction: ${transaction.transactionName}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text('Montant total: ${transaction.totalAmount}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8.0),
                Text('Date: ${transaction.date}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 16.0),
                if (transaction.details != null)
                  ...transaction.details!.entries.map(
                    (detail) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(detail.key,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 8.0),
                          Expanded(child: Text(detail.value.toString())),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          actions: <Widget>[
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
  }
}
