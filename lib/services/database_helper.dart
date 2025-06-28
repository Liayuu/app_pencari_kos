import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/kos.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'boss_kost.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create kos table
    await db.execute('''
      CREATE TABLE kos(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        price INTEGER NOT NULL,
        description TEXT NOT NULL,
        facilities TEXT NOT NULL,
        images TEXT NOT NULL,
        rating REAL NOT NULL,
        distanceToUniversity REAL NOT NULL,
        type TEXT NOT NULL,
        isAvailable INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create favorites table
    await db.execute('''
      CREATE TABLE favorites(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kosId TEXT NOT NULL,
        userId TEXT NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (kosId) REFERENCES kos (id)
      )
    ''');

    // Create bookings table
    await db.execute('''
      CREATE TABLE bookings(
        id TEXT PRIMARY KEY,
        kosId TEXT NOT NULL,
        userId TEXT NOT NULL,
        checkInDate TEXT NOT NULL,
        checkOutDate TEXT,
        totalPrice INTEGER NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (kosId) REFERENCES kos (id)
      )
    ''');

    // Create users table
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        phone TEXT,
        profileImagePath TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Create search history table
    await db.execute('''
      CREATE TABLE search_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        query TEXT NOT NULL,
        filters TEXT,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // Kos operations
  Future<int> insertKos(Kos kos) async {
    final db = await database;
    return await db.insert(
      'kos',
      kos.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Kos>> getAllKos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('kos');

    return List.generate(maps.length, (i) {
      return Kos.fromJson(maps[i]);
    });
  }

  Future<List<Kos>> searchKos(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'kos',
      where: 'name LIKE ? OR address LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Kos.fromJson(maps[i]);
    });
  }

  Future<int> updateKos(Kos kos) async {
    final db = await database;
    return await db.update(
      'kos',
      kos.toJson(),
      where: 'id = ?',
      whereArgs: [kos.id],
    );
  }

  Future<int> deleteKos(String id) async {
    final db = await database;
    return await db.delete('kos', where: 'id = ?', whereArgs: [id]);
  }

  // Favorites operations
  Future<int> addToFavorites(String kosId, String userId) async {
    final db = await database;
    return await db.insert('favorites', {
      'kosId': kosId,
      'userId': userId,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> removeFromFavorites(String kosId, String userId) async {
    final db = await database;
    return await db.delete(
      'favorites',
      where: 'kosId = ? AND userId = ?',
      whereArgs: [kosId, userId],
    );
  }

  Future<List<String>> getFavoriteKosIds(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorites',
      columns: ['kosId'],
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return maps[i]['kosId'] as String;
    });
  }

  Future<List<Kos>> getFavoriteKos(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT k.* FROM kos k
      INNER JOIN favorites f ON k.id = f.kosId
      WHERE f.userId = ?
      ORDER BY f.createdAt DESC
    ''',
      [userId],
    );

    return List.generate(maps.length, (i) {
      return Kos.fromJson(maps[i]);
    });
  }

  // Simple favorite methods (without userId for compatibility)
  Future<void> addFavorite(String kosId) async {
    await addToFavorites(kosId, 'default_user');
  }

  Future<void> removeFavorite(String kosId) async {
    await removeFromFavorites(kosId, 'default_user');
  }

  Future<List<String>> getFavorites() async {
    return await getFavoriteKosIds('default_user');
  }

  // Search history operations
  Future<int> addSearchHistory(
    String userId,
    String query,
    String? filters,
  ) async {
    final db = await database;
    return await db.insert('search_history', {
      'userId': userId,
      'query': query,
      'filters': filters,
    });
  }

  Future<List<Map<String, dynamic>>> getSearchHistory(
    String userId, {
    int limit = 10,
  }) async {
    final db = await database;
    return await db.query(
      'search_history',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'createdAt DESC',
      limit: limit,
    );
  }

  Future<int> clearSearchHistory(String userId) async {
    final db = await database;
    return await db.delete(
      'search_history',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }

  // User operations
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<int> updateUser(String userId, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [userId]);
  }

  // Booking operations
  Future<int> insertBooking(Map<String, dynamic> booking) async {
    final db = await database;
    return await db.insert(
      'bookings',
      booking,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUserBookings(String userId) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT b.*, k.name as kosName, k.address as kosAddress, k.images as kosImages
      FROM bookings b
      INNER JOIN kos k ON b.kosId = k.id
      WHERE b.userId = ?
      ORDER BY b.createdAt DESC
    ''',
      [userId],
    );
  }

  Future<int> updateBookingStatus(String bookingId, String status) async {
    final db = await database;
    return await db.update(
      'bookings',
      {'status': status, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [bookingId],
    );
  }

  // Initialize with sample data
  Future<void> initializeSampleData() async {
    final allKos = await getAllKos();
    if (allKos.isEmpty) {
      // Insert sample kos data
      for (final kos in sampleKosData) {
        await insertKos(kos);
      }
    }
  }

  Future<void> closeDatabase() async {
    final db = await database;
    db.close();
  }
}
