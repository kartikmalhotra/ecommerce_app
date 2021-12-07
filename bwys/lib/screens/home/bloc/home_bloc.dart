import 'package:bwys/data/data.dart';
import 'package:bwys/screens/home/model/home_model.dart';
import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;

  HomeBloc({required this.homeRepository}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is GetHomeScreenData) {
      yield* _mapGetHomeScreenDataToState();
    }
  }

  Stream<HomeState> _mapGetHomeScreenDataToState() async* {
    yield ShowHomeLoader();

    // do something to wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2), () {});

    /// TODO: API for Fetching video List
    /// var response = await homeRepository.fetchVideoCategoryList();

    var response = items;

    /// If there is no RestAPIErrorModel && RestAPIUnAuthenticationModel
    if (response is! RestAPIErrorModel &&
        response is! RestAPIUnAuthenticationModel) {
      VideoListModel data = VideoListModel.fromJson({'data': response});
      yield HomeDataLoadedState(videoListModel: data);
    }

    /// If there is no RestAPIErrorModel
    else if (response is RestAPIErrorModel) {
      // yield HomeDataLoadedState(restAPIError: response);
    }
  }
}
