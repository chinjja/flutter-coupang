import 'package:coupang/register/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 400,
          child: Column(
            children: const [
              _UsernameField(),
              _PasswordField(),
              _ConfirmPasswordField(),
              SizedBox(height: 16),
              _SubmitButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameField extends StatelessWidget {
  const _UsernameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('registerView_username_textFormField'),
          initialValue: state.username,
          onChanged: bloc.usernameChanged,
          decoration: InputDecoration(
            label: const Text('Username'),
            errorText: state.invalidUsername ? 'invalid username' : null,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
          ],
        );
      },
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('registerView_password_textFormField'),
          initialValue: state.password,
          obscureText: true,
          onChanged: bloc.passwordChanged,
          decoration: InputDecoration(
            label: const Text('Password'),
            errorText: state.invalidPassword ? 'invalid password' : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('registerView_confirmPassword_textFormField'),
          initialValue: state.confirmPassword,
          obscureText: true,
          onChanged: bloc.confirmPasswordChanged,
          decoration: InputDecoration(
            label: const Text('Confirm password'),
            errorText: state.invalidConfirmPassword
                ? 'invalid confirm password'
                : null,
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<RegisterCubit>();
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.enableSubmit ? bloc.submit : null,
          child: const Text('Register'),
        );
      },
    );
  }
}
