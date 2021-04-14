import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../user.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(
        authBloc: context.read<AuthBloc>(),
        authRepository: context.read<AuthRepository>(),
      ),
      child: LoginView(),
    );
  }
}

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
