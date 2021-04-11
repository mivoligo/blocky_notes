part of 'notes_bloc.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  const NotesLoaded({required this.notes});

  final List<Note> notes;

  @override
  List<Object> get props => [notes];
}

class NotesError extends NotesState {}
