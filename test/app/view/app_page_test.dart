// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/app/cubit/app_cubit.dart';
import 'package:coupang/app/view/app.dart';
import 'package:coupang/commerce/repository/commerce_repository.dart';
import 'package:coupang/home/home.dart';
import 'package:coupang/login/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

class MockAppCubit extends MockCubit<AppState> implements AppCubit {}

void main() {
  group('App', () {
    late CommerceRepository repository;
    setUp(() {
      repository = MockCommerceRepository();
    });

    testWidgets('App should be loaded', (tester) async {
      when(() => repository.onAuthentication).thenAnswer((_) => Stream.empty());
      await tester.pumpWidget(RepositoryProvider.value(
        value: repository,
        child: MaterialApp(
          home: App(),
        ),
      ));
      expect(find.byType(App), findsOneWidget);
    });
  });

  group('AppView', () {
    late CommerceRepository repository;
    late AppCubit bloc;
    late Widget widget;
    setUp(() {
      repository = MockCommerceRepository();
      when(() => repository.onAuthentication).thenAnswer((_) => Stream.empty());
      bloc = MockAppCubit();
      widget = RepositoryProvider.value(
        value: repository,
        child: MaterialApp(
          home: BlocProvider.value(
            value: bloc,
            child: AppView(),
          ),
        ),
      );
    });

    testWidgets('LoginPage should be loaded', (tester) async {
      when(() => bloc.state)
          .thenReturn(AppState(status: AppStatus.authenticated));
      await tester.pumpWidget(widget);
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('HomePage should be loaded', (tester) async {
      when(() => bloc.state)
          .thenReturn(AppState(status: AppStatus.unauthenticated));
      await tester.pumpWidget(widget);
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('should show indicator', (tester) async {
      when(() => bloc.state).thenReturn(AppState(status: AppStatus.unknown));
      await tester.pumpWidget(widget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
