import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

part 'login_cubit.g.dart';

class LoginCubit extends Cubit<LoginState> {
  final CommerceRepository _repository;
  LoginCubit(this._repository) : super(const LoginState());

  void usernameChanged(String username) {
    emit(state.copyWith(
      username: username,
      enableSubmit: username.isNotEmpty && state.password.isNotEmpty,
    ));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(
      password: password,
      enableSubmit: state.username.isNotEmpty && password.isNotEmpty,
    ));
  }

  Future submit() async {
    if (state.enableSubmit) {
      emit(state.copyWith(
        status: LoginStatus.loading,
        enableSubmit: false,
      ));
      try {
        await _repository.login(User(
          username: state.username,
          password: state.password,
        ));
        emit(state.copyWith.status(LoginStatus.success));
      } catch (e) {
        emit(state.copyWith.status(LoginStatus.failure));
      }
    } else {
      emit(state.copyWith(
        invalidPassword: state.password.length <= 4,
        invalidUsername: state.username.length <= 4,
      ));
    }
  }
}
