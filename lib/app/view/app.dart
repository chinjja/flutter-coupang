import 'package:coupang/app/app.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/home/home.dart';
import 'package:coupang/login/login.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(context.read<CommerceRepository>()),
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coupang Demo',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: FlowBuilder<AppStatus>(
        state: context.select((AppCubit value) => value.state.status),
        onGeneratePages: (state, pages) {
          switch (state) {
            case AppStatus.authenticated:
              return const [MaterialPage(child: HomePage())];
            case AppStatus.unauthenticated:
              return const [MaterialPage(child: LoginPage())];
            default:
              return const [MaterialPage(child: _Loading())];
          }
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
