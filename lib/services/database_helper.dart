import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/index.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'beer_inventory.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        type TEXT NOT NULL,
        abv REAL NOT NULL,
        purchasePrice REAL NOT NULL,
        salePrice REAL NOT NULL,
        supplier TEXT,
        imageUrl TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');

    // Inventory table
    await db.execute('''
      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        location TEXT NOT NULL,
        parLevel INTEGER NOT NULL,
        lastCounted TEXT NOT NULL,
        lastReordered TEXT,
        reorderQuantity INTEGER,
        isActive INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY(productId) REFERENCES products(id)
      )
    ''');

    // Usage logs table
    await db.execute('''
      CREATE TABLE usage_logs (
        id TEXT PRIMARY KEY,
        productId TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        type TEXT NOT NULL,
        reason TEXT,
        location TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY(productId) REFERENCES products(id)
      )
    ''');

    // Suppliers table
    await db.execute('''
      CREATE TABLE suppliers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        address TEXT,
        city TEXT,
        state TEXT,
        zipCode TEXT,
        productIds TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Purchase orders table
    await db.execute('''
      CREATE TABLE purchase_orders (
        id TEXT PRIMARY KEY,
        supplierId TEXT NOT NULL,
        items TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        orderedAt TEXT,
        receivedAt TEXT,
        notes TEXT,
        FOREIGN KEY(supplierId) REFERENCES suppliers(id)
      )
    ''');

    // Create indices for better query performance
    await db.execute('CREATE INDEX idx_inventory_productId ON inventory(productId)');
    await db.execute('CREATE INDEX idx_usage_logs_productId ON usage_logs(productId)');
    await db.execute('CREATE INDEX idx_purchase_orders_supplierId ON purchase_orders(supplierId)');
  }

  // Close database
  Future<void> close() async {
    _database?.close();
    _database = null;
  }

  // Product operations
  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toJson());
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  Future<Product?> getProduct(String id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;
    await db.update('products', product.toJson(), where: 'id = ?', whereArgs: [product.id]);
  }

  Future<void> deleteProduct(String id) async {
    final db = await database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Inventory operations
  Future<void> insertInventory(Inventory inventory) async {
    final db = await database;
    await db.insert('inventory', inventory.toJson());
  }

  Future<List<Inventory>> getAllInventory() async {
    final db = await database;
    final maps = await db.query('inventory');
    return List.generate(maps.length, (i) => Inventory.fromJson(maps[i]));
  }

  Future<Inventory?> getInventory(String id) async {
    final db = await database;
    final maps = await db.query('inventory', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Inventory.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Inventory>> getInventoryByProduct(String productId) async {
    final db = await database;
    final maps = await db.query('inventory', where: 'productId = ?', whereArgs: [productId]);
    return List.generate(maps.length, (i) => Inventory.fromJson(maps[i]));
  }

  Future<void> updateInventory(Inventory inventory) async {
    final db = await database;
    await db.update('inventory', inventory.toJson(), where: 'id = ?', whereArgs: [inventory.id]);
  }

  Future<void> deleteInventory(String id) async {
    final db = await database;
    await db.delete('inventory', where: 'id = ?', whereArgs: [id]);
  }

  // Usage log operations
  Future<void> insertUsageLog(UsageLog log) async {
    final db = await database;
    await db.insert('usage_logs', log.toJson());
  }

  Future<List<UsageLog>> getAllUsageLogs() async {
    final db = await database;
    final maps = await db.query('usage_logs');
    return List.generate(maps.length, (i) => UsageLog.fromJson(maps[i]));
  }

  Future<List<UsageLog>> getUsageLogsByProduct(String productId) async {
    final db = await database;
    final maps = await db.query('usage_logs', where: 'productId = ?', whereArgs: [productId]);
    return List.generate(maps.length, (i) => UsageLog.fromJson(maps[i]));
  }

  // Supplier operations
  Future<void> insertSupplier(Supplier supplier) async {
    final db = await database;
    final json = supplier.toJson();
    json['productIds'] = json['productIds'].join(',');
    await db.insert('suppliers', json);
  }

  Future<List<Supplier>> getAllSuppliers() async {
    final db = await database;
    final maps = await db.query('suppliers');
    return List.generate(maps.length, (i) {
      final json = maps[i];
      json['productIds'] = (json['productIds'] as String).split(',');
      return Supplier.fromJson(json);
    });
  }

  Future<Supplier?> getSupplier(String id) async {
    final db = await database;
    final maps = await db.query('suppliers', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      final json = maps.first;
      json['productIds'] = (json['productIds'] as String).split(',');
      return Supplier.fromJson(json);
    }
    return null;
  }

  Future<void> updateSupplier(Supplier supplier) async {
    final db = await database;
    final json = supplier.toJson();
    json['productIds'] = json['productIds'].join(',');
    await db.update('suppliers', json, where: 'id = ?', whereArgs: [supplier.id]);
  }

  Future<void> deleteSupplier(String id) async {
    final db = await database;
    await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }

  // Purchase order operations
  Future<void> insertPurchaseOrder(PurchaseOrder order) async {
    final db = await database;
    await db.insert('purchase_orders', order.toJson());
  }

  Future<List<PurchaseOrder>> getAllPurchaseOrders() async {
    final db = await database;
    final maps = await db.query('purchase_orders');
    return List.generate(maps.length, (i) => PurchaseOrder.fromJson(maps[i]));
  }

  Future<PurchaseOrder?> getPurchaseOrder(String id) async {
    final db = await database;
    final maps = await db.query('purchase_orders', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return PurchaseOrder.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updatePurchaseOrder(PurchaseOrder order) async {
    final db = await database;
    await db.update('purchase_orders', order.toJson(), where: 'id = ?', whereArgs: [order.id]);
  }
}
