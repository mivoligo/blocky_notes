part of 'signup_cubit.dart';

enum SignupStatus { initial, submitting, success, failure }

class SignupState extends Equatable {
  const SignupState({
    required this.email,
    required this.password,
    required this.errorMessage,
    required this.status,
  });

  final String email;
  final String password;
  final String errorMessage;
  final SignupStatus status;

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  @override
  List<Object> get props => [email, password, errorMessage, status];

  factory SignupState.initial() {
    return SignupState(
      email: '',
      password: '',
      errorMessage: '',
      status: SignupStatus.initial,
    );
  }

  SignupState copyWith({
    String? email,
    String? password,
    String? errorMessage,
    SignupStatus? status,
  }) {
    return SignupState(
      email: email ?? this.email,
      password: password ?? this.password,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
    );
  }
}
