import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bwys/config/application.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/utils/services/log_service.dart';

class SecureStorageService {
  static SecureStorageService? _instance;
  static FlutterSecureStorage? _preferences;

  SecureStorageService._internal();

  static SecureStorageService? getInstance() {
    if (_instance == null) {
      _instance = SecureStorageService._internal();
    }
    if (_preferences == null) {
      _preferences = const FlutterSecureStorage();
    }

    return _instance;
  }

  Future<String> get username async =>
      await (_getDataFromSecureStorage(AppSecureStoragePreferencesKeys.username)
          as FutureOr<String>?) ??
      "";

  set username(Future<String> value) =>
      _saveDataToSecureStorage(AppSecureStoragePreferencesKeys.username, value);

  Future<String> get password async =>
      await (_getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.userPassword) as FutureOr<String>?) ??
      "";

  set password(Future<String> value) => _saveDataToSecureStorage(
      AppSecureStoragePreferencesKeys.userPassword, value);

  Future<String> get authToken async =>
      await (_getDataFromSecureStorage(
          AppSecureStoragePreferencesKeys.authToken)) ??
      "";

  set authToken(Future<String> value) => _saveDataToSecureStorage(
      AppSecureStoragePreferencesKeys.authToken, value);

  Future<String?> _getDataFromSecureStorage(String key) async {
    String? value = await _preferences!.read(key: key);
    Application.logService!.log(
      '(TRACE) SecureStorageService:_getDataFromSecureStorage. key: $key value: $value',
      type: Log.PRIVATE,
    );
    return value;
  }

  // Future<Map<String, String>> _getAllDataFromSecureStorage() async {
  //   Map<String, String> allValues = await _preferences.readAll();
  //   Application.logService.log(
  //     '(TRACE) SecureStorageService:_getAllDataFromSecureStorage. values: $allValues',
  //     type: Log.PRIVATE,
  //   );
  //   return allValues;
  // }

  Future<void> deleteDataFromSecureStorage(String key) async {
    await _preferences!.delete(key: key);
  }

  Future<void> deleteAllDataFromSecureStorage() async {
    await _preferences!.deleteAll();
  }

  Future<void> _saveDataToSecureStorage(
      String key, Future<String> value) async {
    Application.logService!.log(
      '(TRACE) SecureStorageService:_saveDataToSecureStorage. key: $key value: ${await value}',
      type: Log.PRIVATE,
    );
    await _preferences!.write(key: key, value: await value);
  }
}
