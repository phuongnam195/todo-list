// ignore_for_file: non_constant_identifier_names

import 'package:todo_list/model/task.dart';
import 'package:todo_list/util/date_time_utils.dart';

List<Task> DUMMY_TASKS = [
  Task(
    id: 1,
    title: 'Buy milk',
    isCompleted: false,
    createdDate: DateTime.now(),
    dateTime: DateTimeUtils.tomorrow(),
  ),
  Task(
    id: 2,
    title: 'Sell shirt',
    isCompleted: true,
    createdDate: DateTime.now(),
    dateTime: DateTimeUtils.today(),
    completedDate: DateTime.now().subtract(const Duration(hours: 13)),
  ),
  Task(
    id: 3,
    title: 'Go to gym',
    createdDate: DateTime.now(),
    dateTime: DateTimeUtils.today(),
  ),
  Task(
    id: 4,
    title: 'Hang out with friends',
    createdDate: DateTime.now(),
    dateTime: DateTimeUtils.tomorrow(),
  ),
];
