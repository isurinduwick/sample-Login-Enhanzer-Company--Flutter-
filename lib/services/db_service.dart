import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DBService {
  static final DBService instance = DBService._init();
  static Database? _database;

  DBService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_data.db');
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

  Future<void> _createDB(Database db, int version) async {
    const userTable = '''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userCode TEXT,
        displayName TEXT,
        email TEXT,
        User_Employee_Code TEXT,
        Company_Code TEXT,
        User_Locations TEXT,
        User_Permissions TEXT
      )
    ''';

    await db.execute(userTable);
  }

  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await instance.database;

    // Ensure arrays are saved as JSON strings
    user['User_Locations'] = json.encode(user['User_Locations']);
    user['User_Permissions'] = json.encode(user['User_Permissions']);

    // Insert data into the users table
    await db.insert(
      'users',
      {
        'userCode': user['userCode'],
        'displayName': user['displayName'],
        'email': user['email'],
        'User_Employee_Code': user['User_Employee_Code'],
        'Company_Code': user['Company_Code'],
        'User_Locations': user['User_Locations'],
        'User_Permissions': user['User_Permissions'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
