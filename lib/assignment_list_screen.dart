import 'package:flutter/material.dart';

class AssignmentListScreen extends StatefulWidget {
  const AssignmentListScreen({super.key});

  @override
  State<AssignmentListScreen> createState() => _AssignmentListScreenState();
}

class _AssignmentListScreenState extends State<AssignmentListScreen> {

  final List<Map<String, dynamic>> assignments = [];

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
              onPressed: () {
                if (newAssignmentTitle.isNotEmpty) {
                  setState(() {
                    assignments.add({
                      'title': newAssignmentTitle,
                      'completed': false,
                    });
                  });
                  Navigator.pop(context); // Close dialog
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _toggleCompleted(int index, bool? value) {
    setState(() {
      assignments[index]['completed'] = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments'),),
      body: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final assignment = assignments[index];
          return ListTile(
            title: Text(assignment['title']),
            trailing: SizedBox(
              width: 100, // Adjust the width as needed
              child: Row(
                children: [
                  Checkbox(
                    value: assignment['completed'],
                    onChanged: (value) => _toggleCompleted(index, value),
                  ),
                  IconButton(onPressed: (){
                    setState(() {
                      assignments.removeAt(index);
                    });
                  }, icon: const Icon(Icons.delete))
                ],
              )
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