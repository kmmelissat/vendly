import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../shared/models/user_model.dart';
import '../../shared/models/store_model.dart';
import '../../shared/models/product_model.dart';
import '../../shared/models/order_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'linkup.db');

    return await openDatabase(path, version: 1, onCreate: _createTables);
  }

  Future<void> _createTables(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        phoneNumber TEXT,
        profileImageUrl TEXT,
        role TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        isActive INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Stores table
    await db.execute('''
      CREATE TABLE stores (
        id TEXT PRIMARY KEY,
        sellerId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        logoUrl TEXT,
        bannerUrl TEXT,
        category TEXT NOT NULL,
        address TEXT NOT NULL,
        phoneNumber TEXT,
        website TEXT,
        status TEXT NOT NULL,
        rating REAL NOT NULL DEFAULT 0.0,
        totalReviews INTEGER NOT NULL DEFAULT 0,
        totalProducts INTEGER NOT NULL DEFAULT 0,
        totalSales INTEGER NOT NULL DEFAULT 0,
        totalRevenue REAL NOT NULL DEFAULT 0.0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (sellerId) REFERENCES users (id)
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        storeId TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        imageUrls TEXT,
        price REAL NOT NULL,
        originalPrice REAL,
        category TEXT NOT NULL,
        tags TEXT,
        stockQuantity INTEGER NOT NULL DEFAULT 0,
        minOrderQuantity INTEGER NOT NULL DEFAULT 1,
        status TEXT NOT NULL,
        rating REAL NOT NULL DEFAULT 0.0,
        totalReviews INTEGER NOT NULL DEFAULT 0,
        totalSales INTEGER NOT NULL DEFAULT 0,
        sku TEXT,
        weight REAL,
        dimensions TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (storeId) REFERENCES stores (id)
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        buyerId TEXT NOT NULL,
        storeId TEXT NOT NULL,
        storeName TEXT NOT NULL,
        items TEXT NOT NULL,
        subtotal REAL NOT NULL,
        deliveryFee REAL NOT NULL,
        tax REAL NOT NULL DEFAULT 0.0,
        total REAL NOT NULL,
        status TEXT NOT NULL,
        paymentStatus TEXT NOT NULL,
        paymentMethod TEXT,
        deliveryAddress TEXT NOT NULL,
        deliveryInstructions TEXT,
        estimatedDelivery TEXT,
        trackingNumber TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (buyerId) REFERENCES users (id),
        FOREIGN KEY (storeId) REFERENCES stores (id)
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_stores_seller ON stores (sellerId)');
    await db.execute('CREATE INDEX idx_products_store ON products (storeId)');
    await db.execute(
      'CREATE INDEX idx_products_category ON products (category)',
    );
    await db.execute('CREATE INDEX idx_orders_buyer ON orders (buyerId)');
    await db.execute('CREATE INDEX idx_orders_store ON orders (storeId)');
    await db.execute('CREATE INDEX idx_orders_status ON orders (status)');
  }

  // User operations
  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(User user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Store operations
  Future<int> insertStore(Store store) async {
    final db = await database;
    return await db.insert('stores', store.toMap());
  }

  Future<Store?> getStoreById(String id) async {
    final db = await database;
    final maps = await db.query('stores', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Store.fromMap(maps.first);
    }
    return null;
  }

  Future<Store?> getStoreByUserId(String userId) async {
    final db = await database;
    final maps = await db.query(
      'stores',
      where: 'sellerId = ?',
      whereArgs: [userId],
    );
    if (maps.isNotEmpty) {
      return Store.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Store>> getAllStores() async {
    final db = await database;
    final maps = await db.query('stores', orderBy: 'createdAt DESC');
    return maps.map((map) => Store.fromMap(map)).toList();
  }

  Future<int> updateStore(Store store) async {
    final db = await database;
    return await db.update(
      'stores',
      store.toMap(),
      where: 'id = ?',
      whereArgs: [store.id],
    );
  }

  // Product operations
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', product.toMap());
  }

  Future<Product?> getProductById(String id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Product.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Product>> getProductsByStoreId(String storeId) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'storeId = ?',
      whereArgs: [storeId],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> getAllProducts({String? category}) async {
    final db = await database;
    String? where;
    List<String>? whereArgs;

    if (category != null && category != 'All') {
      where = 'category = ? AND status = ?';
      whereArgs = [category, 'active'];
    } else {
      where = 'status = ?';
      whereArgs = ['active'];
    }

    final maps = await db.query(
      'products',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where:
          'status = ? AND (name LIKE ? OR description LIKE ? OR tags LIKE ?)',
      whereArgs: ['active', '%$query%', '%$query%', '%$query%'],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // Order operations
  Future<int> insertOrder(Order order) async {
    final db = await database;
    final orderMap = order.toMap();
    orderMap['items'] = orderMap['items']
        .toString(); // Convert list to string for storage
    return await db.insert('orders', orderMap);
  }

  Future<Order?> getOrderById(String id) async {
    final db = await database;
    final maps = await db.query('orders', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Order.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Order>> getOrdersByBuyerId(String buyerId) async {
    final db = await database;
    final maps = await db.query(
      'orders',
      where: 'buyerId = ?',
      whereArgs: [buyerId],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<List<Order>> getOrdersByStoreId(String storeId) async {
    final db = await database;
    final maps = await db.query(
      'orders',
      where: 'storeId = ?',
      whereArgs: [storeId],
      orderBy: 'createdAt DESC',
    );
    return maps.map((map) => Order.fromMap(map)).toList();
  }

  Future<int> updateOrder(Order order) async {
    final db = await database;
    final orderMap = order.toMap();
    orderMap['items'] = orderMap['items']
        .toString(); // Convert list to string for storage
    return await db.update(
      'orders',
      orderMap,
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  // Close database
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
