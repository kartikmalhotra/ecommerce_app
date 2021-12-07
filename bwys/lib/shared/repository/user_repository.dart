import 'dart:convert';
import 'dart:io';

import 'package:bwys/config/application.dart';
import 'package:bwys/config/screen_config.dart';
import 'package:bwys/constants/path/api_path.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/shared/models/pnm_user_model.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/shared/models/upload_file_models.dart';
import 'package:bwys/utils/services/log_service.dart';
import 'package:bwys/utils/services/rest_api_service.dart';

abstract class UserRepository {
  /// Getters and Setters for user data
  PNMUserProfileModel? get userModelData => null;
  set userProfileModelData(PNMUserProfileModel data);

  /// Authenticate user
  Future<dynamic> authenticateUser(String username, String password);

  /// Logout user
  Future<dynamic> logoutUser();

  /// Delete User Token
  Future<void> deleteUserToken();

  /// Delete user credentials from secure storage
  Future<void> deleteUserCredentials();

  /// Store user credentials inside secure storage
  Future<void> storeUserCredentials(Map<String, String> userData);

  /// Get user token from secure storage
  Future<String> getUserToken();

  /// Get user Data from remote
  Future<dynamic> getUserData();

  /// Parse user token
  Future<dynamic> parseUserToken(String authToken,
      {Map<String, dynamic>? userAuthDataToStore});

  /// Change User Password on remote
  Future<dynamic> changePassword(Map<String, String> data);

  /// Update User password in secure storage
  Future<void> updateUserPassword(String password);

  /// Update User settings on remote
  Future<dynamic> updateUserSettingsOnRemote(Map<String, dynamic>? data);

  /// Initialize user timezone data
  void intiializeUserTimezoneData(Map<String, dynamic> data);

  /// Reset User global data, timezonedata, user shared pref data
  void resetUserGlobalData();

  /// Get user profile image from remote
  Future<void> getUserProfileImage();

  /// Upload user profile image on remote
  Future<dynamic> uploadUserProfileImage(File? image);

  /// Accept the User License agreement (EULA)
  Future<dynamic> acceptEULA(Map<String, String?> userCredentials);

  /// Fetch the user unsubmitted fixed impairments feedback data
  Future<dynamic> fetchUserUnsubmittedFeedbackData();

  /// Fetch the user submitted fixed impairments feedback data
  Future<dynamic> fetchUserSubmittedFeedbackData();

  /// Update fcm device token on server
  Future<dynamic> updateFcmDeviceToken(String newToken);

  /// Get notifications
  Future<dynamic> getNotifications();

  /// Mark all notifications as read
  Future<dynamic> markAllNotificationsAsRead();

  /// Mark specific notifications as read
  Future<dynamic> markNotificationsAsRead(int? notificationId);

  /// Get User color settings
  Future<dynamic> getUserColorSettings();
}

class UserRepositoryImpl implements UserRepository {
  PNMUserProfileModel? userModelData;

  /// Setter for user profile Data.
  @override
  set userProfileModelData(PNMUserProfileModel? data) {
    userModelData = data;
  }

  @override
  Future<dynamic> authenticateUser(String username, String password) async {
    Map<String, String?> _requestParams = {
      "username": username,
      "password": password
    };
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.login,
          method: RestAPIRequestMethods.POST,
          requestParmas: _requestParams);
      if (response is! RestAPIUnAuthenticationModel) {
        _requestParams['token'] = response["token"];

        /// Parse the token and store the credentials and auth token in secure storage
        await parseUserToken(response["token"],
            userAuthDataToStore: _requestParams);

        return response;
      } else if (response is RestAPIUnAuthenticationModel) {
        final Map<String, String?> errorResponse = {
          "code": response.code.toString(),
          "message": response.message,
          "remaining_attempts": response.loginAttemptsRemaining.toString(),
        };
        return RestAPIErrorModel.fromJson(errorResponse);
      }
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> logoutUser() async {
    try {
      Map<String, dynamic> _replaceParam = {'id': BWYSUser.userId};
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.logout,
          method: RestAPIRequestMethods.DELETE,
          replaceParam: _replaceParam);

      /// Delete user credentials
      await deleteUserCredentials();
      resetUserGlobalData();

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<void> deleteUserToken() async {
    await Application.secureStorageService!
        .deleteDataFromSecureStorage(AppSecureStoragePreferencesKeys.authToken);
  }

  @override
  Future<void> deleteUserCredentials() async {
    await Application.secureStorageService!.deleteAllDataFromSecureStorage();
  }

  @override
  Future<void> storeUserCredentials(Map<String, String?> userData) async {
    /// Store user auth token
    Application.secureStorageService!.authToken =
        Future.value(userData['token']);

    /// Store username
    Application.secureStorageService!.username =
        Future.value(userData['username']);

    /// Store user password
    Application.secureStorageService!.password =
        Future.value(userData['password']);
  }

  @override
  Future<String> getUserToken() async {
    return await Application.secureStorageService!.authToken;
  }

  @override
  Future<dynamic> getUserData() async {
    try {
      Map<String, dynamic> _replaceParam = {'id': BWYSUser.userId};
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.userDetail,
          method: RestAPIRequestMethods.GET,
          replaceParam: _replaceParam);

      /// Check if response is not unauthorized
      if (response is! RestAPIUnAuthenticationModel) {
        initializeUserProfileData(response);
        intiializeUserTimezoneData(response['UserSetting']);
      }
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> parseUserToken(String token,
      {Map<String, dynamic>? userAuthDataToStore}) async {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception("0001:::invalid token");
    }
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);

    /// Throw expection if payloadMap is not Map
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception("0001:::invalid token");
    }

