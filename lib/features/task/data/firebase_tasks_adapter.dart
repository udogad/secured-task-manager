import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secure_task_manager/core/errors/failure.dart';
import 'package:secure_task_manager/core/utils/results.dart';
import 'package:secure_task_manager/features/auth/data/auth_repository.dart';
import 'package:secure_task_manager/features/task/domain/task.dart';
import 'package:secure_task_manager/features/task/data/tasks_repository.dart';
import 'dart:developer' as developer;

/// A concrete implementation of [TasksRepository] that uses Firebase Firestore.
class FirebaseTasksAdapter implements TasksRepository {
  final AuthRepository _authRepository;
  final FirebaseFirestore _firestore;

  /// Creates a [FirebaseTasksAdapter] instance.
  FirebaseTasksAdapter(this._authRepository, {FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<List<Task>>> list() async {
    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        return Err(Failure('User not authenticated', code: 'auth/unauthenticated'));
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(user.id)
          .collection('tasks')
          .get();

      final tasks = snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
      return Ok(tasks);
    } catch (e) {
      return Err(Failure(e.toString(), code: 'firestore/list_error'));
    }
  }

  @override
  Future<Result<Task>> upsert(Task task) async {
    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        return Err(Failure('User not authenticated', code: 'auth/unauthenticated'));
      }
      developer.log('Upserting task with ID: ${task.id}');
      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('tasks')
          .doc(task.id)
          .set(task.toJson());

      return Ok(task);
    } catch (e) {
      return Err(Failure(e.toString(), code: 'firestore/upsert_error'));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final user = _authRepository.currentUser;
      if (user == null) {
        return Err(Failure('User not authenticated', code: 'auth/unauthenticated'));
      }

      await _firestore
          .collection('users')
          .doc(user.id)
          .collection('tasks')
          .doc(id)
          .delete();

      return Ok(null);
    } catch (e) {
      return Err(Failure(e.toString(), code: 'firestore/delete_error'));
    }
  }
}
