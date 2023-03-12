import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_sqlcipher/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'database.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE itemTable(id TEXT PRIMARY KEY, title TEXT, description TEXT, price REAL, image TEXT, extra TEXT)');
    }, version: 1);
  }

  static Future<void> insert(Map<String, Object> data) async {
    final db = await DbHelper.database();
    db.insert(
      "itemTable",
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await DbHelper.database();

    return db.query('itemTable');
  }

  static Future delete(String id) async {
    final db = await DbHelper.database();
    db.delete(
      "itemTable",
      where: 'id = ? ',
      whereArgs: [id],
    );
  }

  static Future update(Map<String, dynamic> data, String id) async {
    final db = await DbHelper.database();
    db.update("itemTable", data, where: 'id = ?', whereArgs: [id]);
  }
}
