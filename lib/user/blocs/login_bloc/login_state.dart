part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, error }

class LoginState extends Equatable {
  const LoginState({
    required this.email,
    required this.password,
    required this.status,
    required this.failure,
  });

  final String email;
  final String password;
  final LoginStatus status;
  final Failure failure;

  bool get isEmailValid => email.contains('@'); // just for testing

  bool get isPasswordValid => password.length > 5;

  bool get isFormValid => isEmailValid && isPasswordValid;

  @override
  List<Object> get props => [email, password, status, failure];

  factory LoginState.initial() {
    return LoginState(
      email: '',
      password: '',
      status: LoginStatus.initial,
      failure: const Failure(),
    );
  }

  LoginState copyWith({
    String? email,
    String? password,
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
