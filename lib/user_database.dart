import 'package:bcrypt/bcrypt.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class UserDatabase {
  UserDatabase._();

  static final UserDatabase instance = UserDatabase._();
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasePath = await getDatabasesPath();
    _database = await openDatabase(
      path.join(databasePath, 'e_commerce_users.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            full_name TEXT NOT NULL,
            phone TEXT NOT NULL,
            username TEXT NOT NULL COLLATE NOCASE UNIQUE,
            password_hash TEXT NOT NULL,
            photo_path TEXT
          )
        ''');
      },
    );
    return _database!;
  }

  Future<Map<String, dynamic>?> createUser({
    required String fullName,
    required String phone,
    required String username,
    required String password,
  }) async {
    final db = await database;
    try {
      final userId = await db.insert('users', {
        'full_name': fullName.trim(),
        'phone': phone.trim(),
        'username': username.trim(),
        'password_hash': BCrypt.hashpw(password, BCrypt.gensalt()),
      });
      return getUserById(userId);
    } on DatabaseException catch (error) {
      if (error.isUniqueConstraintError()) {
        return null;
      }
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> authenticate({
    required String username,
    required String password,
  }) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username.trim()],
      limit: 1,
    );
    if (users.isEmpty) {
      return null;
    }

    final user = users.first;
    final passwordHash = user['password_hash'] as String;
    if (!BCrypt.checkpw(password, passwordHash)) {
      return null;
    }
    return user;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    final db = await database;
    final users = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return users.isEmpty ? null : users.first;
  }

  Future<void> updatePhotoPath(int id, String photoPath) async {
    final db = await database;
    await db.update(
      'users',
      {'photo_path': photoPath},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
