import 'package:bwys/bwys_app.dart';
import 'package:bwys/config/application.dart';
import 'package:bwys/config/routes/routes.dart';
import 'package:bwys/utils/services/local_storage_service.dart';
import 'package:bwys/utils/services/log_service.dart';
import 'package:bwys/utils/services/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Application.secureStorageService = SecureStorageService.getInstance();
  Application.storageService = await LocalStorageService?.getInstance();
  Application.logService = LogService.getInstance();

  Application.isDeviceAuthAvailable =
      Application.storageService!.isDeviceAuthAvailable;

  /// Store application prefered theme in the Application class
  Application.preferedTheme = Application.storageService!.themeMode;

  /// Store application language in the Application class
  Application.preferedLanguage = Application.storageService!.selectedLanguage;

  BWYSUser.isUserLoggedIn = Application.storageService!.isUserLoggedIn;

  RouteSetting.getInstance();
  runApp(BwysApp());
}
