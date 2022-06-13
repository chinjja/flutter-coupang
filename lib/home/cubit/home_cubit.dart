import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:coupang/commerce/model/user.dart';
import 'package:coupang/commerce/repository/commerce_repository.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

part 'home_cubit.g.dart';

class HomeCubit extends Cubit<HomeState> {
  final CommerceRepository _repository;
  late StreamSubscription _listen;
  HomeCubit(this._repository) : super(const HomeState()) {
    _listen = _repository.onAuthentication.listen((event) {
      emit(state.copyWith.user(event));
    });
  }

  @override
  Future<void> close() async {
    await _listen.cancel();
    return super.close();
  }

  Future logout() async {
    await _repository.logout();
  }
}
