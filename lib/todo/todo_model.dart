class Todo {
  String title;
  bool isCompleted;
  String category;
  String priority; // "Low", "Medium", "High"

  Todo({
    required this.title,
    this.isCompleted = false,
    this.category = "General",
    this.priority = "Medium",
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'category': category,
      'priority': priority,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      isCompleted: map['isCompleted'],
      category: map['category'],
      priority: map['priority'],
    );
  }
}
