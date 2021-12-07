part of 'shop_bloc.dart';

abstract class ShopState extends Equatable {
  final bool showBanner;

  const ShopState({this.showBanner = false});

  @override
  List<Object?> get props => [showBanner];
}

class ShopInitial extends ShopState {
  const ShopInitial();

  @override
  List<Object> get props => [];
}

/// Show Shop Loader
class ShowShopLoader extends ShopState {
  const ShowShopLoader();

  @override
  List<Object> get props => [];
}

class ShopDataLoadedState extends ShopState {
  final bool showBanner;
  final RestAPIErrorModel? restAPIError;

  const ShopDataLoadedState({
    this.restAPIError,
    this.showBanner = false,
  }) : super();

  @override
  List<Object?> get props => [
        restAPIError,
        showBanner,
      ];
}
