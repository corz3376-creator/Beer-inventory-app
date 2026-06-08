import 'package:uuid/uuid.dart';

class Inventory {
  final String id;
  final String productId;
  final int quantity;
  final String location; // e.g., "Cooler", "Bar", "Storage"
  final int parLevel; // Minimum stock level
  final DateTime lastCounted;
  final DateTime? lastReordered;
  final int? reorderQuantity;
  final bool isActive;

  Inventory({
    String? id,
    required this.productId,
    required this.quantity,
    required this.location,
    required this.parLevel,
    DateTime? lastCounted,
    this.lastReordered,
    this.reorderQuantity,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        lastCounted = lastCounted ?? DateTime.now();

  // Check if below par level
  bool isBelowPar() => quantity < parLevel;

  // Calculate days since last count
  int daysSinceLastCount() {
    return DateTime.now().difference(lastCounted).inDays;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'quantity': quantity,
      'location': location,
      'parLevel': parLevel,
      'lastCounted': lastCounted.toIso8601String(),
      'lastReordered': lastReordered?.toIso8601String(),
      'reorderQuantity': reorderQuantity,
      'isActive': isActive,
    };
  }

  factory Inventory.fromJson(Map<String, dynamic> json) {
    return Inventory(
      id: json['id'],
      productId: json['productId'],
      quantity: json['quantity'],
      location: json['location'],
      parLevel: json['parLevel'],
      lastCounted: DateTime.parse(json['lastCounted']),
      lastReordered: json['lastReordered'] != null
          ? DateTime.parse(json['lastReordered'])
          : null,
      reorderQuantity: json['reorderQuantity'],
      isActive: json['isActive'] ?? true,
    );
  }

  Inventory copyWith({
    String? id,
    String? productId,
    int? quantity,
    String? location,
    int? parLevel,
    DateTime? lastCounted,
    DateTime? lastReordered,
    int? reorderQuantity,
    bool? isActive,
  }) {
    return Inventory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      parLevel: parLevel ?? this.parLevel,
      lastCounted: lastCounted ?? this.lastCounted,
      lastReordered: lastReordered ?? this.lastReordered,
      reorderQuantity: reorderQuantity ?? this.reorderQuantity,
      isActive: isActive ?? this.isActive,
    );
  }
}
