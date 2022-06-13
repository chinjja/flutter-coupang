part of 'register_cubit.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
}

@CopyWith()
class RegisterState extends Equatable {
  final RegisterStatus status;
  final String username;
  final String password;
  final String confirmPassword;
  final bool enableSubmit;
  final bool invalidUsername;
  final bool invalidPassword;
  final bool invalidConfirmPassword;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.enableSubmit = false,
    this.invalidUsername = false,
    this.invalidPassword = false,
    this.invalidConfirmPassword = false,
  });

  @override
  List<Object> get props => [
        status,
        username,
        password,
        confirmPassword,
        enableSubmit,
        invalidUsername,
        invalidPassword,
        invalidConfirmPassword,
      ];
}
