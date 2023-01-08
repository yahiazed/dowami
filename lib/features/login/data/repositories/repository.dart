import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class LoginRepo {
  Future<Either<Failure, int>> sendOtpLogin({required String phone});
  Future<Either<Failure, Unit>> verifyCodeLogin({required int code, required String phoneNum});


}

class LoginRepoImpel implements LoginRepo {
  final DioHelper dio;

  LoginRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtpLogin({required String phone}) async {
    try {
      Response res = await dio.postData(url: sendOtpLoginUrl, data: {'mobile': phone});
      return Right(res.data['code']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));

    }
  }





  @override
  Future<Either<Failure, Unit>> verifyCodeLogin({required int code, required String phoneNum,}) async {
    try {
      await dio.postData(url: verifyCodeLoginUrl, data: {'mobile': phoneNum, "code": code,});
      return   const Right(unit);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));
    }
  }





}