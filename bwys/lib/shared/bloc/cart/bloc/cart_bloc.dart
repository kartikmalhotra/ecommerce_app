import 'package:bloc/bloc.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/shared/repository/cart_repository.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepositoryImpl cartRepository;

  CartBloc({required this.cartRepository}) : super(CartInitial());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is RemoveFromCart) {
      yield* _mapRemoveFromCartToState(event);
    } else if (event is AddToCart) {
      yield* _mapAddToCartToState(event);
    }
  }

  Stream<CartState> _mapAddToCartToState(AddToCart event) async* {
    cartRepository.add(event.product);
    yield AddedToCart(cart: cartRepository.cartList);
  }

  Stream<CartState> _mapRemoveFromCartToState(RemoveFromCart event) async* {
    cartRepository.remove(event.product);
    yield RemovedFromCart(cart: cartRepository.cartList);
  }
}
