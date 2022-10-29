import 'package:sqflite/sqflite.dart';
import 'package:todo_list/model/task.dart';

const tableTask = 'task';
const columnId = 'id';
const columnTitle = 'title';
const columnIsCompleted = 'isCompleted';
const columnCreatedDate = 'createdDate';
const columnDateTime = 'dateTime';
const columnCompletedDate = 'completedDate';

class TaskDatabase {
  static const _name = 'todo_app.db';
  Database? _database;

  Future<Database> get database async {
    if (_database == null) await open();
    return _database!;
  }

  Future open() async {
    _database =
        await openDatabase(_name, version: 1, onCreate: (db, version) async {
      await db.execute('''
create table $tableTask (
  $columnId integer primary key autoincrement, 
  $columnTitle text not null,
  $columnIsCompleted integer not null,
  $columnCreatedDate text not null,
  $columnDateTime text,
  $columnCompletedDate text)
''');
    });
  }

  Future<Task?> insert(Task task) async {
    final db = await database;
    final maps = await db.query(tableTask,
        columns: [columnId, columnTitle, columnDateTime],
        where: '$columnTitle = ? and $columnDateTime = ?',
        whereArgs: [
          task.title,
          task.dateTime.toIso8601String(),
        ]);

    if (maps.isNotEmpty) return null;

    int id = await db.insert(
        tableTask,
        task.toJson()
          ..remove('id')
          ..update(columnIsCompleted, (val) => val ? 1 : 0));
    if (id == 0) return null;

    return task.copyWith(id: id, completedDate: task.completedDate);
  }

  Future<Task?> get(int id) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableTask,
        columns: [
          columnId,
          columnTitle,
          columnIsCompleted,
          columnCreatedDate,
          columnDateTime,
          columnCompletedDate,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      Map<String, dynamic> writeMap = Map.from(maps.first);
      return Task.fromJson(
          writeMap..update(columnIsCompleted, (val) => val == 1));
    }
    return null;
  }

  Future<List<Task>> getList(
      {bool? completed, String? where, List<Object?>? whereArgs}) async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableTask,
      columns: [
        columnId,
        columnTitle,
        columnIsCompleted,
        columnCreatedDate,
        columnDateTime,
        columnCompletedDate,
      ],
      where: where ?? (completed != null ? '$columnIsCompleted = ?' : null),
      whereArgs: whereArgs ?? (completed != null ? [completed ? 1 : 0] : null),
    );

    return maps.map((map) {
      Map<String, dynamic> writeMap = Map.from(map);
      return Task.fromJson(
          writeMap..update(columnIsCompleted, (val) => val == 1));
    }).toList();
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(tableTask, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Task task) async {
    final db = await database;
    return await db.update(tableTask,
        task.toJson()..update(columnIsCompleted, (val) => val ? 1 : 0),
        where: '$columnId = ?', whereArgs: [task.id]);
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
