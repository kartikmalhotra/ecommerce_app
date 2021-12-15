import 'dart:async';
import 'dart:io' show Platform;

import 'package:bwys/shared/bloc/web_socket/bloc/web_socket_bloc.dart';
import 'package:bwys/shared/models/broadcasts_model.dart';
import 'package:bwys/shared/models/notification_model.dart';
import 'package:bwys/shared/models/pnm_app_constants_model.dart';
import 'package:bwys/shared/models/tool_tips_model.dart';
import 'package:bwys/shared/repository/user_repository.dart';
import 'package:bwys/utils/services/common_service.dart';
import 'package:bwys/utils/services/local_storage_service.dart';
import 'package:bwys/utils/services/log_service.dart';
import 'package:bwys/utils/services/native_api_service.dart';
import 'package:bwys/utils/services/rest_api_service.dart';
import 'package:bwys/utils/services/secure_storage_service.dart';
import 'package:bwys/utils/services/timezone_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class Application {
  static String? preferedLanguage;
  static String? preferedTheme;
  static Brightness? hostSystemBrightness;
  static LocalStorageService? storageService;
  static SecureStorageService? secureStorageService;
  static RestAPIService? restService;
  static TimezoneService? timezoneService;
  static NativeAPIService? nativeAPIService;
  static CommonService? commonService;
  // static FirebaseAnalytics? firebaseAnalytics;

  // static CrashlyticsService crashlyticsService;
  static LogService? logService;
  static WebSocketServiceBloc? webSocketServiceBloc;

  static UserRepository? userRepository;

  static bool? isDeviceAuthAvailable;
  static List<BiometricType> enrolledBiometrics = [];

  static TargetPlatform platform =
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;

  static List<Broadcast>? broadcasts;

  /// TODO: Firebase
  /// static FirebaseMessagingService firebaseMessagingService;

  /// Key created for accessing navigator in notification tap callback
  static GlobalKey<NavigatorState>? navigatorKey;

  /// Variable to hold notification data temporarily when notification is tapped
  /// when app is closed, that tap will be handled after app is initialized and
  /// user has logged in
  static NotificationData? tappedNotificationData;

  /// Notifications stream
  static late StreamController<NotificationData> notificationStreamController;
}

class BWYSUser {
  static String? userToken;
  static int? userId;
  static int? userType;
  static String? uid;
  static late bool isUserLoggedIn;
  static String? userName;
  static String? email;
  static late bool isLicenseAccepted;
}

class BWYS {
  static Map<String, bool> modules = {};
}

class BWYSConstants {
  static BWYSAppConstants? pnmAppConstants;
  static ToolTipsData? toolTips;
}
