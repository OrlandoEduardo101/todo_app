import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/todo/todo_model.dart';
import 'package:todo_app/todo/todo_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TodoRepository _repository = TodoRepository();
  final List<Todo> _todos = [];
  final TextEditingController _textController = TextEditingController();
  String _selectedCategory = "General";
  String _selectedPriority = "Medium";

  void _changeLanguage(Locale locale) {
    changeLocale(locale);
  }

  final String picpayUrl = "https://picpay.me/orlandoeduardo.pereira/5";

  void _openPicPay() async {
    final Uri url = Uri.parse(picpayUrl);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Não foi possível abrir o link");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await _repository.loadTodos();
    setState(() {
      _todos.clear();
      _todos.addAll(todos);
    });
  }

  void _showAddTaskDialog() {
    String localCategory = _selectedCategory;
    String localPriority = _selectedPriority;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(localizations!.addTask),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: localizations.addTaskHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          value: localCategory,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              localCategory = newValue ?? localizations.general;
                            });
                          },
                          items: [
                            localizations.general,
                            localizations.work,
                            localizations.personal,
                            localizations.shopping,
                          ].map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButton<String>(
                          value: localPriority,
                          isExpanded: true,
                          onChanged: (String? newValue) {
                            setDialogState(() {
                              localPriority = newValue ?? localizations.medium;
                            });
                          },
                          items: [
                            localizations.low,
                            localizations.medium,
                            localizations.high,
                          ].map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(localizations.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _addTodo(_textController.text, localCategory, localPriority);
                      _textController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(localizations.add),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteConfirmation(int index) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations!.delete),
          content: Text('${localizations.delete} "${_todos[index].title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteTodo(index);
                Navigator.pop(context);
              },
              child: Text(localizations.delete),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Inicializar valores padrão apenas uma vez
    if (_selectedCategory == "General") {
      _selectedCategory = localizations?.general ?? "General";
    }
    if (_selectedPriority == "Medium") {
      _selectedPriority = localizations?.medium ?? "Medium";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.appTitle ?? ''),
        actions: [
          IconButton(
            icon: Icon(themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: themeNotifier.toggleTheme,
          ),
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
      body: _todos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt,
                    size: 64,
                    color: Theme.of(context).disabledColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    localizations?.addTaskHint ?? 'No tasks yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).disabledColor,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
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
                  subtitle: Text(
                    "${localizations?.category}: ${todo.category}, ${localizations?.priority}: ${todo.priority}",
                  ),
                  leading: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (value) {
                      _toggleTodoCompletion(index);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteConfirmation(index);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _showAddTaskDialog,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.extended(
            onPressed: _openPicPay,
            icon: const Icon(Icons.coffee),
            label: Text(localizations?.buy_me_a_coffee ?? ''),
          ),
        ],
      ),
    );
  }

  void _addTodo(String title, String category, String priority) {
    setState(() {
      _todos.add(Todo(
        title: title,
        category: category,
        priority: priority,
      ));
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
