import 'package:secure_task_manager/core/utils/results.dart' show Result;
import 'package:secure_task_manager/features/task/domain/task.dart' show Task;
import 'package:secure_task_manager/features/task/data/firebase_tasks_adapter.dart';

import '../../auth/data/auth_repository.dart';

/// An abstract class that defines the interface for a tasks repository.
abstract class TasksRepository {
  /// Returns a list of all tasks.
  Future<Result<List<Task>>> list();

  /// Creates or updates a task.
  Future<Result<Task>> upsert(Task task);

  /// Deletes a task by its ID.
  Future<Result<void>> delete(String id);

  /// Creates a new instance of the [TasksRepository].
  static TasksRepository create() => FirebaseTasksAdapter(AuthRepository.instance);
}
