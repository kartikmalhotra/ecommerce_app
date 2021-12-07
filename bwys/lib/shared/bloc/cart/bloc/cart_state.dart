part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  final List<Product>? cart;

  const CartState({this.cart});

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class AddedToCart extends CartState {
  final List<Product> cart;

  const AddedToCart({required this.cart}) : super(cart: cart);

  List<Object> get props => [cart];
}

class RemovedFromCart extends CartState {
  final List<Product> cart;

  const RemovedFromCart({required this.cart}) : super(cart: cart);

  List<Object> get props => [cart];
}
