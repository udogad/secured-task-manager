/// Represents a task.
class Task {
  /// The unique identifier of the task.
  final String id;

  /// The title of the task.
  final String title;

  /// The note of the task.
  final String? note;

  /// The date and time when the task was created.
  final DateTime createdAt;

  /// The date and time when the task is due.
  final DateTime? dueAt;

  /// Whether the task is completed.
  final bool completed;

  /// Creates a [Task] object.
  const Task({
    required this.id,
    required this.title,
    this.note,
    required this.createdAt,
    this.dueAt,
    this.completed = false,
  });

  /// Creates a copy of this task but with the given fields replaced with the new values.
  Task copyWith({
    String? title,
    String? note,
    DateTime? createdAt,
    DateTime? dueAt,
    bool? completed,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        note: note ?? this.note,
        createdAt: createdAt ?? this.createdAt,
        dueAt: dueAt ?? this.dueAt,
        completed: completed ?? this.completed,
      );

  /// Creates a map from this task.
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
        'dueAt': dueAt?.toIso8601String(),
        'completed': completed,
      };

  /// Creates a [Task] from a map of key-value pairs.
  factory Task.fromJson(Map<String, dynamic> m) => Task(
        id: m['id'] as String,
        title: m['title'] as String,
        note: m['note'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
        dueAt: m['dueAt'] != null ? DateTime.parse(m['dueAt'] as String) : null,
        completed: m['completed'] as bool? ?? false,
      );
}
