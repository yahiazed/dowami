import 'package:dio/dio.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:flutter/material.dart';

class ServerException implements Exception {}

class OfflineException implements Exception {}

class EmptyCacheException implements Exception {}





DioResponseFailure implementDioError(DioError dioError){

  if(dioError.response!=null&&dioError.response!.statusCode==401){
    debugPrint(dioError.response!.statusCode.toString());
    return DioResponseFailure(errorModel: ErrorModel.fromMap(dioError.response!.data!  as Map<String,dynamic>  ));
  }
  else{ return const DioResponseFailure(errorModel: ErrorModel(status: false,errors: {},message: 'error'));}


}