import 'package:gsheets/gsheets.dart';
import '../models/inventory_item.dart';

class GoogleSheetsApi {
  // You will replace this string with your actual Google Cloud Service Account JSON later
  static const _credentials = r'''
  {
    "type": "service_account",
    "project_id": "your-project-id",
    "private_key_id": "your-key-id",
    "private_key": "your-private-key",
    "client_email": "your-service-account-email",
    "client_id": "your-client-id"
  }
  ''';

  // You will replace this with the long ID found in your actual Google Sheet's URL
  static const _spreadsheetId = 'YOUR_SPREADSHEET_ID_HERE';
  
  static final _gsheets = GSheets(_credentials);
  static Spreadsheet? _spreadsheet;
  static Worksheet? _barrelSheet;

  // Initialize the connection
  static Future<void> init() async {
    try {
      _spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      // We will look for a tab at the bottom of your sheet called "Inventory"
      _barrelSheet = _spreadsheet?.worksheetByTitle('Inventory');
    } catch (e) {
      print('Error initializing Google Sheets connection: $e');
    }
  }

  // Example method to insert a new barrel log
  static Future<bool> insertItem(InventoryItem item) async {
    if (_barrelSheet == null) return false;
    try {
      return await _barrelSheet!.values.map.appendRow(item.toMap());
    } catch (e) {
      print('Error inserting row: $e');
      return false;
    }
  }
}
