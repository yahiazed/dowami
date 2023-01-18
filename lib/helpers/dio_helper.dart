import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../constant/strings/strings.dart';

abstract class DioHelper {
  Future<Response> postData({
    required String url,
    required dynamic data,
    String token,
    required String lang,
  });
  Future<Response> postDataWithFile({
    required String url,
    required dynamic data,
    required XFile xFile,
  required String name,
    required  String lang,
  });
  Future<Response> postDataWithFiles({
    required String url,
    required Map<String,dynamic> data,
    required List<XFile> xFiles,
  required String name,
    required  String lang,
  });


  Future<Response> putData({
    required String url,
    required dynamic data,
    String token,
    required String lang,
  });

  Future<Response> getData({
    required String url,
    dynamic query,
    String token,
    required String lang,
  });
}

class DioHelperImpl implements DioHelper {
  final Dio dio = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      baseUrl: baseUrl,
      receiveTimeout: 20 * 1000,
      connectTimeout: 20 * 1000,
      headers: {
        // 'default-lang': 'en',
       // 'Content-Type': 'application/json',
        // 'Authorization': token ?? '',
      }
    ),
  );

  String bearerString='Bearer ';


  @override
  Future<Response> getData({required String url, query, String? token,required String lang}) async {
    dio.options.headers = {
      'default-lang': lang??'en',
      'Content-Type': 'application/json',
      'Authorization': token==null ? '':bearerString+token,
    };
    return await dio.get(url, queryParameters: query);
  }

  @override
  Future<Response> postData({required String url, required data, String? token,required String lang}) async {
    dio.options.headers = {
      'default-lang': lang??'en',
      'Content-Type': 'application/json',
      'Authorization': token==null ? '':bearerString+token,
    };

   try{}on DioError catch(e){print(e.toString());}

    return await dio.post(url, data: data);
  }

  @override
  Future<Response> putData({required String url, required data, String? token,required String lang}) async {
    dio.options.headers = {
      'default-lang': lang??'en',
      'Content-Type': 'application/json',
      'Authorization': token==null ? '':bearerString+token,
    };
    return await dio.put(url, data: data);
  }







  @override
  Future<Response> postDataWithFile({required String url, required  data,required XFile xFile ,required String name,required String lang, String? token })async {
    dio.options.headers = {
      'default-lang': lang??'en',
      'Authorization': token==null ? '':bearerString+token,
    };

var formData= FormData.fromMap(data);
formData .files.add(MapEntry(name,MultipartFile .fromFileSync(xFile.path, filename: xFile.path.split('/').last)));

    return
      await dio.post (url, data: formData, options:Options(contentType: 'multipart/form-data', followRedirects: false,// validateStatus: (status) {return true;}
      ));
  }



  @override
  Future<Response> postDataWithFiles({required String url, required Map<String,dynamic> data,required List<XFile> xFiles ,required String name,required String lang, String? token })async {
    dio.options.headers = {
      'default-lang': lang??'en',
      'Authorization': token==null ? '':bearerString+token,
    };
    FormData formData= FormData.fromMap(data);

    formData.files.addAll(
        xFiles.map((e) =>MapEntry(name,
            MultipartFile.fromFileSync(e.path,filename:  e.path.split('/').last) )).toList()

      );

    return
      await dio.post (url, data: formData, options:Options(contentType: 'multipart/form-data', followRedirects: false, //validateStatus: (status) {return status! < 500;}
      ));
  }




}





/// to post data with file
/// you must add file to formData
/// the file must be in Xfile object
/// name = the name of file variable
/// formData .files.add(MapEntry(name,MultipartFile .fromFileSync(xFile.path, filename: xFile.path.split('/').last)));
///await dio.post (url, data: formData, options:Options(contentType: 'multipart/form-data', followRedirects: false, //validateStatus: (status) {return status! < 500;}));