    /// Append the user auth Data in payLoad Map to store it in secure storage
    if (userAuthDataToStore != null) {
      payloadMap['username'] = userAuthDataToStore['username'];
      payloadMap['password'] = userAuthDataToStore['password'];
      payloadMap['token'] = userAuthDataToStore['token'];
    }

    /// initialize the user auth data
    await initializeUserAuthData(token, payloadMap);
    return payloadMap;
  }

  /// Change user password (Called from user profile when user is already logged in)
  @override
  Future<dynamic> changePassword(Map<String, String> _requestParams) async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.changePassword,
          method: RestAPIRequestMethods.PATCH,
          requestParmas: _requestParams);

      /// Check if user has updated the password successfully
      if ((response is! RestAPIUnAuthenticationModel) &&
          (response['success'])) {
        await updateUserPassword(_requestParams['password']);
      }
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<void> updateUserPassword(String? password) async {
    /// update user password
    Application.secureStorageService!.password = Future.value(password);
  }

  @override
  Future updateUserSettingsOnRemote(Map<String, dynamic>? data) async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.userSettings,
          method: RestAPIRequestMethods.PATCH,
          requestParmas: data);
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  /// Initialize the timezone data
  @override
  void intiializeUserTimezoneData(Map<String, dynamic> timezone) {
    Application.timezoneService!.timezoneId = timezone['timezone_id'];

    Map<String, dynamic>? _timezoneData = timezone['Timezone'];

    if (_timezoneData != null) {
      Application.timezoneService!.timezoneName = _timezoneData['name'];
    }
  }

  @override
  void resetUserGlobalData() {
    /// Reset Timezone Data
    resetTimezoneData();

    BWYSUser.isUserLoggedIn = false;
    BWYSUser.isLicenseAccepted = false;
    BWYSUser.userToken = null;
    BWYSUser.userId = null;
    BWYSUser.userType = null;
    BWYSUser.uid = null;
    BWYSUser.firstName = null;
    BWYSUser.lastName = null;
    BWYSUser.isLDAPUser = false;
    // BWYSUser.userUpstreamColumns = null;

    userProfileModelData = null;
    userModelData = null;

    Application.storageService!.isUserLoggedIn = false;
    // Application.storageService!.recentSearches = RecentSearchesModel();
    // Application.storageService!.inProgressTroubleshootData =
    //     IFixedItTroubleshootModel(inProgress: []);

    /// Reset FCM Device Token
    /// TODO: Firebase
    // Application.firebaseMessagingService.deleteActiveFCMToken();
  }

  @override
  Future getUserProfileImage() async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.userProfileImage,
          method: RestAPIRequestMethods.GET,
          isFileRequest: true);
      userModelData!.profileImage = response['file'];
    } catch (_) {
      userModelData!.profileImage = null;
    }

    /// update the [userProfileModelData]
    userProfileModelData = userModelData;
  }

  @override
  Future uploadUserProfileImage(File? image) async {
    try {
      final response = await Application.restService!.multiPartRequestCall(
          apiEndPoint: BWYSRestEndPoints.userProfileImage,
          method: "PUT",
          files: [UploadFile(filePath: image!.path)]);

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> acceptEULA(Map<String, String?> userCredentials) async {
    try {
      final response = await Application.restService!.requestCall(
        apiEndPoint: BWYSRestEndPoints.acceptLicense,
        requestParmas: {},
        method: RestAPIRequestMethods.PATCH,
      );

      /// Check if user has accepted the license agreement (EULA) successfully
      if ((response is! RestAPIUnAuthenticationModel) &&
          (response['success'] != null) &&
          (response['success'])) {
        /// Append auth token in userCredentials
        userCredentials['token'] = BWYSUser.userToken;

        /// Store the credentials in secure storage
        await storeUserCredentials(userCredentials);

        /// Set logged in flag to true in the shared preference
        Application.storageService!.isUserLoggedIn = true;
        BWYSUser.isUserLoggedIn = true;

        /// Update the License agreement accepted status
        BWYSUser.isLicenseAccepted = true;
      }

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> fetchUserUnsubmittedFeedbackData() async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint:
              '${BWYSRestEndPoints.unsubmittedFixedImpairments}?user_id=${BWYSUser.userId}',
          method: RestAPIRequestMethods.GET);

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);

      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> fetchUserSubmittedFeedbackData() async {
    try {
      final response = await Application.restService!.requestCall(
          apiEndPoint:
              '${BWYSRestEndPoints.submittedFixedImpairments}?user_id=${BWYSUser.userId}',
          method: RestAPIRequestMethods.GET);

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);

      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> updateFcmDeviceToken(String newToken) async {
    try {
      Map<String, String> _requestParams = {
        "device_token": newToken,
        "device_type":
            AppDevice.type == Device.mobile || AppDevice.type == Device.tablet
                ? "android"
                : "ios",
      };

      final response = await Application.restService!.requestCall(
        apiEndPoint: BWYSRestEndPoints.updateUserDeviceToken,
        method: RestAPIRequestMethods.POST,
        requestParmas: _requestParams,
      );

      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);

      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> getNotifications() async {
    try {
      /// Fetch notifications list
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.notificationsList,
          method: RestAPIRequestMethods.GET);
      Application.logService!.log(response, type: Log.PRIVATE);
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> markAllNotificationsAsRead() async {
    try {
      /// Mark all notifications as read
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.markNotificationsAsRead,
          method: RestAPIRequestMethods.PATCH,
          requestParmas: {"mark_all_as_read": true});
      Application.logService!.log(response.toString(), type: Log.PRIVATE);
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> markNotificationsAsRead(int? notificationId) async {
    try {
      /// Mark specific notifications as read
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.markNotificationsAsRead,
          method: RestAPIRequestMethods.PATCH,
          requestParmas: {"id": notificationId, "mark_all_as_read": false});
      Application.logService!.log(response, type: Log.PRIVATE);
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  @override
  Future<dynamic> getUserColorSettings() async {
    try {
      /// Fetch user color settings
      final response = await Application.restService!.requestCall(
          apiEndPoint: BWYSRestEndPoints.userColorSettings,
          method: RestAPIRequestMethods.GET);
      Application.logService!.log(response, type: Log.PRIVATE);
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception("0001:::invalid token");
    }
    return utf8.decode(base64Url.decode(output));
  }

  Future<void> initializeUserAuthData(
      String token, Map<String, dynamic> payloadData) async {
    BWYSUser.userToken = token;
    BWYSUser.userType = payloadData["user_type"];
    BWYSUser.uid = payloadData["uId"];
    BWYSUser.userId = payloadData["user_id"];
    BWYSUser.isLicenseAccepted = payloadData["license_accepted"] ?? false;

    if (BWYSUser.isLicenseAccepted && payloadData['username'] != null) {
      /// prepare data to store in secure storage
      Map<String, String?> _userCredenToStore = {
        'username': payloadData['username'],
        'password': payloadData['password'],
        'token': payloadData['token']
      };

      /// Store the credentials in secure storage
      await storeUserCredentials(_userCredenToStore);

      /// Set logged in flag to true in the shared preference
      Application.storageService!.isUserLoggedIn = true;
      BWYSUser.isUserLoggedIn = true;
    }

    /// TODO: Crashlytics
    /// Application.crashlyticsService.addCrashlyticsCustomKeys();
  }

  void initializeUserProfileData(Map<String, dynamic> response) {
    BWYSUser.firstName = response['first_name'];
    BWYSUser.lastName = response['last_name'];
    BWYSUser.isLDAPUser = response['is_ldap_user'] ?? false;
  }

  void resetTimezoneData() {
    Application.timezoneService!.timezoneId = null;
    Application.timezoneService!.timezoneName = null;
  }
}
