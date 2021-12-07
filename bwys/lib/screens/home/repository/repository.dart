import 'package:bwys/config/application.dart';
import 'package:bwys/constants/app_constants.dart';
import 'package:bwys/constants/path/api_path.dart';
import 'package:bwys/shared/models/rest_api_error_model.dart';
import 'package:bwys/utils/services/rest_api_service.dart';

abstract class HomeRepository {
  Future<dynamic> fetchVideoCategoryList();
}

class HomeRepositoryImpl extends HomeRepository {
  @override
  Future<dynamic> fetchVideoCategoryList() async {
    try {
      final response = Application.restService!.requestCall(
        apiEndPoint: BWYSRestEndPoints.videoList,
        method: RestAPIRequestMethods.GET,
      );
      return response;
    } catch (e) {
      final Map<String, String> errorResponse =
          Application.restService!.getErrorResponse(e as RestAPICallException);
      return RestAPIErrorModel.fromJson(errorResponse);
    }
  }
}
