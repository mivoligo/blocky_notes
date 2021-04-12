part of 'note_details_cubit.dart';

enum NoteDetailsStatus { initial, submitting, success, failure }

class NoteDetailsState extends Equatable {
  const NoteDetailsState({
    required this.note,
    required this.status,
    required this.errorMessage,
  });

  final Note? note;
  final NoteDetailsStatus status;
  final String errorMessage;

  @override
  List<Object?> get props => [note, status, errorMessage];

  factory NoteDetailsState.initial() {
    return NoteDetailsState(
      note: null,
      status: NoteDetailsStatus.initial,
      errorMessage: '',
    );
  }

  factory NoteDetailsState.submitting({required Note note}) {
    return NoteDetailsState(
      note: note,
      status: NoteDetailsStatus.submitting,
      errorMessage: '',
    );
  }

  factory NoteDetailsState.success({required Note note}) {
    return NoteDetailsState(
      note: note,
      status: NoteDetailsStatus.success,
      errorMessage: '',
    );
  }

  factory NoteDetailsState.failure({
    required Note note,
    required String errorMessage,
  }) {
    return NoteDetailsState(
      note: note,
      status: NoteDetailsStatus.failure,
      errorMessage: errorMessage,
    );
  }

  NoteDetailsState copyWith({
    Note? note,
    NoteDetailsStatus? status,
    String? errorMessage,
  }) {
    return NoteDetailsState(
      note: note ?? this.note,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
