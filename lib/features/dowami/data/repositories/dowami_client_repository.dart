
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';

abstract class DowamiClientRepo{

  Future<Either<Failure, Unit>> makeJobDowami({required DowamiJobModel dowamiJobModel,required String token,required String lang});
  Future<Either<Failure, List<DowamiJobModel>>> getAllCanceledRequests({required String token,required String lang});
  Future<Either<Failure, List<DowamiJobModel>>> getAllActivatedRequests({required String token,required String lang});
  Future<Either<Failure, List<DowamiJobModel>>> getAllOfferingRequests({required String token,required String lang});
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


        return left(implementDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<DowamiJobModel>>> getAllActivatedRequests({required String token, required String lang})async {
    try {
     var res= await dio.getData(url:clientActivatedRequestsUrl,  token: token,lang:lang);

     List<DowamiJobModel>dowamiJobModels=[];
     var dataMap=res.data as Map<String,dynamic>   ;
     var list=dataMap['data'] as List<dynamic>   ;

     for(var data in list){dowamiJobModels.add(DowamiJobModel.fromMap(map: data));}


     return   Right( dowamiJobModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());


      return left(implementDioError(e));
    }

  }







  @override
  Future<Either<Failure, List<DowamiJobModel>>> getAllCanceledRequests({required String token, required String lang})async {
    try {
      var res= await dio.getData(url:clientCanceledRequestsUrl,  token: token,lang:lang);

      List<DowamiJobModel>dowamiJobModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){dowamiJobModels.add(DowamiJobModel.fromMap(map: data));}


      return   Right( dowamiJobModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<DowamiJobModel>>> getAllOfferingRequests({required String token, required String lang}) async{
    try {
      var res= await dio.getData(url:clientOfferingRequestsUrl,  token: token,lang:lang);

      List<DowamiJobModel>dowamiJobModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){dowamiJobModels.add(DowamiJobModel.fromMap(map: data));}


      return   Right( dowamiJobModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());


      return left(implementDioError(e));
    }
  }






}