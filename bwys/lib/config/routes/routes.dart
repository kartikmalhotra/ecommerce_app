import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/main.dart';
import 'package:bwys/screens/cart/screens/cart_screen.dart';
import 'package:bwys/screens/category/screens/category_screen.dart';
import 'package:bwys/screens/product/model/product_model.dart';
import 'package:bwys/screens/product/screens/show_product.dart';
import 'package:bwys/screens/search/screens/search.dart';
import 'package:bwys/screens/signin/screens/signin.dart';
import 'package:bwys/screens/signup/screens/signup.dart';
import 'package:bwys/screens/splash_screen/screen/splash_screen.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:bwys/shared/repository/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteSetting {
  static RouteSetting? _routeSetting;
  static CartBloc? _cartBloc;

  RouteSetting._internal();

  static RouteSetting? getInstance() {
    if (_routeSetting == null) {
      _initializeBloc();
      _routeSetting = RouteSetting._internal();
    }
    return _routeSetting;
  }

  static void _initializeBloc() {
    _cartBloc = CartBloc(cartRepository: CartRepositoryImpl());
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.root:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CartBloc>.value(
            value: _cartBloc!,
            child: AppScreen(),
          ),
        );
      case AppRoutes.signIn:
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case AppRoutes.signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case AppRoutes.productDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CartBloc>.value(
            value: _cartBloc!,
            child: ShowProduct(product: (settings.arguments as Product)),
          ),
        );
      case AppRoutes.categoryDetail:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CartBloc>.value(
            value: _cartBloc!,
            child: CategoryScreen(
                category: settings.arguments as Map<String, dynamic>),
          ),
        );
      case AppRoutes.cartScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CartBloc>.value(
            value: _cartBloc!,
            child: CartScreen(),
          ),
        );
      case AppRoutes.searchScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<CartBloc>.value(
            value: _cartBloc!,
            child: SearchScreen(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
