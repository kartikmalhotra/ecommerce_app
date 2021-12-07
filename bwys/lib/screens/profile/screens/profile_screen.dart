import 'package:bwys/config/screen_config.dart';
import 'package:bwys/utils/ui/ui_utils.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 0,
          child: Container(
            height: 300,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black12,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80",
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText("Tom Harris",
                          style: Theme.of(context).textTheme.headline6),
                      // ElevatedButton(
                      //   style: ButtonStyle(
                      //     backgroundColor:
                      //         MaterialStateProperty.all(Colors.black87),
                      //   ),
                      //   onPressed: () {},
                      //   child: Text("Follow"),
                      // )
                    ],
                  ),
                  AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AppText("India",
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                  AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                  Divider(color: Colors.grey[200], thickness: 5),
                  AppSizedBoxSpacing(heightSpacing: AppSpacing.s),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "42 K",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          AppSizedBoxSpacing(heightSpacing: AppSpacing.xs),
                          Text(
                            "Followers",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "5 M",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Views",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "5 K",
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Following",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
