import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'beer_inventory.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE products(id TEXT PRIMARY KEY, name TEXT, quantity INTEGER)');
    await db.execute('CREATE TABLE logs(id TEXT PRIMARY KEY, barrelId TEXT, content TEXT, timestamp TEXT)');
  }

  // --- ADDED MISSING METHODS ---
  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await database;
    return await db.query('products');
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  Future<int> updateProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.update('products', product, where: 'id = ?', whereArgs: [product['id']]);
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllLogs() async {
    final db = await database;
    return await db.query('logs');
  }

  Future<int> insertUsageLog(Map<String, dynamic> log) async {
    final db = await database;
    return await db.insert('logs', log);
  }
}
