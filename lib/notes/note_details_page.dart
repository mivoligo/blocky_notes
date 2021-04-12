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
  NoteDetailsView({Key? key, this.note}) : super(key: key);

  final Note? note;

  bool get _isEditing => note != null;

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
        if (state.status == NoteDetailsStatus.success) {
          Navigator.of(context).pop();
        } else if (state.status == NoteDetailsStatus.failure) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(state.errorMessage),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              _isEditing
                  ? _ActionButton(
                      text: 'Delete',
                      color: Colors.red,
                      onPressed: () =>
                          context.read<NoteDetailsCubit>().deleteNote(),
                    )
                  : _ActionButton(
                      text: 'Add note',
                      color: Colors.green,
                      onPressed: () =>
                          context.read<NoteDetailsCubit>().addNote(),
                    ),
            ],
          ),
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
            onTap: () =>
                context.read<NoteDetailsCubit>().updateColor(color: color),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 17.0, color: color),
      ),
    );
  }
}
