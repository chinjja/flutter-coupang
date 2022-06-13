// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

class FakeUser extends Fake implements User {}

void main() {
  late CommerceRepository repository;
  late LoginCubit cubit;

  setUp(() {
    repository = MockCommerceRepository();
    cubit = LoginCubit(repository);
    registerFallbackValue(FakeUser());
  });

  blocTest<LoginCubit, LoginState>(
    'username changed.',
    build: () => cubit,
    act: (bloc) => bloc.usernameChanged('user'),
    expect: () => const [
      LoginState(username: 'user'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'password changed.',
    build: () => cubit,
    act: (bloc) => bloc.passwordChanged('password'),
    expect: () => const [
      LoginState(password: 'password'),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'username & password is not empty then submit should be enabled.',
    build: () => cubit,
    act: (bloc) {
      bloc.usernameChanged('user');
      bloc.passwordChanged('password');
    },
    expect: () => const [
      LoginState(username: 'user'),
      LoginState(username: 'user', password: 'password', enableSubmit: true),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'when submit is disable then skip submit',
    build: () => cubit,
    seed: () => LoginState(
      username: 'user1',
      password: 'password',
      enableSubmit: false,
    ),
    act: (bloc) {
      bloc.submit();
    },
    expect: () => const [],
  );

  blocTest<LoginCubit, LoginState>(
    'when all field is empty and submit is pressed then state has invalid',
    build: () => cubit,
    act: (bloc) {
      bloc.submit();
    },
    expect: () => const [
      LoginState(
        invalidUsername: true,
        invalidPassword: true,
      ),
    ],
  );

  blocTest<LoginCubit, LoginState>(
    'when username & password is valid and submit it then should submit it',
    build: () => cubit,
    setUp: () {
      when(() => repository.login(any())).thenAnswer((_) async => {});
    },
    seed: () => LoginState(
      username: 'user1',
      password: 'password',
      enableSubmit: true,
    ),
    act: (bloc) {
      bloc.submit();
    },
    expect: () => const [
      LoginState(
        status: LoginStatus.loading,
        username: 'user1',
        password: 'password',
        enableSubmit: false,
      ),
      LoginState(
        status: LoginStatus.success,
        username: 'user1',
        password: 'password',
        enableSubmit: false,
      ),
    ],
    verify: (_) {
      verify(() => repository.login(User(
            username: 'user1',
            password: 'password',
          ))).called(1);
    },
  );

  blocTest<LoginCubit, LoginState>(
    'when login is failed then emit failure state',
    build: () => cubit,
    setUp: () {
      when(() => repository.login(any())).thenThrow('auth failed');
    },
    seed: () => LoginState(
      username: 'user1',
      password: 'password',
      enableSubmit: true,
    ),
    act: (bloc) {
      bloc.submit();
    },
    expect: () => const [
      LoginState(
        status: LoginStatus.loading,
        username: 'user1',
        password: 'password',
        enableSubmit: false,
      ),
      LoginState(
        status: LoginStatus.failure,
        username: 'user1',
        password: 'password',
        enableSubmit: false,
      ),
    ],
  );
}
