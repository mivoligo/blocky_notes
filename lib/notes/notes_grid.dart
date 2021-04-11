import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data/models/models.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({
    Key? key,
    required this.notes,
    required this.onTap,
  }) : super(key: key);

  final List<Note> notes;
  final void Function(Note) onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(
        left: 10.0,
        right: 10.0,
        bottom: 40.0,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.8,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final note = notes[index];
            return GestureDetector(
              onTap: () => onTap(note),
              child: Card(
                elevation: 4.0,
                color: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          note.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat.yMd().add_jm().format(note.timestamp),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: notes.length,
        ),
      ),
    );
  }
}
