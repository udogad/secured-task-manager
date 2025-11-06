import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/task.dart';
import '../data/tasks_repository.dart';
import 'edit_task_sheet.dart';

/// Provider for the [TasksRepository].
final tasksRepoProvider =
    Provider<TasksRepository>((ref) => TasksRepository.create());

/// Provider for the list of [Task]s.
final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final repo = ref.read(tasksRepoProvider);
  final res = await repo.list();
  return res.when(ok: (v) => v, err: (f) => Future.error(f.message));
});

/// A page that displays the user's tasks.
class DashboardPage extends ConsumerWidget {
  /// Creates a [DashboardPage] widget.
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(tasksProvider);
    final accentInt = ref.watch(accentColorProvider);
    final accent = Color(accentInt);
    final themeMode = ref.watch(themeModeProvider);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('My Tasks'),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(themeModeProvider.notifier).setMode(
                    themeMode == ThemeMode.dark
                        ? ThemeMode.light
                        : ThemeMode.dark);
              },
              icon: Icon(themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode)),
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: const Text('Change Accent'), value: 'accent'),
              PopupMenuItem(child: const Text('Sign Out'), value: 'signout'),
            ],
            onSelected: (v) async {
              if (v == 'signout') {
                await AuthRepository.instance.signOut();
                if (!context.mounted) return;
                context.go('/sign-in');
              } else if (v == 'accent') {
                // quick accent choices:
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          title: const Text('Pick Accent'),
                          content: Wrap(spacing: 12, children: [
                            _AccentChip(Colors.teal, ref),
                            _AccentChip(Colors.indigo, ref),
                            _AccentChip(Colors.deepOrange, ref),
                            _AccentChip(Colors.pink, ref)
                          ]),
                        ));
              }
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          final completed = tasks.where((t) => t.completed).length;
          final total = tasks.length;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [accent.withAlpha((255 * 0.9).round()), accent]),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Progress',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white70)),
                              const SizedBox(height: 8),
                              Text('$completed / $total completed',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                            ]),
                        const Spacer(),
                        SizedBox(
                            width: 72,
                            height: 72,
                            child: CircularProgressIndicator(
                                value: total == 0 ? 0 : completed / total,
                                color: Colors.white,
                                strokeWidth: 6)),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((c, i) {
                final t = tasks[i];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: Checkbox(
                        value: t.completed,
                        onChanged: (v) async {
                          await ref
                              .read(tasksRepoProvider)
                              .upsert(t.copyWith(completed: v ?? false));
                          ref.invalidate(tasksProvider);
                        }),
                    title: Text(t.title,
                        style: TextStyle(
                            decoration: t.completed
                                ? TextDecoration.lineThrough
                                : null)),
                    subtitle: t.note == null
                        ? null
                        : Text(t.note!,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await ref.read(tasksRepoProvider).delete(t.id);
                          ref.invalidate(tasksProvider);
                        }),
                    onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (_) => EditTaskSheet(
                            initial: t,
                            onSaved: () => ref.invalidate(tasksProvider))),
                  ),
                );
              }, childCount: tasks.length)),
            ],
          );
        },
        error: (e, _) => Center(child: Text('Error: $e')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) =>
                EditTaskSheet(onSaved: () => ref.invalidate(tasksProvider))),
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('Add Task'),
      ),
    );
  }
}

/// A chip widget to select an accent color.
class _AccentChip extends StatelessWidget {
  /// The color of the chip.
  final Color color;

  /// The widget reference for Riverpod.
  final WidgetRef ref;

  /// Creates an [_AccentChip] widget.
  const _AccentChip(this.color, this.ref);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      backgroundColor: color,
      label: const SizedBox.shrink(),
      onPressed: () {
        ref.read(accentColorProvider.notifier).setAccent(color);
        Navigator.of(context).pop();
      },
    );
  }
}
