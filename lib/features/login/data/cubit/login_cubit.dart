import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/login/data/repositories/repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.repo}) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  final LoginRepo repo;

  bool isAcceptTerms = false;
  String phoneCode = '';
  int smsCode = 0;
  String phoneNumber = '';
  int second = 50;
  late Timer timer;

  bool isCaptain=false;





  sendOtp({required String phoneNum}) async {
    emit(StartSendOtpLoginState());
    timerCutDown();
    second = 50;
    final failureOrSmsCode = await repo.sendOtpLogin(phone: phoneNum);

    emit(_mapFailureOrSmsCodeToLoginState(failureOrSmsCode));
  }
  LoginState _mapFailureOrSmsCodeToLoginState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpLoginState(errorMsg: _mapFailureToMessage(failure)),
          (code) => SuccessSendOtpLoginState(smsCode: code),
    );
  }


  verifyCode(int code) async {
    emit(StartVerifyCodeLoginState());
    print(phoneCode);
    print(phoneNumber);
    final checkCode = await repo.verifyCodeLogin(
      code: code, phoneNum: phoneCode +
        phoneNumber,);
    emit(_mapFailureOrCodeTrueLoginState(checkCode));
  }

  LoginState _mapFailureOrCodeTrueLoginState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorCodeLoginState(errorMsg: _mapFailureToMessage(failure)),
          (x) {timer.cancel();  return const SuccessCodeLoginState();} ,
    );
  }












  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case DioResponseFailure:
        return (failure as DioResponseFailure).errorModel!.errors!.values.toString() ;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }



  void timerCutDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second <= 0) {
        timer.cancel();
        emit(TimeOutSendSmsCodeLoginState());
      }else{
        emit(StartTimeDownLoginState());
        second--;
        emit(EndTimeDownLoginState());
      }
    });

  }

}
