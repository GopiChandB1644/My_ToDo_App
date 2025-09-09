// import 'dart:convert';

// import 'package:flutter_application_3/models/todo_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPreferenceUtils{

//   static const String todoKey = 'todo_list';

//   static Future<void> saveTodos(List<TodoModel> todos) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> jsonList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
//     await prefs.setStringList(todoKey, jsonList);
//   }

//   static Future<List<TodoModel>> getTodos() async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String>? jsonList = prefs.getStringList(todoKey);
//     if (jsonList != null) {
//       return jsonList.map((e) => TodoModel.fromJson(jsonDecode(e))).toList();
//     }
//     return [];
//   }

// }
import 'dart:convert';
import 'package:flutter_application_3/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SharedPreferenceUtils {
  // Generate a unique key per user
  static String _getUserKey() {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? "guest";
    return 'todo_list_$uid';
  }

  static Future<void> saveTodos(List<TodoModel> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    List<String> jsonList = todos
        .map((todo) => jsonEncode(todo.toJson()))
        .toList();
    await prefs.setStringList(key, jsonList);
  }

  static Future<List<TodoModel>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    List<String>? jsonList = prefs.getStringList(key);
    if (jsonList != null) {
      return jsonList.map((e) => TodoModel.fromJson(jsonDecode(e))).toList();
    }
    return [];
  }

  static Future<void> clearTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _getUserKey();
    await prefs.remove(key);
  }
}
