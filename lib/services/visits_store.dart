import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trailya/model/visit.dart';

class VisitsStore {
  VisitsStore({required this.db});

  static final String visitsTable = 'visits';
  static final int version = 1;
  static VisitsStore? _instance;

  final Database db;

  static Future<VisitsStore> create() async {
    if (_instance != null) {
      return _instance!;
    }

    var path = join(await getDatabasesPath(), 'trailya.db');
    final db = await openDatabase(
      path,
      version: version,
      onCreate: (db, newVersion) async {
        await db.execute('''
        CREATE TABLE $visitsTable (
          id REAL,
          latitude REAL,
          longitude REAL,
          accuracy REAL,
          altitude REAL,
          speed REAL,
          speed_accuracy REAL,
          heading REAL,
          time REAL,
          end_time REAL,
          exposed INTEGER
        )
        ''');
      },
    );

    print('trailya sqlite path: $path/$db');
    _instance = VisitsStore(db: db);
    return _instance!;
  }

  Future<int> persist(Visit visit) async {
    return await db.insert(
      visitsTable,
      visit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> persistAll(List<Visit> visits) async {
    final batch = db.batch();

    visits.forEach((visit) {
      batch.insert(
        visitsTable,
        visit.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });

    final result = await batch.commit(
      continueOnError: true,
    );

    if (result.length != visits.length) {
      throw Exception(
          'Error in batch persist, expected ${visits.length} but persisted only ${result.length}');
    }
  }

  Future<List<Visit>> all() async {
    final List<Map<String, dynamic>> results = await db.query(visitsTable);

    return results.map((data) {
      return Visit.fromMap(data.map((key, value) => MapEntry(key, value ?? 0)));
    }).toList();
  }

  Future<int> deleteBefore(DateTime datetime) async {
    final timestamp = datetime.millisecondsSinceEpoch;
    return await db.delete(
      visitsTable,
      where: 'time <= ?',
      whereArgs: [timestamp],
    );
  }
}
