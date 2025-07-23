import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TodoProvider with ChangeNotifier {
  List<Map<String, dynamic>> _tasks = [];

  List<Map<String, dynamic>> get tasks => _tasks;

  TodoProvider() {
    loadTasks();
  }

  void loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getString('tasks');

    if (tasksJson != null) {
      try {
        final decoded = jsonDecode(tasksJson);
        if (decoded is List) {
          _tasks = decoded.map<Map<String, dynamic>>((item) {
            if (item is Map<String, dynamic>) {
              return item;
            } else if (item is Map) {
              return Map<String, dynamic>.from(item);
            } else {
              return {'text': 'Invalid task', 'completed': false};
            }
          }).toList();
          notifyListeners();
        }
      } catch (e) {
        print("Error decoding tasks: $e");
      }
    }
  }

  void saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', jsonEncode(_tasks));
  }

  void addTask(String text) {
    if (text.trim().isEmpty) return;
    _tasks.add({'text': text.trim(), 'completed': false});
    notifyListeners();
    saveTasks();
  }

  void toggleComplete(int index) {
    _tasks[index]['completed'] = !_tasks[index]['completed'];
    notifyListeners();
    saveTasks();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
    saveTasks();
  }
}
