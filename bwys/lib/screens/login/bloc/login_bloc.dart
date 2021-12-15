import 'package:bloc/bloc.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/data/data.dart';
import 'package:bwys/screens/login/repository/repository.dart';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is SignInButtonPressed) {
      yield* _mapSignInButtonPressedToState(event);
    }
  }

  Stream<LoginState> _mapSignInButtonPressedToState(
      SignInButtonPressed event) async* {
    bool userSignedIn = false;
    Map<String, dynamic>? checkUser = checkUserValid(event.cred);

    if (checkUser != null) {
      userSignedIn = true;
      Application.secureStorageService!.username =
          Future.value(checkUser["user_name"]);
      Application.secureStorageService!.password =
          Future.value(checkUser["password"]);
      BWYSUser.userName = checkUser["user_name"];
      BWYSUser.email = checkUser["email"];
    } else {
      userSignedIn = false;
    }
    yield SignInResult(userSignedIn: userSignedIn);
  }

  Map<String, dynamic>? checkUserValid(Map<String, dynamic> cred) {
    for (int i = 0; i < userNamePassword.length; i++) {
      if (userNamePassword[i]["email"] == cred["email"] &&
          userNamePassword[i]["password"] == cred["password"]) {
        return userNamePassword[i];
      }
    }
    return null;
  }
}
