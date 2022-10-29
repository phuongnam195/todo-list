import 'package:todo_list/database/task_database.dart';
import 'package:todo_list/dummy_data.dart';
import 'package:todo_list/model/task.dart';
import 'package:todo_list/util/string_utils.dart';

abstract class ITaskRepository {
  Future<void> init();
  Future<void> close();
  Future<List<Task>> getAll();
  Future<List<Task>> getAllBySearch(String keyword);
  Future<Task?> getById(int id);
  Future<Task?> addTask(Task task);
  Future<bool> updateTask(Task task);
  Future<bool> deleteTask(int id);
}

class TaskRepository implements ITaskRepository {
  static final TaskRepository _singleton = TaskRepository._internal();
  factory TaskRepository() {
    return _singleton;
  }
  TaskRepository._internal();

  late final TaskDatabase _appDB;

  @override
  Future<void> init() async {
    _appDB = TaskDatabase();
    await _appDB.open();
  }

  @override
  Future<void> close() async {
    await _appDB.close();
  }

  @override
  Future<Task?> addTask(Task task) async {
    final savedTask = await _appDB.insert(task);
    return savedTask;

    task = task.copyWith(
        id: DateTime.now().millisecondsSinceEpoch % 100,
        completedDate: task.completedDate);
    DUMMY_TASKS.add(task);
    return task;
  }

  @override
  Future<bool> deleteTask(int id) async {
    return (await _appDB.delete(id)) == 1;

    int oldCount = DUMMY_TASKS.length;
    DUMMY_TASKS.removeWhere((task) => task.id == id);
    return DUMMY_TASKS.length != oldCount;
  }

  @override
  Future<List<Task>> getAll() async {
    return await _appDB.getList();
    return DUMMY_TASKS;
  }

  @override
  Future<List<Task>> getAllBySearch(String keyword) async {
    final all = await getAll();
    return all.where((e) => e.title.containsIgnoreCase(keyword)).toList();
    return DUMMY_TASKS
        .where((e) => e.title.containsIgnoreCase(keyword))
        .toList();
  }

  @override
  Future<Task?> getById(int id) async {
    return await _appDB.get(id);
    return DUMMY_TASKS.firstWhere((e) => e.id == id);
  }

  @override
  Future<bool> updateTask(Task task) async {
    return (await _appDB.update(task)) == 1;
    int index = DUMMY_TASKS.indexWhere((e) => e.id == task.id);
    DUMMY_TASKS[index] = task;
    return true;
  }
}
