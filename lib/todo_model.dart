class Todo {
  String title;
  bool isCompleted;

  Todo({required this.title, this.isCompleted = false});

  // Converte um Todo para um Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  // Converte um Map para um Todo
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      isCompleted: map['isCompleted'],
    );
  }
}
