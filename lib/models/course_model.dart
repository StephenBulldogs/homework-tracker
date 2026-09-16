class Course {
  final bool existing;
  final String name;
  final String? description;

  Course({
    this.existing = true,
    required this.name,
    this.description,
  });
}