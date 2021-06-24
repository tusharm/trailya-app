import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/site.dart';

class DataBaseHelper {
  static Database? _db;

  final String dbName = 'sites.db';
  final String sitesTable = 'sites';

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), dbName);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE sites (
          id TEXT PRIMARY KEY,
          suburb TEXT,
          name TEXT,
          address TEXT,
          state TEXT,
          postcode TEXT,
          exposure_date TEXT,
          exposure_time_start TEXT,
          exposure_time_end TEXT
        )
        ''');
  }

  // Future<int> persist(Site site) async {
  //   var client = await db;
  //
  //   return await client.insert(
  //     sitesTable,
  //     site.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // Future<List<Site>> sites() async {
  //   final client = await db;
  //
  //   final List<Map<String, dynamic>> maps = await client.query(sitesTable);
  //
  //   return List.generate(
  //     maps.length,
  //     (i) {
  //       return Site(
  //         id: maps[i]['id'],
  //         suburb: maps[i]['suburb'],
  //         name: maps[i]['name'],
  //         address: maps[i]['address'],
  //         state: maps[i]['state'],
  //         postcode: maps[i]['postcode'],
  //         exposureDate: maps[i]['exposure_date'],
  //         exposureStartTime: maps[i]['exposure_time_start'],
  //         exposureEndTime: maps[i]['exposure_time_end'],
  //       );
  //     },
  //   );
  // }
}
