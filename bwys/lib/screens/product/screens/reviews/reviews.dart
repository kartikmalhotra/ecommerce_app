import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class RatingsReviews extends StatelessWidget {
  final Product product;

  const RatingsReviews({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            "Ratings & Reviews",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.l,
          ),
          Container(
            height: 100,
            width: double.maxFinite,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("${product.rating}",
                              style: Theme.of(context).textTheme.headline4),
                          Icon(Icons.star_border, color: Colors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey,
                  thickness: 1.5,
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
