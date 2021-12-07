part of 'home_bloc.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}


class GetHomeScreenData extends HomeEvent {
  GetHomeScreenData();

  @override
  List<Object> get props => [];
}
