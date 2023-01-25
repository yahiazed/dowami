import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/extensions/file_extention.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/forget_password/cubit/forget_pass_state.dart';
import 'package:dowami/features/forget_password/repositories/forget_pass_repository.dart';
import 'package:dowami/features/register/data/models/address_model.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/data/models/car_data_model.dart';
import 'package:dowami/features/register/data/models/car_model.dart';
import 'package:dowami/features/register/data/models/required_doc_model.dart';
import 'package:dowami/features/register/data/models/user_doc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constant/strings/failuer_string.dart';


class ResetPassCubit extends Cubit<ResetPassState> {
  ResetPassCubit({required this.repo}) : super(ResetPassInitial());
  static ResetPassCubit get(context) => BlocProvider.of(context);
  final ForgetPassRepo repo;

  String phoneCode = '+966';
  int smsCode = 0;
  String phoneNumber = '';
  String password = '';
  int second = 0;
  late Timer timer;
  bool showPass=true;
  bool loading=false;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController pass2Controller = TextEditingController();



  ///(1) [sendOtp]
  ///(2) [resendOtp]
  ///(3) [verifyCode]
  ///(4) [resetPassword]
  ///(5) [onChangeShowPass]
  ///(6) [timerCutDown]



///(1) [sendOtp]

  ///{1}------------------------------------------------------------------------
  sendOtp({required String lang}) async {
    emit(StartSendOtpResetPassState());


    final failureOrSmsCode = await repo.sendOtp(phone:  phoneCode + phoneController.text,lang: lang);

    emit(_sendOtpToState(failureOrSmsCode));
  }
  ResetPassState _sendOtpToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpResetPassState(errorMsg: _failureToMessage(failure)),
          (code) {
        second = 50;
        timerCutDown();
        return SuccessSendOtpResetPassState(smsCode: code);},
    );
  }







  ///(2) [resendOtp]---------------------------------------------------------------------
  resendOtp({required String phoneNum,required String lang}) async {
    emit(StartResendOtpState());

    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum,lang: lang);

    emit(_resendOtpToState(failureOrSmsCode));
  }
  ResetPassState _resendOtpToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorResendOtpState(errorMsg: _failureToMessage(failure)),
          (code)  {
        second = 50;
        timerCutDown();
        return SuccessResendOtpState(smsCode: code);},
    );
  }




  ///(3) [verifyCode]---------------------------------------------------------------------
  verifyCode({required int code,required String lang}) async {
    emit(StartVerifyCodeState());
    final checkCode = await repo.verifyCode(
        code: code, phoneNum: phoneCode + phoneNumber,lang: lang);
    emit(_verifyCodeToState(checkCode));
  }
  ResetPassState _verifyCodeToState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorCodeState(errorMsg: _failureToMessage(failure)),
          (x) {
        //timer.cancel(); second=0;
        return  SuccessCodeState();} ,
    );
  }




  ///(4) [resetPassword]---------------------------------------------------------------------
  resetPassword({required String lang})async{
    emit(StartResetPassState());

    final resetPasswordResponse= await repo.resetPassword(
      password: password,
        phoneNum: phoneCode+phoneNumber,

        lang: lang
    );
    emit(_resetPasswordToState(resetPasswordResponse));

  }
  ResetPassState _resetPasswordToState(Either<Failure,  Unit> either) {
    return either.fold(
          (failure) => ErrorResetPassState(errorMsg: _failureToMessage(failure),),
          (map) {

       return SuccessResetPassState();},
    );
  }








  String _failureToMessage(Failure failure) {
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








  ///(5) [onChangeShowPass]---------------------------------------------------------------------
  void onChangeShowPass(val) {
    emit(StartChangeShowPassState());
    showPass = val;
    emit(EndChangeShowPassState());
  }





  ///(6) [timerCutDown]---------------------------------------------------------------------

  void timerCutDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (second <= 0) {
        timer.cancel();
        emit(TimeOutSendSmsCodeResetPassState());
      }else{
        emit(StartTimeDownResetPassState());
        second--;
        emit(EndTimeDownResetPassState());
      }
    });

  }





























}
