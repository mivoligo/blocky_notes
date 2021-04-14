import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(LoginState.initial());

  final AuthRepository _authRepository;

  void emailChanged(String value) => emit(state.copyWith(email: value));

  void passwordChanged(String value) => emit(state.copyWith(password: value));

  Future<void> loginWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.loginWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: '$e', status: LoginStatus.error));
    }
  }
}
