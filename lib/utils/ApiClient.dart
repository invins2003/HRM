
import 'package:get/get_connect/connect.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

import 'AppLogger.dart';

///with Get Api Client
class ApiClient extends GetConnect implements GetxService {
  final String appBaseUrl;
  final AppLogger logger = AppLogger(); // Initialize the logger

  ApiClient({required this.appBaseUrl}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 120);
  }

  /// 🔑 Always build headers fresh with latest token
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
  }

  ///Get Method only url
  Future<Response> getData(String uri) async {
    try {
      final headers = await _getHeaders();
      logger.logInfo('GET request to $appBaseUrl$uri with headers: $headers');

      Response response = await get(uri, headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in GET request to $uri', e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  ///post Method url AND body
  Future<Response> postDataLogout(String uri) async {
    logger.logInfo('POST Logout request to $appBaseUrl$uri ');
    try {
      final headers = await _getHeaders();
      Response response = await post(uri, "", headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in POST Logout request to $uri', e);
      return Response(statusText: e.toString(), statusCode: 1);
    }
  }

  ///post Method url AND body
  Future<Response> postData(String uri, dynamic body) async {
    try {
      final headers = await _getHeaders();
      logger.logInfo(
        'POST request to $appBaseUrl$uri with body: $body and headers: $headers',
      );
      Response response = await post(uri, body, headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in POST request to $uri', e);
      return Response(statusText: e.toString(), statusCode: 1);
    }
  }

  //delete
  Future<Response> deleteData(String uri) async {
    try {
      final headers = await _getHeaders();
      logger.logInfo(
        'DELETE request to $appBaseUrl$uri with headers: $headers',
      );
      Response response = await delete(uri, headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in DELETE request to $uri', e);
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  //Send data with file and data using form
  Future<Response> postDataWithFile(String uri, FormData formData) async {
    try {
      final headers = await _getHeaders();
      logger.logInfo(
        'POST request with file to $uri with formData: $formData and headers: $headers',
      );
      Response response = await post(uri, formData, headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in POST request with file to $appBaseUrl$uri', e);
      return Response(statusText: e.toString(), statusCode: 1);
    }
  }


   Future<Response> patchData(String uri, dynamic body) async {
    try {
      final headers = await _getHeaders();
      logger.logInfo(
        'PATCH request to $appBaseUrl$uri with body: $body and headers: $headers',
      );
      Response response = await patch(uri, body, headers: headers);
      logger.logInfo('Response: ${response.bodyString}');
      return response;
    } catch (e) {
      logger.logError('Error in PATCH request to $uri', e);
      return Response(statusText: e.toString(), statusCode: 1);
    }
  }

  Future<Response> putData(String uri, dynamic body) async {
  try {
    final headers = await _getHeaders();
    logger.logInfo(
      'PUT request to $appBaseUrl$uri with body: $body and headers: $headers',
    );
    Response response = await put(uri, body, headers: headers);
    logger.logInfo('Response: ${response.bodyString}');
    return response;
  } catch (e) {
    logger.logError('Error in PUT request to $uri', e);
    return Response(statusCode: 1, statusText: e.toString());
  }
}
}

/// 🔑 Fetch token from SharedPreferences
Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("USER_TOKEN");
}
