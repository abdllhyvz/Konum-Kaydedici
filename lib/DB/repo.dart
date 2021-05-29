import 'package:project/DB/db_connection.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DBConnection dbConnection;

  Repository() {
    dbConnection = DBConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await dbConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  deleteData(table, itemId) async {
    var connection = await database;
    return await connection.rawDelete("DELETE FROM $table WHERE id = $itemId");
  }
}
