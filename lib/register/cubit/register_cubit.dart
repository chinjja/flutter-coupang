import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:equatable/equatable.dart';

part 'register_state.dart';

part 'register_cubit.g.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final CommerceRepository _service;
  RegisterCubit(this._service) : super(const RegisterState());

  void usernameChanged(String username) {
    emit(state.copyWith(username: username));
    _updateSubmitState();
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
    _updateSubmitState();
  }

  void confirmPasswordChanged(String confirmPassword) {
    emit(state.copyWith(confirmPassword: confirmPassword));
    _updateSubmitState();
  }

  void submit() async {
    if (!state.enableSubmit) return;

    final isValidUsername = state.username.length > 4;
    final isValidPassword = state.password.length > 4;
    final isValidConfirmPassword =
        isValidPassword && state.password == state.confirmPassword;
    if (isValidUsername && isValidConfirmPassword) {
      emit(state.copyWith(
        status: RegisterStatus.loading,
        enableSubmit: false,
      ));
      try {
        await _service.register(User(
          username: state.username,
          password: state.password,
        ));
        emit(state.copyWith.status(RegisterStatus.success));
      } catch (e) {
        emit(state.copyWith.status(RegisterStatus.failure));
      }
    } else {
      emit(state.copyWith(
        invalidUsername: !isValidUsername,
        invalidPassword: !isValidPassword,
        invalidConfirmPassword: !isValidConfirmPassword,
      ));
    }
  }

  void _updateSubmitState() {
    emit(state.copyWith.enableSubmit(
      state.username.isNotEmpty &&
          state.password.isNotEmpty &&
          state.confirmPassword.isNotEmpty,
    ));
  }
}
