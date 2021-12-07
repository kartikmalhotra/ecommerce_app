
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class DisplayProductImage extends StatelessWidget {
  final Product product;

  const DisplayProductImage({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(
        children: <Widget>[
          AppPhotoHero(
            id: product.id,
            photo: product.images[0],
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.white),
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs, vertical: AppSpacing.xsss),
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          "${product.rating}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        VerticalDivider(color: Colors.black),
                        Text(
                          "${product.totalRating}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
