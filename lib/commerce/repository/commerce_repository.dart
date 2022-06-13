import 'dart:developer';
import 'dart:io';

import 'package:coupang/commerce/commerce.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/subjects.dart';

class CommerceRepository {
  static const accessTokenKey = "ACCESS_TOKEN";
  static const refreshTokenKey = "REFRESH_TOKEN";

  final Dio dio;
  final FlutterSecureStorage storage;
  final _onAuthentication = BehaviorSubject<User?>();

  CommerceRepository({
    this.storage = const FlutterSecureStorage(),
    Dio? dio,
  }) : dio = dio ?? Dio() {
    this.dio.options.baseUrl = 'http://localhost:8080';
    this.dio.interceptors.add(InterceptorsWrapper(
          onRequest: (options, handler) async {
            final accessToken = await storage.read(key: accessTokenKey);
            if (accessToken != null) {
              options.headers['Authorization'] = "Bearer $accessToken";
            }
            return handler.next(options);
          },
          onError: (error, handler) async {
            if (error.response?.statusCode == HttpStatus.unauthorized) {
              if (await _refresh()) {
                final response = await this.dio.request(
                      error.requestOptions.path,
                      options: Options(
                        method: error.requestOptions.method,
                        headers: error.requestOptions.headers,
                      ),
                      data: error.requestOptions.data,
                      queryParameters: error.requestOptions.queryParameters,
                    );
                return handler.resolve(response);
              }
            }
            return handler.next(error);
          },
        ));
    this.dio.interceptors.add(InterceptorsWrapper(
          onError: (e, handler) => log(e.message),
        ));
  }

  Future register(User user) async {
    await dio.post('/auth/register', data: user.toJson());
  }

  Future login(User user) async {
    final res = await dio.post('/auth/login', data: user.toJson());

    await storage.write(
      key: accessTokenKey,
      value: res.data['accessToken'],
    );
    await storage.write(
      key: refreshTokenKey,
      value: res.data['refreshToken'],
    );
    _onAuthentication.add(user);
  }

  Future logout() async {
    storage.delete(key: accessTokenKey);
    storage.delete(key: refreshTokenKey);
    _onAuthentication.add(null);
  }

  Future<bool> _refresh() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);
    if (accessToken != null && refreshToken != null) {
      final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
      try {
        final refreshRes = await refreshDio.post('/auth/refresh', data: {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        });
        await storage.write(
          key: accessTokenKey,
          value: refreshRes.data['accessToken'],
        );
        return true;
      } on DioError catch (e) {
        if (e.response?.statusCode == HttpStatus.unauthorized) {
          await logout();
        }
      }
    }
    return false;
  }

  Future init() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);
    if (accessToken != null &&
        refreshToken != null &&
        !JwtDecoder.isExpired(refreshToken)) {
      final map = JwtDecoder.decode(accessToken);
      _onAuthentication.add(User(username: map['sub'], password: ''));
    } else {
      _onAuthentication.add(null);
    }
  }

  Stream<User?> get onAuthentication =>
      _onAuthentication.stream.map((event) => event?.copyWith.password(''));

  Future<List<Seller>> getSellers() async {
    final res = await dio.get('/commerce/sellers');
    final list = res.data as List;
    return list.map((e) => Seller.fromJson(e)).toList();
  }

  Future<Seller> getSeller(String id) async {
    final res = await dio.get('/commerce/sellers/$id');
    return Seller.fromJson(res.data);
  }

  Future<String> newSeller(Seller seller) async {
    final res = await dio.post('/commerce/sellers', data: seller.toJson());
    return res.data;
  }
}
