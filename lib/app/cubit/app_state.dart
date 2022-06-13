part of 'app_cubit.dart';

enum AppStatus {
  unauthenticated,
  authenticated,
  unknown,
}

@CopyWith()
class AppState extends Equatable {
  final AppStatus status;
  const AppState({this.status = AppStatus.unknown});

  @override
  List<Object> get props => [status];
}
