// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/app/cubit/app_cubit.dart';
import 'package:coupang/commerce/model/model.dart';
import 'package:coupang/commerce/repository/commerce_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

void main() {
  late CommerceRepository repository;

  setUp(() {
    repository = MockCommerceRepository();
  });

  test('initial state test', () {
    when(() => repository.onAuthentication).thenAnswer((_) => Stream.empty());
    expect(AppCubit(repository).state, AppState());
  });

  blocTest<AppCubit, AppState>(
    'emits [authenticated] when User is added.',
    setUp: () {
      final user = User(
        username: 'user',
        password: '',
      );
      when(() => repository.onAuthentication)
          .thenAnswer((_) => Stream.value(user));
    },
    build: () => AppCubit(repository),
    expect: () => [AppState(status: AppStatus.authenticated)],
  );

  blocTest<AppCubit, AppState>(
    'emits [unauthenticated] when User is null.',
    setUp: () {
      when(() => repository.onAuthentication)
          .thenAnswer((_) => Stream.value(null));
    },
    build: () => AppCubit(repository),
    expect: () => [AppState(status: AppStatus.unauthenticated)],
  );
}
