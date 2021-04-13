import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(Unauthenticated());

  final AuthRepository _authRepository;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is Login) {
      yield* _mapLoginToState();
    } else if (event is Logout) {
      yield* _mapLogoutToState();
    }
  }

  Stream<AuthState> _mapAppStartedToState() async* {
    try {
      var currentUser = await _authRepository.getCurrentUser();
      if (currentUser == null) {
        currentUser = await _authRepository.loginAnonymously();
      }
      final isAnonymous = await _authRepository.isAnonymous();
      if (isAnonymous) {
        yield Anonymous(currentUser);
      } else {
        yield Authenticated(currentUser);
      }
    } on Exception catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLoginToState() async* {
    try {
      final currentUser = await _authRepository.getCurrentUser();
      yield Authenticated(currentUser!);
    } on Exception catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }

  Stream<AuthState> _mapLogoutToState() async* {
    try {
      await _authRepository.logout();
      yield* _mapAppStartedToState();
    } on Exception catch (e) {
      print(e);
      yield Unauthenticated();
    }
  }
}
