
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class DowamiClientRepo{

  Future<Either<Failure, Unit>> makeJobDowami({required DowamiJobModel dowamiJobModel,required String token,required String lang});
}

class DowamiClientRepoImpel implements DowamiClientRepo {
  final DioHelper dio;

  DowamiClientRepoImpel({required this.dio});

  @override
  Future<Either<Failure, Unit>> makeJobDowami({required DowamiJobModel dowamiJobModel,required String token,required String lang})async {

    try {
     await dio.postData(url:makeJobDowamiUrl, data: dowamiJobModel.toMap(),token: token,lang:lang);
      return const Right(unit);
    }on DioError catch (e) {
       debugPrint(e.response.toString());
      // debugPrint(e.response!.statusCode.toString());

      if(e.response!.statusCode==500){
        debugPrint(e.response!.statusCode.toString());
        return Left(ServerFailure());
      }
      else{ return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));}

    }
  }






}