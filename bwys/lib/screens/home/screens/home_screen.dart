import 'package:bwys/config/routes/routes_const.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/config/themes/light_theme.dart';
import 'package:bwys/screens/home/bloc/home_bloc.dart';
import 'package:bwys/screens/home/repository/repository.dart';
import 'package:bwys/shared/bloc/cart/bloc/cart_bloc.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:bwys/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class DisplayHomeScreen extends StatelessWidget {
  const DisplayHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SetAppScreenConfiguration.init(context);

    return BlocProvider<HomeBloc>(
      create: (BuildContext context) =>
          HomeBloc(homeRepository: HomeRepositoryImpl())
            ..add(GetHomeScreenData()),
      child: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late VideoPlayerController _videoController;
  late PageController _pageController;
  late int _currentPageIndex;
  bool isShowPlaying = false;

  @override
  void initState() {
    _currentPageIndex = 0;
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _videoController.dispose();
  }

  Widget isPlaying() {
    return _videoController.value.isPlaying && !isShowPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: LightAppColors.cardBackground.withOpacity(0.5),
          );
  }

  void _homeBlocListener(BuildContext context, HomeState homeState) {
    if (homeState is HomeDataLoadedState &&
        homeState.restAPIError == null &&
        homeState.videoListModel!.data.isNotEmpty) {
      loadVideoAsset(homeState.videoListModel!.data[0].videoUrl);
    }
  }

  void loadVideoAsset(String url) {
    _videoController = VideoPlayerController.asset(url)
      ..initialize().then((value) {
        _videoController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: _homeBlocListener,
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeDataLoadedState && state.restAPIError != null) {
            return AppShowError(error: state.restAPIError);
          } else if (state is HomeDataLoadedState &&
              state.restAPIError == null) {
            return _showVideoList(context, state);
          }
          return Center(child: AppCircularProgressLoader());
        },
      ),
    );
  }

  Widget _showVideoList(BuildContext context, HomeDataLoadedState state) {
    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: state.videoListModel!.data.length,
      onPageChanged: (index) => _pageChanged(index, state),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  _videoController.value.isPlaying
                      ? _videoController.pause()
                      : _videoController.play();
                });
              },
              child: Container(
                height: double.maxFinite,
                width: double.maxFinite,
                decoration: BoxDecoration(color: LightAppColors.blackColor),
                child: Stack(
                  children: <Widget>[
                    VideoPlayer(_videoController),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: isPlaying(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.only(left: 25.0, bottom: 25.0, top: 30.0),
              alignment: Alignment.topLeft,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            "B W Y S",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, AppRoutes.searchScreen),
                              icon: Icon(Icons.search, size: 25),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pushNamed(
                                  context, AppRoutes.cartScreen),
                              icon: Stack(
                                children: <Widget>[
                                  Icon(Icons.shopping_cart_rounded, size: 25),
                                  _displayCartItemsLength(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
              width: MediaQuery.of(context).size.width - 60.0,
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText(
                        "${state.videoListModel!.data[_currentPageIndex].name}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                      SizedBox(width: AppSpacing.xxl),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  AppText(
                    "${state.videoListModel!.data[_currentPageIndex].caption}",
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.favorite,
                        size: 35.0,
                        color: state.videoListModel!.data[_currentPageIndex]
                                .isFavourate
                            ? Colors.red
                            : Colors.white),
                    onPressed: () {
                      setState(() {
                        state.videoListModel!.data[_currentPageIndex]
                                .isFavourate =
                            !state.videoListModel!.data[_currentPageIndex]
                                .isFavourate;
                      });
                    },
                  ),
                  SizedBox(height: 3.0),
                  AppText(
                    "${state.videoListModel!.data[_currentPageIndex].likes}",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 35.0),
                  Icon(Icons.message, size: 35.0),
                  SizedBox(height: 3.0),
                  AppText(
                    "${state.videoListModel!.data[_currentPageIndex].comments}",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 35.0),
                  Icon(Icons.shopping_bag, size: 35.0),
                  AppText(
                    "Shop",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white),
                  )
                ],
              ),
            )
          ],
        );
      },
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

  void _pageChanged(int index, HomeDataLoadedState state) {
    setState(() {
      _currentPageIndex = index;
      loadVideoAsset(state.videoListModel!.data[_currentPageIndex].videoUrl);
    });
  }
}
