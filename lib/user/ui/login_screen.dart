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

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == LoginStatus.error) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Error'),
                    content: Text(state.failure.message!),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('OK'),
                      )
                    ],
                  );
                },
              );
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 40.0),
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (_) =>
                            state.isEmailValid ? null : 'Invalid email',
                        onChanged: (value) =>
                            context.read<LoginCubit>().emailChanged(value),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: const TextStyle(color: Colors.black),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                        style: const TextStyle(color: Colors.black),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (_) => state.isPasswordValid
                            ? null
                            : 'Password must be at least 6 characters',
                        onChanged: (value) =>
                            context.read<LoginCubit>().passwordChanged(value),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                          onPressed: state.isFormValid
                              ? () => context
                                  .read<LoginCubit>()
                                  .loginWithEmailAndPassword()
                              : null,
                          child: Text('Login')),
                      const SizedBox(height: 40),
                      ElevatedButton(
                          onPressed: state.isFormValid
                              ? () => context
                                  .read<LoginCubit>()
                                  .signupWithEmailAndPassword()
                              : null,
                          child: Text('Signup')),
                    ],
                  ),
                ),
                state.status == LoginStatus.submitting
                    ? Center(child: CircularProgressIndicator())
                    : const SizedBox(),
              ],
            );
          },
        ),
      ),
    );
  }
}
