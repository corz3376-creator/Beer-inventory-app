import '../services/google_sheets_api.dart';
import 'package:flutter/foundation.dart';
import '../models/inventory_item.dart';

class InventoryProvider extends ChangeNotifier {
  List<InventoryItem> _items = [];
  
  List<InventoryItem> get items => _items;
  int get lowStockCount => _items.where((item) => item.isLowStock).length;

  void addItem(InventoryItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateStock(String id, double newStock) {
    final item = _items.firstWhere((i) => i.id == id);
    item.currentStock = newStock;
    item.isLowStock = newStock < item.parLevel * 0.3;
    notifyListeners();
  }

  List<InventoryItem> getItemsByCategory(String category) {
    if (category == 'All') return _items;
    return _items.where((item) => item.category == category).toList();
  }
}
