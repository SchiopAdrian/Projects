import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:mobile_ui/model/mail.dart';
import 'package:mobile_ui/model/task.dart';

class DatabaseHelper {
  final _storage = FlutterSecureStorage();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
  String path = join(await getDatabasesPath(), 'calendar_database.db');
  return await openDatabase(
    path,
    version: 1,  // Increment this version number each time you change the schema
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE mails(id TEXT PRIMARY KEY, subject TEXT, content TEXT, userEmail TEXT, userPassword TEXT, \"to\" TEXT, backgroundColor INTEGER, dateAndTimeSend TEXT, cc TEXT, bcc TEXT, dateAndTimeReminder TEXT, isSynced INTEGER, isDelete INTEGER, idUser STRING, isUpdated INTEGER)",
      );
      await db.execute(
        "CREATE TABLE events(id TEXT PRIMARY KEY, title TEXT, description TEXT, \"from\" TEXT, \"to\" TEXT, backgroundColor INTEGER,isSynced INTEGER, isDelete INTEGER, idUser STRING, isUpdated INTEGER)",
      );
    },
  );
}

  // Mail operations
  Future<void> insertMail(Mail mail) async {
    
    final db = await database;
    
    await db.insert(
      'mails',
      mail.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    
  }

  Future<List<Mail>> mails() async {
    final id = await _storage.read(key: "userId");
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('mails', where: 'isDelete = ? and idUser = ?', whereArgs: [0, id]);
    return List.generate(maps.length, (i) {
      return Mail.fromMap(maps[i]);
    });
  }

  Future<void> updateMail(Mail mail) async {
    final db = await database;
    await db.update(
      'mails',
      mail.toMap(),
      where: "id = ?",
      whereArgs: [mail.id],
    );
  }

  Future<void> deleteMail(String id) async {
    final db = await database;
    await db.delete(
      'mails',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  // Event operations
  Future<void> insertEvent(Task event) async {
    final db = await database;
    await db.insert(
      'events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> tasks() async {
    final db = await database;
    final id = await _storage.read(key: "userId");
    final List<Map<String, dynamic>> maps = await db.query(
      'events',
      where: 'isDelete = ? and idUser = ?',
      whereArgs: [0, id]);
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> clearAllData() async {
  final db = await _initDatabase();
  await db.delete('events');
  await db.delete('mails');
  }

  Future<void> updateTasks(Task event) async {
    final db = await database;
    await db.update(
      'events',
      event.toMap(),
      where: "id = ?",
      whereArgs: [event.id],
    );
  }

  Future<void> deleteTasks(String id) async {
    final db = await database;
    await db.delete(
      'events',
      where: "id = ?",
      whereArgs: [id],
    );
  }

   Future<List<Task>> getUnsyncedTasks() async {
    final db = await database;
    final result = await db.query('events', where: 'isSynced = ?', whereArgs: [0]);
    final res = result.map((e) => Task.fromMap(e)).toList();
    return result.map((e) => Task.fromMap(e)).toList();
  }

   Future<List<Task>> getUpdatedTasks() async {
    final db = await database;
    final result = await db.query('events', where: 'isUpdated = ?', whereArgs: [1]);
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<List<Task>> getDeletedTasks() async {
    final db = await database;
    final result = await db.query('events', where: 'isDelete = ?', whereArgs: [1]);
    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<void> markTaskAsSynced(String id) async {
    final db = await database;
    await db.update('events', {'isSynced': 1}, where: 'id = ?', whereArgs: [id]);
  }
  Future<void> markTaskAsUpdated(String id) async {
    final db = await database;
    await db.update('events', {'isUpdated': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markTaskAsDeleted(String id) async {
    final db = await database;
    await db.update('events', {'isDelete': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Mail>> getUnsyncedMails() async {
    final db = await database;
    final result = await db.query('mails', where: 'isSynced = ?', whereArgs: [0]);
    return result.map((e) => Mail.fromMap(e)).toList();
  }

   Future<List<Mail>> getUpdatedMails() async {
    final db = await database;
    final result = await db.query('mails', where: 'isUpdated = ?', whereArgs: [1]);
    return result.map((e) => Mail.fromMap(e)).toList();
  }

  Future<List<Mail>> getDeletedMails() async {
    final db = await database;
    final result = await db.query('mails', where: 'isDelete = ?', whereArgs: [1]);
    return result.map((e) => Mail.fromMap(e)).toList();
  }

  Future<void> markMailsAsSynced(String id) async {
    final db = await database;
    await db.update('mails', {'isSynced': 1}, where: 'id = ?', whereArgs: [id]);
  }
  Future<void> markMailAsUpdated(String id) async {
    final db = await database;
    await db.update('mails', {'isUpdated': 1}, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markMailAsDeleted(String id) async {
    final db = await database;
    await db.update('mails', {'isDelete': 1}, where: 'id = ?', whereArgs: [id]);
  }
}
