import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/helpers/dio_helper.dart';

import '../../../../core/errors/failure.dart';

abstract class RegisterRepo {
  Future<Either<Failure, int>> sendOtp({required String phone});
  Future<Either<Failure, Unit>> verifyCode(
      {required int code, required String phoneNum, required String type});
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
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyCode(
      {required int code,
      required String phoneNum,
      required String type}) async {
    try {
      Response _r = await dio.postData(
          url: '/register/verify-code',
          data: {'mobile': phoneNum, "code": code, 'type': type});
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
