import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/data/data.dart';
import 'package:bwys/screens/product/screens/product_list.dart';
import 'package:bwys/screens/shop/bloc/shop_bloc.dart';
import 'package:bwys/screens/shop/repository/repository.dart';
import 'package:bwys/screens/shop/screens/screen_header.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ShopBloc>(
          create: (context) => ShopBloc(shopRepository: ShopRepositoryImpl())
            ..add(GetShopDataEvent()),
        )
      ],
      child: ShopScreenDisplay(),
    );
  }
}

class ShopScreenDisplay extends StatefulWidget {
  const ShopScreenDisplay({Key? key}) : super(key: key);

  @override
  _ShopScreenDisplayState createState() => _ShopScreenDisplayState();
}

class _ShopScreenDisplayState extends State<ShopScreenDisplay> {
  final ScrollController _categoryScrollController = ScrollController();
  final ScrollController _productScrollController = ScrollController();
  final ScrollController _newestProductScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      builder: (context, state) {
        if (state is ShopDataLoadedState && state.restAPIError == null) {
          return _displayShopScreenData(context, state);
        } else if (state is ShopDataLoadedState && state.restAPIError != null) {
          return Center(child: AppShowError(error: state.restAPIError));
        } else {
          return Center(child: AppCircularProgressLoader());
        }
      },
    );
  }

  Widget _displayShopScreenData(
      BuildContext context, ShopDataLoadedState state) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height + 140,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ScreenHeader(),
            AppDivider(),
            _screenBody(state),
          ],
        ),
      ),
    );
  }

  Widget _screenBody(ShopDataLoadedState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          /// Check whether to show banner or not
          if (state.showBanner) ...[
            AppSizedBoxSpacing(),
            _showBannersList(context),
          ],
          AppSizedBoxSpacing(),
          _showCategoryList(),
          _showPopularProductList(),
          AppSizedBoxSpacing(heightSpacing: AppSpacing.xxxxl),
          _showNewestProductList(),
          AppSizedBoxSpacing(),
        ],
      ),
    );
  }

  /// Banner List
  Widget _showBannersList(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 45.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(width: 1.0)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(20, 20),
                    child: AppText(
                      "Get 30 % off on every order",
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Category Data
  Widget _showCategoryList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              "Categories",
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () async {
                // Delay to make sure the frames are rendered properly
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _categoryScrollController.animateTo(
                      _categoryScrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                });
              },
            ),
          ],
        ),
        AppSizedBoxSpacing(),
        Container(
          height: 100.0,
          child: _displayCategoryList(),
        ),
      ],
    );
  }

  Widget _displayCategoryList() {
    return ListView.builder(
      controller: _categoryScrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: categoryItems.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, AppRoutes.categoryDetail,
                arguments: categoryItems[index]),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(categoryItems[index]["imageURl"]),
                      fit: BoxFit.cover,
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    shape: BoxShape.rectangle,
                    border: Border.all(width: 1.0),
                  ),
                  width: 50,
                  height: 50,
                  padding: EdgeInsets.all(10.0),
                ),
                AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                AppText(categoryItems[index]["name"]),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _showPopularProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Popular products",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold)),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () async {
                // Delay to make sure the frames are rendered properly
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _productScrollController.animateTo(
                      _productScrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                });
              },
            ),
          ],
        ),
        AppSizedBoxSpacing(heightSpacing: AppSpacing.l),
        _displayProductList(),
      ],
    );
  }

  Widget _displayProductList() {
    return Container(
      height: 200.0,
      child: ListView.builder(
        controller: _productScrollController,
        itemCount: demoProducts.length - 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: ProductList(
              product: demoProducts[index + 1],
              heroId: index + 300,
            ),
          );
        },
      ),
    );
  }

  Widget _showNewestProductList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText("Newest products",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(fontWeight: FontWeight.bold)),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: Icon(Icons.arrow_forward),
              color: Colors.black,
              onPressed: () async {
                // Delay to make sure the frames are rendered properly
                SchedulerBinding.instance?.addPostFrameCallback((_) {
                  _newestProductScrollController.animateTo(
                      _newestProductScrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                });
              },
            ),
          ],
        ),
        AppSizedBoxSpacing(heightSpacing: AppSpacing.xl),
        _displayNewProductList(),
      ],
    );
  }

  Widget _displayNewProductList() {
    return Container(
      height: 200.0,
      child: ListView.builder(
        controller: _newestProductScrollController,
        itemCount: demoProducts.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child:
                ProductList(product: demoProducts[index], heroId: 200 + index),
          );
        },
      ),
    );
  }
}
