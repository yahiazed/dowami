

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/main_settings/data/models/main_settings_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class MainSettingsRepo {
  Future<Either<Failure, MainSettingsModel>> getMainSettings();

}

class MainSettingsRepoImpel implements MainSettingsRepo {
  final DioHelper dio;

  MainSettingsRepoImpel({required this.dio});

  @override
  Future<Either<Failure, MainSettingsModel>> getMainSettings() async {
    try {
      Response res = await dio.getData(url: mainSettingsUrl,);
      debugPrint(res.data.toString());
      return Right(MainSettingsModel.fromMap(map: res.data['data']));
    }on DioError catch (e) {
      // debugPrint(e.response.toString());
      // debugPrint(e.response!.statusCode.toString());
      if(e.response!.statusCode==500){
        debugPrint(e.response!.statusCode.toString());
        return Left(ServerFailure());
      }
      else{ return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));}

    }
  }






}








