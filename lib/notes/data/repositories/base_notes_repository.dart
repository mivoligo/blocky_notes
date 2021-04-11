import '../models/models.dart';

abstract class BaseNotesRepository {
  Future<Note> addNote({required Note note});

  Future<Note> updateNote({required Note note});

  Future<Note> deleteNote({required Note note});

  Stream<List<Note>> streamNotes({required String userId});
}
