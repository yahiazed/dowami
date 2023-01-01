import 'package:dio/dio.dart';

import '../constant/strings/strings.dart';

abstract class DioHelper {
  Future<Response> postData({
    required String url,
    required dynamic data,
    String token,
  });

  Future<Response> putData({
    required String url,
    required dynamic data,
    String token,
  });

  Future<Response> getData({
    required String url,
    dynamic query,
    String token,
  });
}

class DioHelperImpl implements DioHelper {
  final Dio dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      baseUrl: baseUrl,
      receiveTimeout: 20 * 1000,
      connectTimeout: 20 * 1000,
    ),
  );

  @override
  Future<Response> getData({required String url, query, String? token}) async {
    dio.options.headers = {
      // 'lang': deviceLocale.languageCode,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };
    return await dio.get(url, queryParameters: query);
  }

  @override
  Future<Response> postData(
      {required String url, required data, String? token}) async {
    dio.options.headers = {
      //'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };
    return await dio.post(url, data: data);
  }

  @override
  Future<Response> putData(
      {required String url, required data, String? token}) async {
    dio.options.headers = {
      // 'lang': appLanguage,
      'Content-Type': 'application/json',
      'Authorization': token ?? '',
    };
    return await dio.put(url, data: data);
  }
}
