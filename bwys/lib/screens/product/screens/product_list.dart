import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  final Product product;
  final int heroId;

  const ProductList({
    Key? key,
    required this.product,
    required this.heroId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: double.maxFinite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: AppPhotoHero(
              id: heroId,
              height: double.maxFinite,
              onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail,
                  arguments: product),
              width: double.maxFinite,
              photo: product.images[0],
            ),
          ),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppText(
                  "${product.title}",
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.xss),
          Wrap(
            children: [
              AppText(
                "₹ ${product.price}",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              AppText(
                "${product.discount}% OFF",
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.pinkAccent),
              ),
              Wrap(
                runSpacing: 0,
                children: <Widget>[
                  Icon(Icons.star_half, color: Colors.orange, size: 15),
                  AppText(
                    "${product.rating}",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
