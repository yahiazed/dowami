
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/profile/data/models/user_approval_response_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class ProfileRepo {
  Future<Either<Failure, UserApprovalResponseModel>> checkUserApproval({required String userId,required String lang});
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,required String lang});
  Future<Either<Failure, Unit>> resetPassword( {required String phoneNum,required String password,required String lang});
}

class ProfileRepoImpel implements ProfileRepo {
  final DioHelper dio;

  ProfileRepoImpel({required this.dio});

  @override
  Future<Either<Failure, UserApprovalResponseModel>> checkUserApproval({required String userId ,required String lang}) async {
    try {
      Response res = await dio.postData(url: checkUserApprovalUrl, data: {'user_id': userId},lang:lang);
      print(res.data);
      return Right(UserApprovalResponseModel.fromMap(res.data));
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







