import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DBService {
  // Properties
  static final DBService instance = DBService._init();
  static Database? _database;

  // Constructor
  DBService._init();

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_data.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Create the database
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
      ) ''';
    await db.execute(userTable);
  }

  // Save user's data in to the Database 
  Future<void> saveUser(Map<String, dynamic> user) async {
    final db = await instance.database;

    // Convert list fields to JSON strings before saving
    user['User_Locations'] = json.encode(user['User_Locations']);
    user['User_Permissions'] = json.encode(user['User_Permissions']);

    // Insert the user data into the users table
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

//use to confirm if data save corectly
/*Future<List<Map<String, dynamic>>> getUsers(dynamic instance) async {
    final db = await instance.database;

    final result = await db.query('users');

    // Decode JSON strings back to lists for User_Locations and User_Permissions
    return result.map((user) {
      user['User_Locations'] = json.decode(user['User_Locations']);
      user['User_Permissions'] = json.decode(user['User_Permissions']);
      return user;
    }).toList();
  }*/