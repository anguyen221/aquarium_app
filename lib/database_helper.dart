import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aquarium.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            fish_count INTEGER,
            fish_speed REAL,
            fish_color TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveSettings(int fishCount, double speed, String color) async {
    final db = await database;
    await db.insert('settings', {
      'fish_count': fishCount,
      'fish_speed': speed,
      'fish_color': color,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> loadSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query('settings', limit: 1);
    return results.isNotEmpty ? results.first : null;
  }
}
