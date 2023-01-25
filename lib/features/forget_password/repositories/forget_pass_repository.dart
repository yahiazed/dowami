
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/features/register/data/models/address_model.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/data/models/car_model.dart';
import 'package:dowami/features/register/data/models/required_doc_model.dart';
import 'package:dowami/features/register/data/models/user_doc_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';


abstract class ForgetPassRepo {
  Future<Either<Failure, int>> sendOtp({required String phone,required String lang});
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,required String lang});
  Future<Either<Failure, Unit>> resetPassword( {required String phoneNum,required String password,required String lang});
}

class ForgetPassRepoImpel implements ForgetPassRepo {
  final DioHelper dio;

  ForgetPassRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtp({required String phone ,required String lang}) async {
    try {
      Response res = await dio.postData(url: sendOtpResetPasswordUrl, data: {'mobile': phone},lang:lang);
      return Right(res.data['code']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));

    }
  }





  @override
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,required String lang}) async {
    try {
      await dio.postData(url: verifyCodeResetPasswordUrl, data: {'mobile': phoneNum, "code": code,},lang: lang);
      return   const Right(unit);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }





  @override
  Future<Either<Failure, Unit>> resetPassword( {required String phoneNum,required String password,required String lang}) async{
    try {

      await dio.postData(url: resetPasswordUrl, data: {'mobile': phoneNum, "password": password},lang: lang);
      return   const Right(unit);
    }on DioError catch (e) {

      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }


  }



}








