import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<CommerceRepository>()),
      child: const LoginView(),
    );
  }
}
