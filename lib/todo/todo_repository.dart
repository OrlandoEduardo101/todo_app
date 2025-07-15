import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'todo_model.dart';

class TodoRepository {
  final String _key = 'todos';

  Future<List<Todo>> loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? todosString = prefs.getString(_key);
      if (todosString != null) {
        List<dynamic> todosMap = jsonDecode(todosString);
        return todosMap.map((map) => Todo.fromMap(map)).toList();
      }
      return [];
    } catch (e) {
      // Em caso de erro, retorna lista vazia
      return [];
    }
  }

  Future<void> saveTodos(List<Todo> todos) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String todosString = jsonEncode(todos.map((todo) => todo.toMap()).toList());
      await prefs.setString(_key, todosString);
    } catch (e) {
      // Em caso de erro, logar o erro (opcional)
      // print('Erro ao salvar TODOs: $e');
    }
  }
}
