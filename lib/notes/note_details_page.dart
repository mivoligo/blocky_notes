import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user/blocs/auth_bloc/auth_bloc.dart';
import 'bloc/note_details_bloc/note_details_cubit.dart';
import 'data/repositories/notes_repository.dart';

class NoteDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteDetailsCubit>(
      create: (context) => NoteDetailsCubit(
        authBloc: context.read<AuthBloc>(),
        notesRepository: context.read<NotesRepository>(),
      ),
      child: NoteDetailsView(),
    );
  }
}

class NoteDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
            left: 24.0, top: 10.0, right: 24.0, bottom: 80.0),
        child: TextField(
          autofocus: true,
          style: const TextStyle(
            fontSize: 18.0,
            height: 1.2,
          ),
          decoration: const InputDecoration.collapsed(
            hintText: 'Write whatever you like',
          ),
          maxLines: null,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) =>
              context.read<NoteDetailsCubit>().updateContent(content: value),
        ),
      ),
    );
  }
}
