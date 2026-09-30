import 'package:flutter/material.dart';
import '../presenters/assignment_presenter.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {
  final AssignmentPresenter _presenter = AssignmentPresenter();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAssignments();
  }

  Future<void> _loadAssignments() async {
    await _presenter.loadAssignments();
    setState(() => _isLoading = false);
  }

  void _showAddAssignmentDialog() {
    String newAssignmentTitle = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Assignment'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Enter assignment title'),
            onChanged: (value) {
              newAssignmentTitle = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel button
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (newAssignmentTitle.trim().isNotEmpty) {
                  await _presenter.addAssignment(newAssignmentTitle.trim());
                  setState(() {});
                }
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final assignments = _presenter.filteredAssignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignments'),
        actions: [
          PopupMenuButton<AssignmentFilter>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            initialValue: _presenter.filter,
            onSelected: (filter) {
              setState(() => _presenter.setFilter(filter));
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: AssignmentFilter.all, child: Text('All')),
              PopupMenuItem(value: AssignmentFilter.active, child: Text('Active')),
              PopupMenuItem(value: AssignmentFilter.completed, child: Text('Completed')),
            ],
          ),
        ],
      ),
      body: 
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: assignments.length,
                itemBuilder: (context, index) {
                  final assignment = assignments[index];
                  return CheckboxListTile(
                    title: Text(assignment.title),
                    value: assignment.isCompleted, 
                    onChanged: (_) async {
                      await _presenter.toggleCompleted(assignment);
                      setState(() {});
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () async {
                        await _presenter.deleteAssignment(assignment);
                        setState(() {});
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}