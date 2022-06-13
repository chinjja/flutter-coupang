import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) => const RegisterPage());
  }

  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(context.read<CommerceRepository>()),
      child: const RegisterView(),
    );
  }
}
