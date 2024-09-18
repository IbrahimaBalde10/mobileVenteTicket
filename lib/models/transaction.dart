class AppTransaction {
  final int? id;
  final String? transactionName;
  final double? totalAmount;
  final String? date;
  final Map<String, dynamic>? details;
  //
  String nombreTickets;
  String nombreAbonnements;
  String montantTotal;
  String nombreTransactions;
  String nombreTrajets;
  String nombreTypeAbonnements;
  //

  AppTransaction(
      {
       this.id,
       this.transactionName,
       this.totalAmount,
       this.date,
      this.details,
      //
      required this.nombreTickets,
      required this.nombreAbonnements,
      required this.montantTotal,
      required this.nombreTransactions,
      required this.nombreTrajets,
      required this.nombreTypeAbonnements
      });

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    return AppTransaction(
      id: json['id'],
      transactionName: json['transaction_name'],
      // totalAmount: (json['total_amount'] as num).toDouble(),
      totalAmount: double.tryParse(json['total_amount'].toString()) ??0.0, // Convertir en double
      date: json['date'],
      details: json['details'],
      //
      nombreTickets: json['nombre_tickets']?.toString() ?? '0',
      nombreAbonnements: json['nombre_abonnements']?.toString() ?? '0',
      montantTotal: json['montant_total']?.toString() ?? '0',
      nombreTransactions: json['nombre_transactions']?.toString() ?? '0',
      nombreTrajets: json['nombreTrajets']?.toString() ?? '0',
      nombreTypeAbonnements: json['nombreTypeAbonnements']?.toString() ?? '0',
    );
  }
}
