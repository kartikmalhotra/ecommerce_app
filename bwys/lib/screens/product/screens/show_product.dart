import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/screens/product/screens/product_desc.dart';
import 'package:bwys/screens/product/screens/image/product_image.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowProduct extends StatelessWidget {
  final Product product;

  const ShowProduct({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>.value(
      value: BlocProvider.of<CartBloc>(context),
      child: _showProduct(context),
    );
  }

  Widget _showProduct(context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          padding: EdgeInsets.all(3.0),
          icon: Container(
            width: 30.0,
            height: 30.0,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.grey[200]),
            child: Center(child: Icon(Icons.arrow_back, color: Colors.black)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            padding: EdgeInsets.all(3.0),
            icon: Center(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.share, color: Colors.black),
              ),
            ),
            onPressed: () {},
          ),
          IconButton(
            padding: EdgeInsets.all(3.0),
            icon: Center(
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_cart_rounded,
                          color: Colors.black),
                    ),
                  ),
                  _displayCartItemsLength(),
                ],
              ),
            ),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cartScreen),
          )
        ],
      ),
      body: Container(
        height: double.maxFinite,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocProvider<CartBloc>.value(
                value: BlocProvider.of<CartBloc>(context),
                child: DisplayProductImage(product: product),
              ),
              BlocProvider<CartBloc>.value(
                value: BlocProvider.of<CartBloc>(context),
                child: DisplayProductInfoScreen(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayCartItemsLength() {
    return BlocBuilder<CartBloc, CartState>(
      buildWhen: (previous, current) =>
          current is AddedToCart || current is RemovedFromCart,
      builder: (context, state) {
        if (state.cart?.isNotEmpty ?? false) {
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            width: 14.0,
            height: 14.0,
            child: Center(
              child: Text(
                "${state.cart!.length}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
