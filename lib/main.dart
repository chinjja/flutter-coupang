import 'package:bloc/bloc.dart';
import 'package:coupang/app/app.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocOverrides.runZoned(
    () async {
      final repository = CommerceRepository()..init();
      runApp(App(commerceRepository: repository));
    },
    blocObserver: AppBlocObserver(),
  );
}
