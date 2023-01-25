import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class LoginRepo {
  Future<Either<Failure, int>> sendOtpLogin({required String phone,required String lang});
  Future<Either<Failure, Map<String,dynamic>>> verifyCodeLogin({required int code, required String phoneNum,required String lang});
  Future<Either<Failure, Map<String,dynamic>>> login({required String password, required String phoneNum,required String lang});


}

class LoginRepoImpel implements LoginRepo {
  final DioHelper dio;

  LoginRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtpLogin({required String phone,required String lang}) async {
    try {
      Response res = await dio.postData(url: sendOtpLoginUrl, data: {'mobile': phone},lang: lang);

      return Right(res.data['code']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      if(e.response!.statusCode==500){
        debugPrint(e.response!.statusCode.toString());
        return Left(ServerFailure());
      }
      else{ return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));}

    }
  }





  @override
  Future<Either<Failure, Map<String,dynamic>>> verifyCodeLogin({required int code, required String phoneNum,required String lang,}) async {
    try {
     var res= await dio.postData(url: verifyCodeLoginUrl, data: {'mobile': phoneNum, "code": code,},lang: lang);

      var responseMap= res.data as Map<String,dynamic>;
     debugPrint(responseMap.toString());

      return     Right(responseMap);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      if(e.response!.statusCode==500){
        debugPrint(e.response!.statusCode.toString());
        return Left(ServerFailure());
      }
      else{ return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));}
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> login({required String password, required String phoneNum, required String lang}) async{
    try {

      Response res =  await dio.postData(url: loginUrl ,lang: lang,data: {'mobile': phoneNum, "password": password,});
      var responseMap= res.data as Map<String,dynamic>;
      debugPrint(responseMap.toString());

      return     Right(responseMap);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }





}