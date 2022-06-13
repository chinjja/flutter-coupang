// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/register/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

class MockRegisterCubit extends MockCubit<RegisterState>
    implements RegisterCubit {}

void main() {
  group('RegisterPage', () {
    late CommerceRepository repository;

    setUp(() {
      repository = MockCommerceRepository();
    });

    testWidgets('RegisterPage should be loaded', (tester) async {
      await tester.pumpWidget(RepositoryProvider(
        create: (context) => repository,
        child: MaterialApp(
          home: Scaffold(body: RegisterPage()),
        ),
      ));
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });

  group('RegisterView', () {
    late RegisterCubit cubit;
    late Widget widget;

    setUp(() {
      cubit = MockRegisterCubit();
      widget = MaterialApp(
        home: BlocProvider.value(
          value: cubit,
          child: Scaffold(body: RegisterView()),
        ),
      );
    });

    testWidgets('submit button should be disabled', (tester) async {
      when(() => cubit.state).thenReturn(RegisterState());
      await tester.pumpWidget(widget);
      expect(find.byType(RegisterView), findsOneWidget);

      final finder = find.byType(ElevatedButton);
      final button = tester.widget(finder) as ElevatedButton;
      expect(button.enabled, false);

      await tester.tap(finder);
      verifyNever(() => cubit.submit());
    });

    testWidgets('submit button should be enabled', (tester) async {
      when(() => cubit.state).thenReturn(RegisterState(enableSubmit: true));
      await tester.pumpWidget(widget);

      final finder = find.byType(ElevatedButton);
      final button = tester.widget(finder) as ElevatedButton;
      expect(button.enabled, true);

      await tester.tap(finder);
      verify(() => cubit.submit()).called(1);
    });
  });
}
