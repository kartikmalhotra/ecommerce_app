part of 'shop_bloc.dart';

abstract class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object> get props => [];
}

class GetShopDataEvent extends ShopEvent {
  const GetShopDataEvent();

  @override
  List<Object> get props => [];
}
