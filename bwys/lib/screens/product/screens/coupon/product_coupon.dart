import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProductCoupon extends StatelessWidget {
  final Product product;

  const ProductCoupon({
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppRichText(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "You Pay Only : ",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextSpan(
                      text: "₹ ${product.price - 300}",
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.pink),
                    ),
                  ],
                ),
              ),
              Text(
                "Save: ₹400",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              )
            ],
          ),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.xs,
          ),
          AppText("Apply the coupon during checkout",
              style: Theme.of(context).textTheme.bodyText1!),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.xss,
          ),
          AppText("Order above Rs 2000 (only on first purchase) T&C apply",
              style: Theme.of(context).textTheme.bodyText1!),
          AppSizedBoxSpacing(
            heightSpacing: AppSpacing.s,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.orange[100],
                padding: EdgeInsets.all(8.0),
                child: AppText(
                  "BWYS300",
                  isSelectable: true,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
              SizedBox(width: 20.0),
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: "BWYS300"));
                  CommonUtils.appShowSnackBar(
                      context, "Coupon copied successfuly BWYS300",
                      snackBarDuration: Duration(seconds: 1));
                },
                child: Text(
                  "Tap to copy",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.black54),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
