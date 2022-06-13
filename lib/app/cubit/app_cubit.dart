import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:coupang/commerce/commerce.dart';
import 'package:equatable/equatable.dart';

part 'app_state.dart';

part 'app_cubit.g.dart';

class AppCubit extends Cubit<AppState> {
  final CommerceRepository _repository;
  late StreamSubscription _streamSubscription;
  AppCubit(this._repository) : super(const AppState()) {
    _streamSubscription = _repository.onAuthentication.listen((event) {
      if (event == null) {
        emit(state.copyWith.status(AppStatus.unauthenticated));
      } else {
        emit(state.copyWith.status(AppStatus.authenticated));
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
