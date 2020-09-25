import 'package:diary_app/model/entry.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider{
  static const String TABLE_ENTRIES = 'entries';
  static const String COLUMN_ID = 'id';
  static const String TIME = 'time';
  static const String SIZE = 'size';
  static const String MESSAGE = 'message';

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'entriesDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating entries table");

        await database.execute(
          "CREATE TABLE $TABLE_ENTRIES ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$TIME TEXT,"
              "$SIZE TEXT,"
              "$MESSAGE TEXT"
              ")",
        );
      },
    );
  }

  Future<List<Entry>> getEntries() async {
    final db = await database;

    var entries = await db
        .query(TABLE_ENTRIES, columns: [COLUMN_ID, TIME, SIZE, MESSAGE]);

    List<Entry> entryList = List<Entry>();

    entries.forEach((currentEntry) {
      Entry entry = Entry.fromMap(currentEntry);

      entryList.add(entry);
    });

    return entryList;
  }

  Future<Entry> insert(Entry entry) async {
    final db = await database;
    entry.id = await db.insert(TABLE_ENTRIES, entry.toMap());
    return entry;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_ENTRIES,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Entry entry) async {
    final db = await database;

    return await db.update(
      TABLE_ENTRIES,
      entry.toMap(),
      where: "id = ?",
      whereArgs: [entry.id],
    );
  }

  }