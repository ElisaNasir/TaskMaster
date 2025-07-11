import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoListApp extends StatefulWidget {
  @override
  _TodoListAppState createState() => _TodoListAppState();
}

class _TodoListAppState extends State<TodoListApp> {
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      try {
        final decoded = jsonDecode(tasksJson);
        if (decoded is List) {
          setState(() {
            _tasks = decoded.map<Map<String, dynamic>>((item) {
              if (item is Map<String, dynamic>) {
                return item;
              } else if (item is Map) {
                return Map<String, dynamic>.from(item);
              } else {
                return {'text': 'Invalid task', 'completed': false};
              }
            }).toList();
          });
        } else {
          print("Decoded data is not a List: ${decoded.runtimeType}");
        }
      } catch (e) {
        print("Error decoding tasks: $e");
      }
    }
  }

  void _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  void _addTask(String taskText) {
    if (taskText.trim().isEmpty) return;
    setState(() {
      _tasks.add({'text': taskText.trim(), 'completed': false});
    });
    _saveTasks();
  }

  void _toggleComplete(int index) {
    setState(() {
      _tasks[index]['completed'] = !(_tasks[index]['completed'] as bool);
    });
    _saveTasks();
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks();
  }

  void _showAddTaskDialog() {
    final TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text("New Task", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter task",
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.redAccent)),
          ),
          ElevatedButton(
            onPressed: () {
              _addTask(_controller.text);
              Navigator.pop(context);
              _controller.dispose();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text("Add"),
          ),
        ],
      ),
    ).then((_) => _controller.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("To-Do List"),
        backgroundColor: Colors.red.shade900,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTaskDialog,
            tooltip: "Add Task",
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.red.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _tasks.isEmpty
            ? Center(
          child: Text(
            "No tasks yet. Tap + to add one.",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        )
            : ListView.builder(
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            final task = _tasks[index];
            final bool isCompleted = task['completed'] as bool;
            final String taskText = task['text'] as String;

            return ListTile(
              leading: Checkbox(
                value: isCompleted,
                onChanged: (_) => _toggleComplete(index),
                activeColor: Colors.redAccent,
                checkColor: Colors.black,
              ),
              title: Text(
                taskText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => _removeTask(index),
              ),
            );
          },
        ),
      ),
    );
  }
}
