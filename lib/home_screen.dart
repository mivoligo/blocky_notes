import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes/note_details_page.dart';
import 'notes/notes_page.dart';
import 'user/blocs/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Your notes'),
                ),
                leading: IconButton(
                  icon: state is Authenticated
                      ? Icon(Icons.logout)
                      : Icon(Icons.account_circle),
                  onPressed: () => state is Authenticated
                      ? context.read<AuthBloc>().add(Logout())
                      : () {},
                ),
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.brightness_4),
                  ),
                ],
              ),
              NotesPage(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailsPage(),
              ));
            },
          ),
        );
      },
    );
  }
}
