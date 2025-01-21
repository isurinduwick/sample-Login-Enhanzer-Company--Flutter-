import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBService {
  static final DBService instance = DBService._init();
  static Database? _database;

  DBService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY,
        userCode TEXT,
        displayName TEXT,
        email TEXT
      )
    '''
    );
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    await db.insert('user', user);
  }

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await instance.database;
    return await db.query('user');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
