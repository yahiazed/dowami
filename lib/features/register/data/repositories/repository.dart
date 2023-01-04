import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';
import '../models/user_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, int>> sendOtp({required String phone});
  Future<Either<Failure, int>> verifyCode({required int code, required String phoneNum, required String type});
  Future<Either<Failure, String >> sendCompleteProfileData( {required UserModel userModel,required XFile xFile});
}

class RegisterRepoImpel implements RegisterRepo {
  final DioHelper dio;

  RegisterRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtp({required String phone}) async {
    try {
      Response _r = await dio
          .postData(url: '/register/send-otp', data: {'mobile': phone});


      return Right(_r.data['code']);
    }on DioError catch (e) {
      print(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));

    }
  }

  @override
  Future<Either<Failure, int>> verifyCode(
      {required int code,
      required String phoneNum,
      required String type}) async {
    try {
      Response _r = await dio.postData(
          url: '/register/verify-code',
          data: {'mobile': phoneNum, "code": code, 'type': type});
      return   Right(_r.data['user_id']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));
    }
  }

  @override
  Future<Either<Failure, String>> sendCompleteProfileData( {required UserModel userModel,required XFile xFile}) async{
    try {
      debugPrint(userModel.toString());
      Response res = await dio.postDataWithFile
        (url: '/register/user-data',
          data:   userModel.toMap(userModel: userModel) ,
          xFile: xFile);
debugPrint('success');
      return   Right(res.data['token']??'no token');
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));
    }


    }

  }








