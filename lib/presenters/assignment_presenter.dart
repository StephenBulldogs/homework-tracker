import '../models/assignment_model.dart';

enum AssignmentFilter { all, active, completed }

class AssignmentPresenter {
  final List<Assignment> _assignments= [];
  AssignmentFilter _filter = AssignmentFilter.all;

  List<Assignment> get assignments => _assignments;
  AssignmentFilter get filter => _filter;

  List<Assignment> get filteredAssignments {
    switch (_filter) {
      case AssignmentFilter.active:
        return _assignments.where((a) => !a.isCompleted).toList();
      case AssignmentFilter.completed:
        return _assignments.where((a) => a.isCompleted).toList();
      case AssignmentFilter.all:
        return _assignments;
    }
  }

  void setFilter(AssignmentFilter filter) {
    _filter = filter;
  }

  Future<void> loadAssignments() async {
    final fetched = await Assignment.fetchAssignments();
    _assignments
        ..clear()
        ..addAll(fetched);
  }

  Future<void> addAssignment(String title) async {
    final id = await Assignment.addAssignment(title);
    if (id == null) return;
    _assignments.add(Assignment(id: id, title: title));
  }

  Future<void> toggleCompleted(Assignment assignment) async {
    final updatedStatus = !assignment.isCompleted;
    await Assignment.updateCompletionStatus(assignment.id, updatedStatus);
    assignment.isCompleted = updatedStatus;
  }

  Future<void> deleteAssignment(Assignment assignment) async {
    await Assignment.deleteAssignment(assignment.id);
    _assignments.remove(assignment);
  }
}