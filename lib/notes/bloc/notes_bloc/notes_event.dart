part of 'notes_bloc.dart';

abstract class NotesEvent extends Equatable {
  const NotesEvent();
  @override
  List<Object?> get props => [];
}

class FetchNotes extends NotesEvent {}

class UpdateNotes extends NotesEvent {
  const UpdateNotes({required this.notes});

  final List<Note> notes;

  @override
  List<Object?> get props => [notes];
}
