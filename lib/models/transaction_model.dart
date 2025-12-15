class Transaction {
  final String type; // 'in' or 'out'
  final String itemName;
  final int quantity;
  final DateTime createdAt;

  Transaction({
    required this.type,
    required this.itemName,
    required this.quantity,
    required this.createdAt,
  });

  factory Transaction.fromMap(Map<String, dynamic> map, String type) {
    return Transaction(
      type: type,
      itemName: map['item']?['name'] ?? 'Unknown Item',
      quantity: map['qty'] ?? 0,
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
