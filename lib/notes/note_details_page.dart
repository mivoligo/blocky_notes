import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user/blocs/auth_bloc/auth_bloc.dart';
import 'bloc/note_details_bloc/note_details_cubit.dart';
import 'data/models/models.dart';
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
  final List<HexColor> _colors = [
    HexColor('#E74C3C'),
    HexColor('#3498DB'),
    HexColor('#27AE60'),
    HexColor('#F6C924'),
    HexColor('#8E44AD'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteDetailsCubit, NoteDetailsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
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
              onChanged: (value) => context
                  .read<NoteDetailsCubit>()
                  .updateContent(content: value),
            ),
          ),
          bottomSheet: _ColorPicker(
            state: state,
            colors: _colors,
          ),
        );
      },
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    Key? key,
    required this.state,
    required this.colors,
  }) : super(key: key);

  final NoteDetailsState state;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colors.map((color) {
          var isSelected = state.note != null && state.note?.color == color;
          return GestureDetector(
            child: Container(
              width: 30.0,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(
                        color: Colors.black,
                        width: 2.0,
                      )
                    : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
