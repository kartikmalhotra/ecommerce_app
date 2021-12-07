import 'package:bwys/config/screen_config.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>.value(
      value: BlocProvider.of<CartBloc>(context),
      child: DisplayCartScreen(),
    );
  }
}

class DisplayCartScreen extends StatefulWidget {
  const DisplayCartScreen({Key? key}) : super(key: key);

  @override
  _DisplayCartScreenState createState() => _DisplayCartScreenState();
}

class _DisplayCartScreenState extends State<DisplayCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _displayScreenBody(),
      ),
    );
  }

  Widget _displayScreenBody() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 0,
            child: _displayScreenHeader(),
          ),
          Expanded(
            flex: 1,
            child: _displayScreenDetail(),
          ),
        ],
      ),
    );
  }

  Widget _displayScreenDetail() {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, CartState cartState) {
        if (cartState.cart?.isNotEmpty ?? false) {
          return Container(
            height: double.maxFinite,
            child: _displayCartScreenData(context, cartState),
          );
        }
        return _nothingAddedToCart();
      },
    );
  }

  Widget _displayCartScreenData(BuildContext context, CartState cartState) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _displayCartItems(cartState),
        ),
        Expanded(
          flex: 0,
          child: _displayLowerBody(cartState),
        )
      ],
    );
  }

  Widget _displayCartItems(CartState cartState) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.all(20.0),
      itemCount: cartState.cart?.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(cartState.cart![index].images[0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => BlocProvider.of<CartBloc>(context)
                                  .add(RemoveFromCart(
                                      product: cartState.cart![index])),
                              child: Icon(Icons.close,
                                  color: Colors.black38, size: 17),
                            ),
                          ],
                        ),
                        AppText(
                          "${cartState.cart![index].title}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                        AppText(
                          "${cartState.cart![index].description}",
                          style: Theme.of(context).textTheme.caption!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AppText(
                              "₹ ${cartState.cart![index].price}",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink),
                            ),
                            AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
                            AppText(
                              "${cartState.cart![index].discount} % OFF",
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _displayLowerBody(CartState cartState) {
    return Column(
      children: [
        AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
        AppText("${cartState.cart!.length} Items selected for Order"),
        AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
        AppElevatedButton(
          color: Colors.black,
          message: 'Place order',
          onPressed: () {},
        ),
        AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
      ],
    );
  }

  /// Nothing added to cart
  Widget _nothingAddedToCart() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          "Hey! Looks like you have nothing added to the  cart",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
      ),
    );
  }

  /// HEADER
  Widget _displayScreenHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20.0),
        AppText('Shopping Cart', style: Theme.of(context).textTheme.headline6),
        SizedBox(height: 10.0),
        Divider(color: Colors.black),
      ],
    );
  }
}
