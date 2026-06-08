import 'package:flutter/material.dart';
import '../models/usage_log.dart';
import '../services/database_helper.dart';

class UsageProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<UsageLog> _logs = [];
  bool _isLoading = false;

  List<UsageLog> get logs => _logs;
  bool get isLoading => _isLoading;

  Future<void> loadLogs() async {
    _isLoading = true;
    notifyListeners();
    try {
      _logs = await _dbHelper.getAllUsageLogs();
      notifyListeners();
    } catch (e) {
      print('Error loading logs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLog(UsageLog log) async {
    try {
      await _dbHelper.insertUsageLog(log);
      _logs.add(log);
      notifyListeners();
    } catch (e) {
      print('Error adding log: $e');
    }
  }

  List<UsageLog> getLogsByProduct(String productId) {
    return _logs.where((l) => l.productId == productId).toList();
  }

  List<UsageLog> getLogsByType(UsageType type) {
    return _logs.where((l) => l.type == type).toList();
  }

  int getTotalUsageByProduct(String productId) {
    return _logs.where((l) => l.productId == productId).fold(0, (sum, log) => sum + log.quantity);
  }

  Map<UsageType, int> getWasteSummary() {
    Map<UsageType, int> summary = {};
    for (var type in UsageType.values) {
      summary[type] = _logs
          .where((l) => l.type == type)
          .fold(0, (sum, log) => sum + log.quantity);
    }
    return summary;
  }
}
