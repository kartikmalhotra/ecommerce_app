part of 'home_bloc.dart';

@immutable
abstract class HomeState extends Equatable {
  final RestAPIErrorModel? restAPIError;
  final VideoListModel? videoListModel;

  const HomeState({
    this.restAPIError,
    this.videoListModel,
  });
}

class HomeInitial extends HomeState {
  const HomeInitial();

  List<Object> get props => [];
}

/// Show Home Loader
class ShowHomeLoader extends HomeState {
  const ShowHomeLoader();

  @override
  List<Object> get props => [];
}

/// Home Data Loaded State
class HomeDataLoadedState extends HomeState {
  final RestAPIErrorModel? restAPIError;
  final VideoListModel? videoListModel;

  const HomeDataLoadedState({
    this.restAPIError,
    this.videoListModel,
  }) : super(
          restAPIError: restAPIError,
          videoListModel: videoListModel,
        );

  @override
  List<Object?> get props => [
        restAPIError,
        videoListModel,
      ];
}
