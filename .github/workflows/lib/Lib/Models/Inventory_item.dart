import 'package:uuid/uuid.dart';

class InventoryItem {
  final String id;
  String name;
  String category;
  String brand;
  double currentStock;
  double parLevel;
  String unitType;
  String location;
  String? barcode;
  bool isLowStock;

  InventoryItem({
    String? id,
    required this.name,
    required this.category,
    required this.brand,
    required this.currentStock,
    required this.parLevel,
    required this.unitType,
    this.location = 'Main Bar',
    this.barcode,
  })  : id = id ?? const Uuid().v4(),
        isLowStock = currentStock < parLevel * 0.3;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'brand': brand,
      'currentStock': currentStock,
      'parLevel': parLevel,
      'unitType': unitType,
      'location': location,
      'barcode': barcode,
      'isLowStock': isLowStock,
    };
  }

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      brand: json['brand'],
      currentStock: json['currentStock'],
      parLevel: json['parLevel'],
      unitType: json['unitType'],
      location: json['location'] ?? 'Main Bar',
      barcode: json['barcode'],
    );
  }
}
