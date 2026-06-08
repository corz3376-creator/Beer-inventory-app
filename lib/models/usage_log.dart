import 'package:uuid/uuid.dart';

enum UsageType { sold, wasted, lost, damaged, spillage, other }

class UsageLog {
  final String id;
  final String productId;
  final int quantity;
  final UsageType type;
  final String? reason;
  final String location;
  final DateTime timestamp;
  final String? notes;

  UsageLog({
    String? id,
    required this.productId,
    required this.quantity,
    required this.type,
    this.reason,
    required this.location,
    DateTime? timestamp,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'type': type.toString().split('.').last,
      'reason': reason,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory UsageLog.fromJson(Map<String, dynamic> json) {
    return UsageLog(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      type: UsageType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      reason: json['reason'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      notes: json['notes'],
    );
  }

  UsageLog copyWith({
    String? id,
    String? productId,
    int? quantity,
    UsageType? type,
    String? reason,
    String? location,
    DateTime? timestamp,
    String? notes,
  }) {
    return UsageLog(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
      reason: reason ?? this.reason,
      location: location ?? this.location,
      timestamp: timestamp ?? this.timestamp,
      notes: notes ?? this.notes,
    );
  }
}
