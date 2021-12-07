import 'package:bwys/config/screen_config.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class SizeSelectWidget extends StatefulWidget {
  final Product product;
  const SizeSelectWidget({Key? key, required this.product}) : super(key: key);

  @override
  _SizeSelectWidgetState createState() => _SizeSelectWidgetState();
}

class _SizeSelectWidgetState extends State<SizeSelectWidget> {
  late Product product;

  _SizeSelectWidgetState();

  @override
  void initState() {
    product = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppText(
                "Select Size ",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              AppText(
                "Size chart",
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.redAccent, fontWeight: FontWeight.bold),
              )
            ],
          ),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.l),
          Container(
            height: 70,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: product.sizes.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () => setState(() {
                    product.sizes
                        .forEach((element) => element.isSelected = false);
                    product.sizes[index].isSelected = true;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Column(
                      children: [
                        Container(
                          width: 45.0,
                          height: 45.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              style: BorderStyle.solid,
                              color: product.sizes[index].isSelected
                                  ? Colors.redAccent
                                  : Colors.black,
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              "${product.sizes[index].size}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: product.sizes[index].isSelected
                                        ? Colors.redAccent
                                        : Colors.black,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        AppSizedBoxSpacing(heightSpacing: AppSpacing.xss),
                        AppText(
                          "Left ${product.sizes[index].noOfPiece}",
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: product.sizes[index].isSelected
                                        ? Colors.redAccent
                                        : Colors.black87,
                                  ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
