import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trailya/model/user_config.dart';

class ConfigStore {
  ConfigStore({required this.db});

  static final String configTable = 'config';
  static final int version = 1;
  static ConfigStore? _instance;

  static Future<ConfigStore> create() async {
    if (_instance != null) {
      return _instance!;
    }

    var path = join(await getDatabasesPath(), 'config.db');
    final db = await openDatabase(
      path,
      version: version,
      onCreate: (db, newVersion) async {
        await db.execute('''
        CREATE TABLE $configTable (
          id TEXT PRIMARY KEY,
          location TEXT,
          enable_crash_report INTEGER
        )
        ''');
      },
    );

    _instance = ConfigStore(db: db);
    return _instance!;
  }

  final Database db;

  Future<UserConfig> get(User user) async {
    final results =
        await db.query(configTable, where: 'id = ?', whereArgs: [user.uid]);

    if (results.isNotEmpty) {
      return UserConfig.fromMap(results.first);
    }

    final userConfig = UserConfig(id: user.uid);
    await save(userConfig);
    return userConfig;
  }

  Future<int> save(UserConfig config) async {
    return await db.insert(
      configTable,
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
