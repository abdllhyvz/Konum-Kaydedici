import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_Locations');
    var database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  _onCreate(Database database, int version) async {
    await database.execute(
        "CREATE TABLE locations(id INTEGER PRIMARY KEY,lat DOUBLE,lon DOUBLE,name TEXT,note TEXT,now TEXT)");
  }
}
