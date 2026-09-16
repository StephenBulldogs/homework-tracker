import '../models/course_model.dart';

class CoursePresenter {
  final List<Course> _courses = [];

  List<Course> get courses => _courses;

  void addCourse(String name, String? description) {
    _courses.add(Course(name: name, description: description));
  }

void updateCourse(int index, String name, String? description) {
  courses[index] = Course(
    name: name,
    description: description,
  );
}


  void removeCourse(int index) {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
    }
  }
}