import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            AppConstants.appName,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 21),
          ),
          ButtonBar(
            buttonPadding: EdgeInsets.zero,
            alignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: <Widget>[
                  IconButton(
                    constraints: BoxConstraints(),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.cartScreen,
                    ),
                    icon: Stack(
                      children: <Widget>[
                        Icon(Icons.shopping_cart_rounded, color: Colors.black),
                      ],
                    ),
                    tooltip: 'Shopping cart',
                    padding: EdgeInsets.all(0.0),
                  ),
                  _displayCartItemsLength(),
                ],
              ),
              AppSizedBoxSpacing(widthSpacing: AppSpacing.l),
              IconButton(
                constraints: BoxConstraints(),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.searchScreen),
                icon: Icon(Icons.search, color: Colors.black),
                tooltip: 'Search',
                padding: EdgeInsets.all(0.0),
              )
            ],
          ),
        ],
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
