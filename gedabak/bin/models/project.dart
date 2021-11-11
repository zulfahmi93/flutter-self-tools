import 'projects.dart';

class Project {
  // ---------------------------- CONSTRUCTORS ----------------------------
  Project({
    required this.name,
    required this.pubspecPath,
    required this.pubspecContent,
    required this.dependencies,
    this.isPublished = false,
  });

  // ------------------------------- FIELDS -------------------------------
  final String name;
  final String pubspecPath;
  final List<String> pubspecContent;
  final Projects dependencies;
  bool isPublished;
}
