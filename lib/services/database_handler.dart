import 'package:konsul/models/notification.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  final String tbName = "x_notf";

  static final DatabaseHandler dbHandler = DatabaseHandler._initDB();

  DatabaseHandler._initDB();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase("xom.db");

    return _database!;
  }

  Future<Database> _initDatabase(String dbName) async {
    String dbPath = await getDatabasesPath();
    String fpath = "$dbPath/$dbName";

    // open the database
    Database database = await openDatabase(fpath, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE $tbName (id INTEGER PRIMARY KEY, title VARCHAR, subtitle VARCHAR, new INTEGER, date DATETIME )');
    });

    return database;
  }

  Future<List<Map<String, dynamic>>> getNotifications(
      [bool read = false]) async {
    Database db = await database;

    return await db.rawQuery("SELECT * FROM $tbName ORDER BY date DESC");
  }

  Future<bool> insertNotification(Notification notification) async {
    Database db = await database;

    int id = await db.insert(tbName, notification.toJSON());

    return id == 0 ? false : true;
  }

  Future<bool> updateNotifications(Map<String, dynamic> values) async {
    Database db = await database;

    int id = await db.update(tbName, values);

    return id == 0 ? false : true;
  }

  Future<bool> deleteNotification(int notifId) async {
    Database db = await database;

    int id = await db.delete(tbName, where: "id = ?", whereArgs: [notifId]);

    return id == 0 ? false : true;
  }

  Future<bool> deleteAllNotifications() async {
    Database db = await database;

    int id = await db.delete(tbName);

    return id == 0 ? false : true;
  }

  Future<int> countUnreadNotif() async {
    Database db = await database;

    var result = await db.rawQuery("SELECT * FROM $tbName WHERE new = ?", [1]);

    return result.length;
  }
}
