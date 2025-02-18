import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/todo_model.dart';
import 'package:todo_app/todo_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart'; // Importe as traduções geradas

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoRepository _repository = TodoRepository();
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();

  void _changeLanguage(Locale locale) {
    changeLocale(locale);
  }

  final String picpayUrl = "https://picpay.me/orlandoeduardo.pereira/5";

  void _openPicPay() async {
    final Uri url = Uri.parse(picpayUrl);
    var bool = await canLaunchUrl(url);
    if (bool) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Não foi possível abrir o link");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.appTitle ?? ''),
        actions: [
          PopupMenuButton<Locale>(
            onSelected: _changeLanguage,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: const Locale('en'),
                  child: Text(AppLocalizations.of(context)!.english),
                ),
                PopupMenuItem(
                  value: const Locale('es'),
                  child: Text(localizations!.spanish),
                ),
                PopupMenuItem(
                  value: const Locale('pt'),
                  child: Text(AppLocalizations.of(context)!.portuguese),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.addTaskHint,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addTodo(_textController.text);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      _toggleTodoCompletion(index);
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteTodo(index);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openPicPay,
        icon: const Icon(Icons.coffee),
        label: Text(localizations?.buy_me_a_coffee ?? ''),
      ),
    );
  }

  void _addTodo(String title) {
    setState(() {
      _todos.add(Todo(title: title));
    });
    _repository.saveTodos(_todos);
  }

  void _toggleTodoCompletion(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
    _repository.saveTodos(_todos);
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _repository.saveTodos(_todos);
  }
}
