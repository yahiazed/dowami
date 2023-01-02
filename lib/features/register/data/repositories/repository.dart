import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/helpers/dio_helper.dart';
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
     // try{}on DioError catch(e){print(e.toString());}
      print(e.response.toString());
      switch(e.response!.data['errors']!['mobile'][0]){
        case 'mobile is not valid':return Left(PhoneNumberNotValidFailure());
        case 'mobile is already registered':return Left(PhoneNumberAlreadyRegisteredFailure());
        default:
          return Left(ServerFailure());
      }
     // return Left(ServerFailure());
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
      switch(e.response!.data['errors']!['code'][0]){
        case 'code is wrong':return Left(InvalidCodeFailure());
        default:return Left(ServerFailure());
      }

     // return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> sendCompleteProfileData( {required UserModel userModel,required XFile xFile}) async{
    try {
      //print( FormData.fromMap( userModel.toMap(userModel: userModel)).files.first.value.filename );
      print(userModel);
      Response res = await dio.postDataWithFile
        (
          url: '/register/user-data',
          data:   userModel.toMap(userModel: userModel) ,
          xFile: xFile

      );
      print(res);
      return   Right(res.data['token']??'no token');
    }on DioError catch (e) {
      print(e);
      switch(e.response!.data['errors']!['national_id'][0]){
        case 'national id is already registered':return Left(NationalIdAlreadyRegisteredFailure());
        case 'national id is not valid':return Left(InvalidNationalIdFailure());
        default:return Left(ServerFailure());
      }


         return Left(ServerFailure() );
      }


    }

  }








