import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/screens/product/screens/emi/emi_options_available.dart';
import 'package:bwys/screens/product/screens/coupon/product_coupon.dart';
import 'package:bwys/screens/product/screens/return_policy/return_policy.dart';
import 'package:bwys/screens/product/screens/size/size_select.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

class DisplayProductInfoScreen extends StatelessWidget {
  final Product product;
  const DisplayProductInfoScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>.value(
      value: BlocProvider.of<CartBloc>(context),
      child: DisplayProductInfo(product: product),
    );
  }
}

class DisplayProductInfo extends StatefulWidget {
  final Product product;
  const DisplayProductInfo({Key? key, required this.product}) : super(key: key);

  @override
  _DisplayProductInfoState createState() => _DisplayProductInfoState();
}

class DisplayProductInfoState extends StatefulWidget {
  final Product product;
  const DisplayProductInfoState({Key? key, required this.product})
      : super(key: key);

  @override
  _DisplayProductInfoState createState() => _DisplayProductInfoState();
}

class _DisplayProductInfoState extends State<DisplayProductInfo> {
  late Product product;
  late int noOfProduct;

  @override
  void initState() {
    /// Clear the previously selected Products

    // Remove data from default Bucket
    // Application.shoppingCart!.defaultBucket.clear();
    noOfProduct = 0;
    product = widget.product;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _showProductTitle(context),
        Divider(
          color: Colors.grey[200],
          thickness: 10.0,
        ),
        ProductCoupon(product: product),
        Divider(
          color: Colors.grey[200],
          thickness: 1.0,
        ),
        EmiOptionsAvailable(),
        Divider(
          color: Colors.grey[200],
          thickness: 10.0,
        ),
        ReturnPolicy(),
        Divider(
          color: Colors.grey[200],
          thickness: 10.0,
        ),
        if (product.sizes.isNotEmpty) ...[
          SizeSelectWidget(product: product),
          Divider(
            color: Colors.grey[200],
            thickness: 10.0,
          ),
        ],
        _waitListAddToCart(),
        Divider(
          color: Colors.grey[200],
          thickness: 10.0,
        ),
        _showProductDetails(),
        Divider(
          color: Colors.grey[200],
          thickness: 10.0,
        ),
        // RatingsReviews(product: product),
      ],
    );
  }

  Widget _showProductTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText("${product.title}",
              style: Theme.of(context).textTheme.headline6),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
          AppText("${product.description}",
              style: Theme.of(context).textTheme.bodyText1),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
          Wrap(
            runSpacing: 2.0,
            spacing: 5.0,
            children: [
              AppText(
                "Pay only : ",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              AppText(
                "₹ ${product.price}",
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
              AppText("(${product.discount}% OFF)",
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            ],
          ),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.xss),
          AppText("inclusive of all taxes",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.green)),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
        ],
      ),
    );
  }

  Widget _waitListAddToCart() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AppOutlinedButton(
            borderAndTextColor: Colors.black,
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            message: "WISHLIST",
            onPressed: () {},
          ),
          BlocBuilder<CartBloc, CartState>(
            buildWhen: (previous, current) =>
                current is AddedToCart || current is RemovedFromCart,
            builder: (BuildContext context, CartState state) {
              return AppElevatedButton(
                icon: Icons.shopping_bag,
                borderRadius: 0,
                color: Colors.redAccent[400],
                message: BlocProvider.of<CartBloc>(context)
                        .cartRepository
                        .isExists(product)
                    ? "ADDED TO CART"
                    : "ADD TO CART",
                onPressed: () {
                  if (checkSizeSelected(product.sizes)) {
                    BlocProvider.of<CartBloc>(context)
                        .add(AddToCart(product: product));
                  } else {
                    CommonUtils.appShowSnackBar(
                      context,
                      'Please Select size',
                      snackBarDuration: Duration(seconds: 1),
                    );
                    HapticFeedback.vibrate();
                  }
                },
              );
            },
          )
        ],
      ),
    );
  }

  Widget _showProductDetails() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Product Detail",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.xs,
          ),
          AppText("${product.description}"),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.s,
          )
        ],
      ),
    );
  }

  bool checkSizeSelected(List<ProductSizes> sizes) {
    return sizes.any((size) => size.isSelected);
  }
}
