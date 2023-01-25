import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
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
import '../models/car_data_model.dart';
import '../models/user_model.dart';

abstract class RegisterRepo {
  Future<Either<Failure, int>> sendOtp({required String phone,required String lang});
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,required String lang});
  Future<Either<Failure,  Map<String,dynamic> >> sendCompleteProfileData( {required UserModel userModel,required XFile? xFile,required String lang});
  Future<Either<Failure,  List<CarModel> >> getCarModels({required String lang} );
  Future<Either<Failure,  List<CarDataModel> >> getCarDataModels({required int  id,required String lang} );
  Future<Either<Failure,Unit>> sendCaptainVehicle({required CaptainVehicleModel captainVehicleModel,required List<XFile>xFiles,required String lang });
  Future<Either<Failure,List<RequiredDocModel>>> getRequiredDocs({required String lang});
  Future<Either<Failure,Unit>> sendDocuments({required UserDocModel userDocModel,required XFile xFile,required String lang });
  Future<Either<Failure,List<City>>> getCities({required String lang });
  Future<Either<Failure,List<Area>>> getAreas({required String cityId,required String lang });
  Future<Either<Failure,List<District>>> getDistricts({required String areaId,required String lang });
  Future<Either<Failure,int>> checkApprovalDoc({required String userId,required String docId,required String lang });
}

class RegisterRepoImpel implements RegisterRepo {
  final DioHelper dio;

  RegisterRepoImpel({required this.dio});

  @override
  Future<Either<Failure, int>> sendOtp({required String phone ,required String lang}) async {
    try {
      Response res = await dio.postData(url: sendOtpRegisterUrl, data: {'mobile': phone},lang:lang);
      return Right(res.data['code']);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));

    }
  }





  @override
  Future<Either<Failure, Unit>> verifyCode({required int code, required String phoneNum,required String lang}) async {
    try {
       await dio.postData(url: verifyCodeRegisterUrl, data: {'mobile': phoneNum, "code": code,},lang: lang);
      return   const Right(unit);
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }





  @override
  Future<Either<Failure, Map<String,dynamic>>> sendCompleteProfileData( {required UserModel userModel,required XFile? xFile,required String lang}) async{
    try {
      debugPrint(userModel.toString());
      Response res = await dio.postDataWithFile(url: sendCompleteProfileDataUrl, data:   userModel.toMap(userModel: userModel) , xFile: xFile, name: 'avatar',lang: lang);
      debugPrint(res.toString());
      debugPrint('success');
      return   Right(
        {'token':res.data['token']??'no token',
         'user_id': res.data['user_id']??'no user_id'
        }



      );
    }on DioError catch (e) {

      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }


    }


  @override
  Future<Either<Failure, List<CarModel>>> getCarModels({required String lang}) async{
    try {

      Response res = await dio.getData(url: carsUrl,lang: lang  );
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
      return left(implementDioError(e));

    }

  }

  @override
  Future<Either<Failure, List<CarDataModel>>> getCarDataModels({required int id,required String lang}) async{
    try {

      Response res = await dio.getData(url: '$carsDataUrl$id' ,lang:lang );
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
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }

  @override
  Future<Either<Failure,Unit>> sendCaptainVehicle({required CaptainVehicleModel captainVehicleModel,required List<XFile>xFiles,required String lang } ) async{
    try {

      await dio.postDataWithFiles(url: sendCaptainVehicleUrl,name: 'gallery',data:captainVehicleModel.toMap() ,xFiles: xFiles,lang: lang  );
      debugPrint('\n \n ');

      debugPrint('\n \n ');
      debugPrint('success');
      return   const Right( unit );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }




  @override
  Future<Either<Failure,List<RequiredDocModel>>> getRequiredDocs( {required String lang}) async{
    try {

      Response res =  await dio.getData(url: requiredDocumentsUrl ,lang: lang);
      debugPrint('success');

      List<RequiredDocModel>requiredDocsModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){requiredDocsModels.add(RequiredDocModel.fromMap(data));}


      return    Right( requiredDocsModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }





  @override
  Future<Either<Failure, Unit>> sendDocuments({required UserDocModel userDocModel, required XFile xFile,required String lang})async {
    try {

     var res= await dio.postDataWithFile(url: uploadDocumentsUrl,name: 'document',data:userDocModel.toMap(userDocModel) ,xFile: xFile,lang:lang  );
     debugPrint(res.data.toString());
      return   const Right( unit );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));

    }
  }





  @override
  Future<Either<Failure, List<City>>> getCities({required String lang}) async{
    try {

      Response res =  await dio.getData(url: citiesUrl ,lang: lang);
      debugPrint('success');

      List<City>requiredCityModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){requiredCityModels.add(City.fromMap(map:data));}


      return    Right( requiredCityModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }

 // '$carsDataUrl$id'
  @override
  Future<Either<Failure, List<Area>>> getAreas({required String cityId, required String lang})async {
    try {

      Response res =  await dio.getData(url: '$areasUrl$cityId' ,lang: lang);
      debugPrint('success');

      List<Area>requiredAreaModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){requiredAreaModels.add(Area.fromMap(map:data));}


      return    Right( requiredAreaModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }



  @override
  Future<Either<Failure,  List<District>>> getDistricts({required String areaId, required String lang}) async{
    try {

      Response res =  await dio.getData(url: '$districtsUrl$areaId' ,lang: lang);
      debugPrint('success');

      List<District>requiredDistrictModels=[];
      var dataMap=res.data as Map<String,dynamic>   ;
      var list=dataMap['data'] as List<dynamic>   ;

      for(var data in list){requiredDistrictModels.add(District.fromMap(map:data));}


      return    Right( requiredDistrictModels );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }

  @override
  Future<Either<Failure, int>> checkApprovalDoc({required String userId, required String docId, required String lang}) async{
    try {

      Response res =  await dio.postData(url: checkDocApprovalUrl ,lang: lang,data: {'user_id': userId, "document_id": docId,});
      debugPrint('success');
      var dataMap=res.data as Map<String,dynamic>   ;
      var status=dataMap['status'] as int  ;




      return    Right( status );
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));
    }
  }




  }








