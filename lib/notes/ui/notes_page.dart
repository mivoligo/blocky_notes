import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../user/user.dart';
import '../notes.dart';

class NotesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotesBloc(
          authRepository: context.read<AuthRepository>(),
          notesRepository: context.read<NotesRepository>())
        ..add(FetchNotes()),
      child: NotesView(),
    );
  }
}

class NotesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesInitial) {
          return const SliverPadding(padding: EdgeInsets.zero);
        } else if (state is NotesLoading) {
          return const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()));
        } else if (state is NotesLoaded) {
          return NotesGrid(
            notes: state.notes,
            onTap: (note) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NoteDetailsPage(note: note),
              ),
            ),
          );
        } else if (state is NotesError) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Text('Could not fetch notes'),
            ),
          );
        } else {
          return const SliverPadding(padding: EdgeInsets.zero);
        }
      },
    );
  }
}
