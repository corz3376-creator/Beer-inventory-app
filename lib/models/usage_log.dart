class UsageLog {
  final int? id;
  final String action;
  final String productName;
  final double quantity;
  final DateTime timestamp;

  UsageLog({
    this.id,
    required this.action,
    required this.productName,
    required this.quantity,
    required this.timestamp,
  });

  factory UsageLog.fromJson(Map<String, dynamic> json) {
    return UsageLog(
      id: json['id'] as int?,
      action: json['action'] as String,
      productName: json['productName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'action': action,
      'productName': productName,
      'quantity': quantity,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
