import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../data/tasks_repository.dart';
import '../domain/task.dart';
import 'edit_task_sheet.dart';

/// Provider for the tasks repository instance.
final tasksRepoProvider =
    Provider<TasksRepository>((ref) => TasksRepository.create());

/// Provider that fetches the list of tasks asynchronously.
final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.read(tasksRepoProvider);
  final res = await repo.list();
  return res.when(ok: (v) => v, err: (f) => Future.error(f.message));
});

/// Page that displays the list of tasks with options to add, edit, and delete tasks.
class TasksPage extends ConsumerWidget {
  /// Creates a TasksPage widget.
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () {
              AuthRepository.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/sign-in', (_) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) => ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (_, i) {
            final t = tasks[i];
            return ListTile(
              leading: Checkbox(
                value: t.completed,
                onChanged: (v) async {
                  final repo = ref.read(tasksRepoProvider);
                  await repo.upsert(t.copyWith(completed: v ?? false));
                  ref.invalidate(tasksProvider);
                },
              ),
              title:
                  Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: t.note == null
                  ? null
                  : Text(t.note!, maxLines: 2, overflow: TextOverflow.ellipsis),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () async {
                  final repo = ref.read(tasksRepoProvider);
                  await repo.delete(t.id);
                  ref.invalidate(tasksProvider);
                },
              ),
              onTap: () => showModalBottomSheet(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                builder: (_) => EditTaskSheet(
                    initial: t,
                    onSaved: () {
                      ref.invalidate(tasksProvider);
                    }),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemCount: tasks.length,
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          builder: (_) => EditTaskSheet(onSaved: () {
            ref.invalidate(tasksProvider);
          }),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
