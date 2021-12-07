import 'package:bloc/bloc.dart';
import 'package:bwys/data/data.dart';
import 'package:bwys/screens/shop/repository/repository.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:equatable/equatable.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository shopRepository;

  ShopBloc({required this.shopRepository}) : super(ShopInitial());

  @override
  Stream<ShopState> mapEventToState(ShopEvent event) async* {
    if (event is GetShopDataEvent) {
      yield* _mapGetShopDataToState();
    }
  }

  Stream<ShopState> _mapGetShopDataToState() async* {
    yield ShowShopLoader();

    // do something to wait for 2 seconds
    await Future.delayed(const Duration(seconds: 2), () {});

    /// TODO: API for Fetching video List
    /// var response = await homeRepository.fetchVideoCategoryList();

    var response = categoryItems;

    /// If there is no RestAPIErrorModel && RestAPIUnAuthenticationModel
    if (response is! RestAPIErrorModel &&
        response is! RestAPIUnAuthenticationModel) {
         yield ShopDataLoadedState();
    }

    /// If there is no RestAPIErrorModel
    else if (response is RestAPIErrorModel) {
      // yield HomeDataLoadedState(restAPIError: response);
    }
  }
}
