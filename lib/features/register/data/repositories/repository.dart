import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/data/models/car_model.dart';
import 'package:dowami/features/register/data/models/required_doc_model.dart';
import 'package:dowami/features/register/data/models/user_doc_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/failure.dart';
import '../models/car_data_model.dart';
import '../models/user_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, int>> sendOtp({required String phone});
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum});
  Future<Either<Failure,  Map<String,dynamic> >> sendCompleteProfileData( {required UserModel userModel,required XFile xFile});
  Future<Either<Failure,  List<CarModel> >> getCarModels( );
  Future<Either<Failure,  List<CarDataModel> >> getCarDataModels({required int  id} );
  Future<Either<Failure,Unit>> sendCaptainVehicle({required CaptainVehicleModel captainVehicleModel,required List<XFile>xFiles });
  Future<Either<Failure,List<RequiredDocModel>>> getRequiredDocs( );
  Future<Either<Failure,Unit>> sendDocuments({required UserDocModel userDocModel,required XFile xFile });
}

class RegisterRepoImpel implements RegisterRepo {
  final DioHelper dio;

  RegisterRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtp({required String phone}) async {
    try {
      Response res = await dio.postData(url: sendOtpRegisterUrl, data: {'mobile': phone});
      return Right(res.data['code']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));

    }
  }





  @override
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,}) async {
    try {
       await dio.postData(url: verifyCodeRegisterUrl, data: {'mobile': phoneNum, "code": code,});
      return   const Right(unit);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));
    }
  }





  @override
  Future<Either<Failure, Map<String,dynamic>>> sendCompleteProfileData( {required UserModel userModel,required XFile xFile}) async{
    try {
      debugPrint(userModel.toString());
      Response res = await dio.postDataWithFile(url: sendCompleteProfileDataUrl, data:   userModel.toMap(userModel: userModel) , xFile: xFile, name: 'avatar');
      debugPrint(res.toString());
      debugPrint('success');
      return   Right(
        {'token':res.data['token']??'no token',
         'user_id': res.data['user_id']??'no user_id'
        }



      );
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data! as Map<String,dynamic>  )));
    }


    }


  @override
  Future<Either<Failure, List<CarModel>>> getCarModels() async{
    try {

      Response res = await dio.getData(url: carsUrl  );
      debugPrint('\n \n ');
      debugPrint(res.data.toString());
      debugPrint('\n \n ');
      debugPrint('success');
      List<CarModel>carsModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){carsModels.add(CarModel.fromMap(data));}


      return   Right( carsModels );
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));
    }

  }

  @override
  Future<Either<Failure, List<CarDataModel>>> getCarDataModels({required int id}) async{
    try {

      Response res = await dio.getData(url: '$carsDataUrl$id'  );
      debugPrint('\n \n ');
      debugPrint(res.data.toString());
      debugPrint('\n \n ');
      debugPrint('success');
      List<CarDataModel>carsDataModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){carsDataModels.add(CarDataModel.fromMap(data));}


      return   Right( carsDataModels );
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));
    }
  }

  @override
  Future<Either<Failure,Unit>> sendCaptainVehicle({required CaptainVehicleModel captainVehicleModel,required List<XFile>xFiles } ) async{
    try {

      await dio.postDataWithFiles(url: sendCaptainVehicleUrl,name: 'gallery',data:captainVehicleModel.toMap(captainVehicleModel) ,xFiles: xFiles,  );
      debugPrint('\n \n ');

      debugPrint('\n \n ');
      debugPrint('success');
      return   const Right( unit );
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.toString());
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));
    }
  }




  @override
  Future<Either<Failure,List<RequiredDocModel>>> getRequiredDocs( ) async{
    try {

      Response res =  await dio.getData(url: requiredDocumentsUrl );
      debugPrint('\n \n ');

      debugPrint('\n \n ');
      debugPrint('success');

      List<RequiredDocModel>requiredDocsModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){requiredDocsModels.add(RequiredDocModel.fromMap(data));}


      return    Right( requiredDocsModels );
    }on DioError catch (e) {
      debugPrint('failure');
      debugPrint(e.toString());
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));
    }
  }





  @override
  Future<Either<Failure, Unit>> sendDocuments({required UserDocModel userDocModel, required XFile xFile})async {
    try {

     var res= await dio.postDataWithFile(url: uploadDocumentsUrl,name: 'document',data:userDocModel.toMap(userDocModel) ,xFile: xFile,  );
     debugPrint(res.data.toString());
      return   const Right( unit );
    }on DioError catch (e) {
      debugPrint('failure');
      //debugPrint(e.toString());
      debugPrint(e.response.toString());
      return Left(DioResponseFailure(errorModel: ErrorModel.fromMap(e.response!.data!  as Map<String,dynamic>  )));
    }
  }




  }








