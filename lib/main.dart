import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/task_dao.dart';

import 'data/task.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'To-Do UMB', home: TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
  final taskDao = TaskDao();
}

class _TodoListState extends State<TodoList> {
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _subjectFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _canSendMessage() => _titleFieldController.text.isNotEmpty;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do UMB'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [_getMessageList()],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayDialog(context),
        tooltip: 'Add Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTodoItem(String title, String subject) {
    if (_canSendMessage()) {
      setState(() {
        final dateTime = DateTime.now();
        final date = '${dateTime.year}/${dateTime.month}/${dateTime.day}';
        final task = Task(title, date, subject);
        widget.taskDao.saveTask(task);
      });
      _titleFieldController.clear();
      _subjectFieldController.clear();
    }
  }

  //Generate a single item widget
  Future<Future> _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add a task'),
            content: Column(
              children: [
                TextField(
                  controller: _titleFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Enter task here'),
                ),
                TextField(
                  controller: _subjectFieldController,
                  decoration:
                      const InputDecoration(hintText: 'Enter subject here'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ADD'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _addTodoItem(
                      _titleFieldController.text, _subjectFieldController.text);
                },
              ),
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: _scrollController,
        query: widget.taskDao.getMessageQuery(),
        itemBuilder: (context, snapshot, animation, index) {
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = Task.fromJson(json);
          return Card(
            child: ListTile(
              title: Text(message.title),
              subtitle:
                  Text('Subject: ${message.subject} - Date: ${message.date}'),
            ),
          );
        },
      ),
    );
  }
}
