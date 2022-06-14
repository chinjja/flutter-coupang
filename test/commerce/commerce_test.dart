// ignore_for_file: prefer_const_constructors

import 'package:coupang/commerce/model/model.dart';
import 'package:coupang/commerce/repository/commerce_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late Dio dio;
  late DioAdapter adapter;
  late FlutterSecureStorage storage;
  late CommerceRepository repository;

  setUp(() {
    dio = Dio();
    adapter = DioAdapter(dio: dio);
    storage = MockFlutterSecureStorage();
    repository = CommerceRepository(
      dio: dio,
      storage: storage,
    );
  });

  test('baseUrl', () {
    expect(dio.options.baseUrl, 'http://localhost:8080');
  });

  test('when access_token exists then bearer is added', () async {
    when(() => storage.read(key: 'ACCESS_TOKEN'))
        .thenAnswer((_) async => 'abc');
    adapter.onGet(
      '/bearer',
      headers: {
        'Authorization': 'Bearer abc',
      },
      (server) {
        server.reply(200, null);
      },
    );

    final res = await dio.get('/bearer');
    expect(res.statusCode, 200);
  });

  test('login', () async {
    final user = User(username: 'user', password: 'password');
    when(() => storage.read(key: 'ACCESS_TOKEN')).thenAnswer((_) async => null);
    when(() =>
            storage.write(key: any(named: 'key'), value: any(named: 'value')))
        .thenAnswer((_) async => {});
    adapter.onPost(
      '/auth/login',
      data: user.toJson(),
      (server) {
        server.reply(
          200,
          {
            'accessToken': 'a',
            'refreshToken': 'b',
          },
        );
      },
    );

    await repository.login(user);

    verify(() => storage.write(key: 'ACCESS_TOKEN', value: 'a')).called(1);
    verify(() => storage.write(key: 'REFRESH_TOKEN', value: 'b')).called(1);
  });
}
