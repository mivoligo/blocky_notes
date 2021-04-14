import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'notes/notes.dart';
import 'theme/theme.dart';
import 'user/user.dart';

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
                      : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LoginScreen(),
                          ),
                        ),
                ),
                actions: [
                  _ThemeSwitcherButton(
                    isDarkTheme: context.read<ThemeCubit>().state.themeData ==
                        themeData[AppTheme.darkTheme],
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

class _ThemeSwitcherButton extends StatelessWidget {
  const _ThemeSwitcherButton({required this.isDarkTheme});

  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return isDarkTheme
        ? IconButton(
            onPressed: () =>
                context.read<ThemeCubit>().updateTheme(isDarkMode: false),
            icon: Icon(Icons.brightness_high),
          )
        : IconButton(
            onPressed: () =>
                context.read<ThemeCubit>().updateTheme(isDarkMode: true),
            icon: Icon(Icons.brightness_2_sharp),
          );
  }
}
