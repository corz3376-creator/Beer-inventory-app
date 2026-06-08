import 'package:uuid/uuid.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  final String type; // IPA, Lager, Stout, etc.
  final double abv; // Alcohol by volume
  final double purchasePrice;
  final double salePrice;
  final String? supplier;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Product({
    String? id,
    required this.name,
    required this.brand,
    required this.type,
    required this.abv,
    required this.purchasePrice,
    required this.salePrice,
    this.supplier,
    this.imageUrl,
    DateTime? createdAt,
    this.updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // Convert Product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'type': type,
      'abv': abv,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'supplier': supplier,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Create Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      type: json['type'],
      abv: json['abv'],
      purchasePrice: json['purchasePrice'],
      salePrice: json['salePrice'],
      supplier: json['supplier'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    String? type,
    double? abv,
    double? purchasePrice,
    double? salePrice,
    String? supplier,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      type: type ?? this.type,
      abv: abv ?? this.abv,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      supplier: supplier ?? this.supplier,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
