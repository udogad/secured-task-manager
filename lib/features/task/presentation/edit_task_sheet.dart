import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:secure_task_manager/features/task/domain/task.dart' show Task;
import 'package:secure_task_manager/features/task/presentation/dashboard_page.dart'
    show tasksRepoProvider;
import 'package:uuid/uuid.dart';
import 'dart:developer' as developer;

/// A sheet for creating or editing a task.
class EditTaskSheet extends ConsumerStatefulWidget {
  /// The initial task to edit. If null, a new task will be created.
  final Task? initial;

  /// Called when the task is saved.
  final VoidCallback? onSaved;

  /// Creates a new [EditTaskSheet].
  const EditTaskSheet({super.key, this.initial, this.onSaved});

  /// Creates the mutable state for this widget.
  @override
  ConsumerState<EditTaskSheet> createState() => _EditTaskSheetState();
}

class _EditTaskSheetState extends ConsumerState<EditTaskSheet> {
  final _title = TextEditingController();
  final _note = TextEditingController();
  DateTime? _dueAt;

  @override
  void initState() {
    super.initState();
    final t = widget.initial;
    if (t != null) {
      _title.text = t.title;
      _note.text = t.note ?? '';
      _dueAt = t.dueAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(widget.initial == null ? 'New Task' : 'Edit Task',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Title'),
            maxLength: 100,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 4,
            maxLength: 1000,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                  _dueAt == null ? 'No due date' : 'Due: ${_dueAt!.toLocal()}'),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: now.subtract(const Duration(days: 1)),
                    lastDate: now.add(const Duration(days: 365 * 3)),
                    initialDate: _dueAt ?? now,
                  );
                  if (!context.mounted) return;
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dueAt ?? now),
                    );
                    if (!context.mounted) return;
                    if (pickedTime != null) {
                      setState(() {
                        _dueAt = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    } else {
                      setState(() => _dueAt = pickedDate);
                    }
                  }
                },
                child: const Text('Set due'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              final title = _title.text.trim();
              if (title.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title required')));
                return;
              }
              final repo = ref.read(tasksRepoProvider);
              final now = DateTime.now();
              final t = widget.initial ??
                  Task(
                      id: const Uuid().v4(),
                      title: title,
                      note:
                          _note.text.trim().isEmpty ? null : _note.text.trim(),
                      createdAt: now,
                      dueAt: _dueAt);
              final updated = t.copyWith(
                title: title,
                note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                dueAt: _dueAt,
              );
              final res = await repo.upsert(updated);
              developer.log('Saving task with ID: ${updated.id}');
              if (!context.mounted) return;
              res.when(
                ok: (_) {
                  widget.onSaved?.call();
                  Navigator.pop(context);
                },
                err: (f) => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(f.message))),
              );
            },
            child: const Text('Save'),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
