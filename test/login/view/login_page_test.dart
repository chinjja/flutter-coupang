// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  group('LoginPage', () {
    late CommerceRepository repository;

    setUp(() {
      repository = MockCommerceRepository();
    });

    testWidgets('LoginPage should be loaded', (tester) async {
      await tester.pumpWidget(RepositoryProvider.value(
        value: repository,
        child: MaterialApp(home: LoginPage()),
      ));
      expect(find.byType(LoginPage), findsOneWidget);
    });
  });

  group('LoginView', () {
    late LoginCubit bloc;
    late Widget widget;

    setUp(() {
      bloc = MockLoginCubit();
      widget = MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: LoginView(),
        ),
      );
    });

    testWidgets('submit is pressed', (tester) async {
      when(() => bloc.state).thenReturn(LoginState(
        username: 'user',
        password: 'password',
        enableSubmit: true,
      ));
      when(() => bloc.submit()).thenAnswer((_) async => {});
      await tester.pumpWidget(widget);
      await tester.tap(find.byKey(Key('loginView_login_button')));

      verify(() => bloc.submit()).called(1);
    });

    testWidgets('username is passed', (tester) async {
      const text = 'chinjja';
      when(() => bloc.state).thenReturn(LoginState());
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(Key('loginView_username_textFormField')),
        text,
      );
      verify(() => bloc.usernameChanged(text)).called(1);
    });

    testWidgets('password is passed', (tester) async {
      const text = 'password1234';
      when(() => bloc.state).thenReturn(LoginState());
      await tester.pumpWidget(widget);

      await tester.enterText(
        find.byKey(Key('loginView_password_textFormField')),
        text,
      );
      verify(() => bloc.passwordChanged(text)).called(1);
    });
  });
}
