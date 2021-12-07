import 'package:bwys/data/data.dart';
import 'package:bwys/screens/product/screens/product_list.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(top: 20.0),
          color: Colors.white,
          child: Column(
            children: [
              AppText(category["name"],
                  style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 10.0),
              Divider(
                color: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 30.0,
                    crossAxisSpacing: 30.0,
                    childAspectRatio: 0.9,
                  ),
                  shrinkWrap: true,
                  itemCount: demoProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductList(
                      product: demoProducts[index],
                      heroId: index + 500,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
