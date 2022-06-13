part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  loading,
  success,
  failure,
}

@CopyWith()
class LoginState extends Equatable {
  final LoginStatus status;
  final String username;
  final String password;
  final bool invalidUsername;
  final bool invalidPassword;
  final bool enableSubmit;
  const LoginState({
    this.status = LoginStatus.initial,
    this.username = '',
    this.password = '',
    this.invalidUsername = false,
    this.invalidPassword = false,
    this.enableSubmit = false,
  });

  @override
  List<Object> get props => [
        status,
        username,
        password,
        invalidUsername,
        invalidPassword,
        enableSubmit,
      ];
}
