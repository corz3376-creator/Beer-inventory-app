import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _dbHelper.getAllProducts();
      notifyListeners();
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add product
  Future<void> addProduct(Product product) async {
    try {
      await _dbHelper.insertProduct(product);
      _products.add(product);
      notifyListeners();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Update product
  Future<void> updateProduct(Product product) async {
    try {
      await _dbHelper.updateProduct(product);
      int index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _dbHelper.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Search products
  List<Product> searchProducts(String query) {
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(query.toLowerCase()) ||
            p.brand.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get products by type
  List<Product> getProductsByType(String type) {
    return _products.where((p) => p.type == type).toList();
  }
}
