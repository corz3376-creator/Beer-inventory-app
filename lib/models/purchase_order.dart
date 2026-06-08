import 'package:uuid/uuid.dart';

enum OrderStatus { pending, ordered, received, cancelled }

class PurchaseOrderItem {
  final String productId;
  final int quantity;
  final double unitPrice;

  PurchaseOrderItem({
    required this.productId,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory PurchaseOrderItem.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderItem(
      productId: json['productId'],
      quantity: json['quantity'],
      unitPrice: json['unitPrice'],
    );
  }
}

class PurchaseOrder {
  final String id;
  final String supplierId;
  final List<PurchaseOrderItem> items;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? orderedAt;
  final DateTime? receivedAt;
  final String? notes;

  PurchaseOrder({
    String? id,
    required this.supplierId,
    required this.items,
    this.status = OrderStatus.pending,
    DateTime? createdAt,
    this.orderedAt,
    this.receivedAt,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  double get totalCost => items.fold(0, (sum, item) => sum + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'orderedAt': orderedAt?.toIso8601String(),
      'receivedAt': receivedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) {
    return PurchaseOrder(
      id: json['id'],
      supplierId: json['supplierId'],
      items: (json['items'] as List)
          .map((item) => PurchaseOrderItem.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
      orderedAt: json['orderedAt'] != null
          ? DateTime.parse(json['orderedAt'])
          : null,
      receivedAt: json['receivedAt'] != null
          ? DateTime.parse(json['receivedAt'])
          : null,
      notes: json['notes'],
    );
  }

  PurchaseOrder copyWith({
    String? id,
    String? supplierId,
    List<PurchaseOrderItem>? items,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? orderedAt,
    DateTime? receivedAt,
    String? notes,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      items: items ?? this.items,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      orderedAt: orderedAt ?? this.orderedAt,
      receivedAt: receivedAt ?? this.receivedAt,
      notes: notes ?? this.notes,
    );
  }
}
