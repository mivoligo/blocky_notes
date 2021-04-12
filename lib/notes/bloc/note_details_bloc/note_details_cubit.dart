import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../user/blocs/auth_bloc/auth_bloc.dart';
import '../../data/models/models.dart';
import '../../data/repositories/notes_repository.dart';

part 'note_details_state.dart';

class NoteDetailsCubit extends Cubit<NoteDetailsState> {
  NoteDetailsCubit({
    required AuthBloc authBloc,
    required NotesRepository notesRepository,
  })   : _authBloc = authBloc,
        _notesRepository = notesRepository,
        super(NoteDetailsState.initial());

  final AuthBloc _authBloc;
  final NotesRepository _notesRepository;

  void loadNote({required Note note}) {
    emit(state.copyWith(note: note, status: NoteDetailsStatus.initial));
  }

  void updateContent({required String content}) {
    if (state.note == null) {
      final currentUserId = _getCurrentUserId();
      final note = Note(
        userId: currentUserId!,
        content: content,
        color: HexColor('#E74C3C'),
        timestamp: DateTime.now(),
      );
      emit(state.copyWith(note: note, status: NoteDetailsStatus.initial));
    } else {
      emit(
        state.copyWith(
          note: state.note?.copyWith(
            content: content,
            timestamp: DateTime.now(),
          ),
          status: NoteDetailsStatus.initial,
        ),
      );
    }
  }

  void updateColor({required Color color}) {
    if (state.note == null) {
      final currentUserId = _getCurrentUserId();
      final note = Note(
        userId: currentUserId!,
        content: '',
        color: color,
        timestamp: DateTime.now(),
      );
      emit(state.copyWith(note: note, status: NoteDetailsStatus.initial));
    } else {
      emit(
        state.copyWith(
          note: state.note?.copyWith(
            color: color,
            timestamp: DateTime.now(),
          ),
          status: NoteDetailsStatus.initial,
        ),
      );
    }
  }

  void addNote() async {
    emit(NoteDetailsState.submitting(note: state.note!));
    try {
      await _notesRepository.addNote(note: state.note!);
      emit(NoteDetailsState.success(note: state.note!));
    } on Exception catch (_) {
      emit(NoteDetailsState.failure(
        note: state.note!,
        errorMessage: 'New note could not be added',
      ));
      emit(state.copyWith(status: NoteDetailsStatus.initial));
    }
  }

  void saveNote() async {
    emit(NoteDetailsState.submitting(note: state.note!));
    try {
      await _notesRepository.updateNote(note: state.note!);
    } on Exception catch (_) {
      emit(NoteDetailsState.failure(
        note: state.note!,
        errorMessage: 'Note could not be saved',
      ));
      emit(state.copyWith(status: NoteDetailsStatus.initial));
    }
  }

  void deleteNote() async {
    emit(NoteDetailsState.submitting(note: state.note!));
    try {
      await _notesRepository.deleteNote(note: state.note!);
      emit(NoteDetailsState.success(note: state.note!));
    } on Exception catch (_) {
      emit(NoteDetailsState.failure(
        note: state.note!,
        errorMessage: 'Note could not be deleted',
      ));
      emit(state.copyWith(status: NoteDetailsStatus.initial));
    }
  }

  String? _getCurrentUserId() {
    final authState = _authBloc.state;
    String? currentUserId;
    if (authState is Anonymous) {
      currentUserId = authState.user.id;
    } else if (authState is Authenticated) {
      currentUserId = authState.user.id;
    }
    return currentUserId;
  }
}
