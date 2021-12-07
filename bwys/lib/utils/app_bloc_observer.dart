import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/utils/services/log_service.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    Application.logService!
        .log('AppBlocObserver::: onEvent : $event', type: Log.INFO);
    super.onEvent(bloc, event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    Application.logService!
        .log('AppBlocObserver::: onTransition : $transition', type: Log.INFO);
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase blocBase, Change change) {
    if (blocBase is! Bloc) {
      Application.logService!.log(
        'AppBlocObserver::: cubit :: onChange : $change',
        type: Log.INFO,
      );
    }
    super.onChange(blocBase, change);
  }

  @override
  void onError(BlocBase blocBase, Object error, StackTrace stackTrace) {
    Application.logService!.log(
      'AppBlocObserver::: onError : $error $stackTrace',
      type: Log.ERROR,
    );
    super.onError(blocBase, error, stackTrace);
  }
}
