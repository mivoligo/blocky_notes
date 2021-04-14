import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required AuthBloc authBloc,
    required AuthRepository authRepository,
  })   : _authBloc = authBloc,
        _authRepository = authRepository,
        super(LoginState.initial());

  final AuthBloc _authBloc;
  final AuthRepository _authRepository;

  void emailChanged(String value) => emit(state.copyWith(
        email: value,
        status: LoginStatus.initial,
      ));

  void passwordChanged(String value) => emit(state.copyWith(
        password: value,
        status: LoginStatus.initial,
      ));

  Future<void> loginWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      await _authRepository.loginWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      _authBloc.add(Login());
      emit(state.copyWith(status: LoginStatus.success));
    } on Exception catch (e) {
      emit(state.copyWith(
        errorMessage: '$e',
        status: LoginStatus.error,
      ));
    }
  }

  Future<void> signupWithEmailAndPassword() async {
    if (!state.isFormValid || state.status == LoginStatus.submitting) return;
    emit(state.copyWith(status: LoginStatus.submitting));
    try {
      _authRepository.signupWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      _authBloc.add(Login());
      emit(state.copyWith(status: LoginStatus.success));
    } on Exception catch (e) {
      print('======  in ========');
      emit(state.copyWith(
        errorMessage: '$e',
        status: LoginStatus.error,
      ));
    }
  }
}
