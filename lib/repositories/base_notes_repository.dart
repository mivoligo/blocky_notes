import '../models/models.dart';
import 'repositories.dart';

abstract class BaseNotesRepository extends BaseRepository {
  Future<Note> addNote({required Note note});
  Future<Note> updateNote({required Note note});
  Future<Note> deleteNote({required Note note});
  Stream<List<Note>> streamNotes({required String userId});
}
