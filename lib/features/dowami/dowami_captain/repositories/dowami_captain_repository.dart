
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class DowamiCaptainRepo{

  Future<Either<Failure, int>> first({required String x});
}

class DowamiCaptainRepoImpel implements DowamiCaptainRepo {
  final DioHelper dio;

  DowamiCaptainRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> first({required String x})async {

    try {
      Response res = await dio.postData(url: '', data: {'mobile': ''});
      return Right(res.data['code']);
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