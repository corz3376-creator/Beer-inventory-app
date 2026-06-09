import 'package:flutter/foundation.dart';
import '../models/usage_log.dart';
import '../services/database_helper.dart';

class UsageProvider extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<UsageLog> _logs = [];

  List<UsageLog> get logs => _logs;

  Future<void> loadLogs() async {
    final data = await _dbHelper.getAllUsageLogs();
    _logs = data.map((e) => UsageLog.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addLog(UsageLog log) async {
    await _dbHelper.insertUsageLog(log.toJson());
    await loadLogs();
  }
}
