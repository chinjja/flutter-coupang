import 'package:coupang/login/login.dart';
import 'package:coupang/register/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 400,
          child: Column(
            children: const [
              _UsernameField(),
              _PasswordField(),
              SizedBox(height: 16),
              _SubmitButton(),
              SizedBox(height: 16),
              _RegisterButton(),
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
    final bloc = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginView_username_textFormField'),
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
    final bloc = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key('loginView_password_textFormField'),
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

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LoginCubit>();
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key('loginView_login_button'),
          onPressed: state.enableSubmit ? bloc.submit : null,
          child: const Text('Login'),
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: const Key('loginView_register_button'),
      child: const Text('Register'),
      onPressed: () {
        Navigator.push(context, RegisterPage.route());
      },
    );
  }
}
