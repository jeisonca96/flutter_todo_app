import 'package:firebase_database/firebase_database.dart';

import 'task.dart';

class TaskDao {
  final DatabaseReference _taskRef =
      FirebaseDatabase.instance.reference().child('tasks');

  void saveTask(Task task) {
    _taskRef.push().set(task.toJson());
  }

  Query getMessageQuery() {
    return _taskRef;
  }
}
