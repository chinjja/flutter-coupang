// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:coupang/register/register.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepository extends Mock implements CommerceRepository {}

class FakeUser extends Fake implements User {}

void main() {
  late CommerceRepository commerceRepository;
  late RegisterCubit cubit;

  setUp(() {
    commerceRepository = MockCommerceRepository();
    cubit = RegisterCubit(commerceRepository);
    registerFallbackValue(FakeUser());
  });

  test('initial cubit state', () {
    expect(cubit.state, RegisterState());
  });

  blocTest<RegisterCubit, RegisterState>(
    'username change test.',
    build: () => cubit,
    act: (bloc) => bloc.usernameChanged('user'),
    expect: () => const [RegisterState(username: 'user')],
  );

  blocTest<RegisterCubit, RegisterState>(
    'password change test.',
    build: () => cubit,
    act: (bloc) => bloc.passwordChanged('password'),
    expect: () => const [RegisterState(password: 'password')],
  );

  blocTest<RegisterCubit, RegisterState>(
    'confirm password change test.',
    build: () => cubit,
    act: (bloc) => bloc.confirmPasswordChanged('password'),
    expect: () => const [RegisterState(confirmPassword: 'password')],
  );

  blocTest<RegisterCubit, RegisterState>(
    'if has initial state, skip submit.',
    build: () => cubit,
    act: (bloc) => bloc.submit(),
    expect: () => const [],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emit invalid state for all',
    build: () => cubit,
    seed: () => RegisterState(
      username: '1',
      password: '2',
      confirmPassword: '3',
      enableSubmit: true,
    ),
    act: (bloc) => bloc.submit(),
    expect: () => const [
      RegisterState(
        username: '1',
        password: '2',
        confirmPassword: '3',
        invalidUsername: true,
        invalidPassword: true,
        invalidConfirmPassword: true,
        enableSubmit: true,
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emit invalid state for password, confirm password',
    build: () => cubit,
    seed: () => RegisterState(
      username: 'user1',
      password: '2',
      confirmPassword: '3',
      enableSubmit: true,
    ),
    act: (bloc) => bloc.submit(),
    expect: () => const [
      RegisterState(
        username: 'user1',
        password: '2',
        confirmPassword: '3',
        invalidUsername: false,
        invalidPassword: true,
        invalidConfirmPassword: true,
        enableSubmit: true,
      )
    ],
  );

  blocTest<RegisterCubit, RegisterState>(
    'emit invalid state for confirm password',
    build: () => cubit,
    seed: () => RegisterState(
      username: 'user1',
      password: 'password1',
      confirmPassword: '3',
      enableSubmit: true,
    ),
    act: (bloc) => bloc.submit(),
    expect: () => const [
      RegisterState(
        username: 'user1',
        password: 'password1',
        confirmPassword: '3',
        invalidUsername: false,
        invalidPassword: false,
        invalidConfirmPassword: true,
        enableSubmit: true,
      )
    ],
  );

  group('submit test', () {
    late RegisterState state;
    setUp(() {
      state = RegisterState(
        username: 'user1',
        password: 'password1',
        confirmPassword: 'password1',
        enableSubmit: true,
      );
    });
    blocTest<RegisterCubit, RegisterState>(
      'emit invalid state all',
      build: () => cubit,
      setUp: () {
        when(() => commerceRepository.register(any()))
            .thenAnswer((_) async => {});
      },
      seed: () => state,
      act: (bloc) => bloc.submit(),
      expect: () => [
        state.copyWith(
          status: RegisterStatus.loading,
          enableSubmit: false,
        ),
        state.copyWith(
          status: RegisterStatus.success,
          enableSubmit: false,
        ),
      ],
      verify: (_) {
        verify(() => commerceRepository.register(User(
              username: 'user1',
              password: 'password1',
            ))).called(1);
      },
    );
    blocTest<RegisterCubit, RegisterState>(
      'emit invalid state all fail',
      build: () => cubit,
      setUp: () {
        when(() => commerceRepository.register(any()))
            .thenThrow('register failed');
      },
      seed: () => state,
      act: (bloc) => bloc.submit(),
      expect: () => [
        state.copyWith(
          status: RegisterStatus.loading,
          enableSubmit: false,
        ),
        state.copyWith(
          status: RegisterStatus.failure,
          enableSubmit: false,
        ),
      ],
    );
  });
}
