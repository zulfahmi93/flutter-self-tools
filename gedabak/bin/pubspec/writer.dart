import 'dart:io';

import '../models/models.dart';

Future<bool> updatePubspec(Project project) async {
  final file = File(project.pubspecPath);
  try {
    await file.writeAsString(project.pubspecContent.join('\n'));
    return true;
    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    return false;
  }
}
