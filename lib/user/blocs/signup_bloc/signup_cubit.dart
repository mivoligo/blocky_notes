import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupState.initial());

  final AuthRepository _authRepository;

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
      emit(state.copyWith(status: SignupStatus.success));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: '$e', status: SignupStatus.failure));
    }
  }
}
