import 'package:uuid/uuid.dart';

class Supplier {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final List<String> productIds;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  Supplier({
    String? id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.zipCode,
    List<String>? productIds,
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
  })  : id = id ?? const Uuid().v4(),
        productIds = productIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'productIds': productIds,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      productIds: List<String>.from(json['productIds'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  Supplier copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? state,
    String? zipCode,
    List<String>? productIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Supplier(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      productIds: productIds ?? this.productIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
