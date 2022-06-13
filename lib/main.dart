import 'package:coupang/app/view/view.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => CommerceRepository()..init(),
      child: const App(),
    );
  }
}
