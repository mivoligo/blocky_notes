part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class Unauthenticated extends AuthState {}

class Anonymous extends AuthState {
  const Anonymous(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}
