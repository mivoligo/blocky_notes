import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import '../../user.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({
    required AuthBloc authBloc,
    required AuthRepository authRepository,
  })   : _authBloc = authBloc,
        _authRepository = authRepository,
        super(SignupState.initial());

  final AuthRepository _authRepository;
  final AuthBloc _authBloc;

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> signupWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == SignupStatus.submitting) return;
    emit(state.copyWith(status: SignupStatus.submitting));
    try {
      _authRepository.signupWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      _authBloc.add(Login());
      emit(state.copyWith(status: SignupStatus.success));
    } on PlatformException catch (e) {
      emit(state.copyWith(
        errorMessage: e.message,
        status: SignupStatus.failure,
      ));
    }
  }
}
