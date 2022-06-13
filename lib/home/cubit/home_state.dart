part of 'home_cubit.dart';

@CopyWith()
class HomeState extends Equatable {
  final User? user;
  const HomeState({this.user});

  @override
  List<Object?> get props => [user];
}
