import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:moodle_test/Model/model.dart';
import 'package:sqflite/sqflite.dart';

class LessonDatabaseProvider {
  LessonDatabaseProvider._();

  static final LessonDatabaseProvider db = LessonDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "lesson.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Lesson ("
         "id TEXT primary key,"
         "userid TEXT,"
         "title TEXT"
          ")"
      );
      await db.execute("CREATE TABLE LessonDetail ("
         "id INTEGER primary key autoincrement,"
         "lessonid TEXT,"
         "title TEXT,"
         "content TEXT,"
         "FOREIGN KEY(lessonid) REFERENCES Lesson(id)"
          ")"
      );
    });

  }

  addLessonToDatabase(LessonDownload lessondownload) async {
    final db = await database;
    var raw = await db.insert(
      "Lesson",
      lessondownload.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  addLessonDetailToDatabase(LessonDetailDownload lessondetaildownload) async {
    final db = await database;
    var raw = await db.insert(
      "LessonDetail",
      lessondetaildownload.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  Future<List<LessonDownload>> getLessonWithUserId(String id) async {
    final db = await database;
    var response = await db.query("Lesson", where: "userid = ?", whereArgs: [id]);
    List<LessonDownload> list = response.map((c) => LessonDownload.fromMap(c)).toList();
    return list;
  }

  Future<List<LessonDetailDownload>> getLessonWithUserIdandId(String id,String lessonid) async {
    final db = await database;
    var response = await db.query("Lesson", where: "userid = ? AND id = ?", whereArgs: [id,lessonid]);
    List<LessonDetailDownload> list = response.map((c) => LessonDetailDownload.fromMap(c)).toList();
    return list;
  }

  Future<List<LessonDetailDownload>> getLessonDeatailWithId(String id) async {
    final db = await database;
    var response = await db.query("LessonDetail", where: "lessonid = ?", whereArgs: [id]);
    List<LessonDetailDownload> list = response.map((c) => LessonDetailDownload.fromMap(c)).toList();
    return list;
  }

  Future<List<LessonDownload>> getAllDownloadLesson() async {
    final db = await database;
    var response = await db.query("Lesson");
    List<LessonDownload> list = response.map((c) => LessonDownload.fromMap(c)).toList();
    return list;
  }

  Future<List<LessonDetailDownload>> getAllDownloadLessonDetail() async {
    final db = await database;
    var response = await db.query("LessonDetail");
    List<LessonDetailDownload> listdetail = response.map((c) => LessonDetailDownload.fromMap(c)).toList();
    return listdetail;
  }

  deleteLessonWithId(String id) async {
    final db = await database;
    return db.delete("Lesson", where: "id = ?", whereArgs: [id]);
  }

  deleteLessonDetailWithId(String id) async {
    final db = await database;
    return db.delete("LessonDetail", where: "lessonid = ?", whereArgs: [id]);
  }

  deleteAllDownloadLesson() async {
    final db = await database;
    db.delete("Lesson");
  }

  deleteTable() async {
    final db = await database;
    db.execute("DROP TABLE IF EXISTS LessonDetail");
  }
}