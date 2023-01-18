import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/login/data/repositories/login_repository.dart';
import 'package:dowami/features/register/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? token;

    //  "11|KJGMhHH8gRn6DLbAMoR2iWF0hoSm6Aa7vypZFxEG"

 int? userId;
  UserModel? userData;




  sendOtp({required String phoneNum,required String lang}) async {
    emit(StartSendOtpLoginState());
    timerCutDown();
    second = 50;
    final failureOrSmsCode = await repo.sendOtpLogin(phone: phoneNum,lang: lang);

    emit(_mapFailureOrSmsCodeToLoginState(failureOrSmsCode));
  }
  LoginState _mapFailureOrSmsCodeToLoginState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpLoginState(errorMsg: _mapFailureToMessage(failure)),
          (code) => SuccessSendOtpLoginState(smsCode: code),
    );
  }


  verifyCode({required int code,required String lang}) async {
    emit(StartVerifyCodeLoginState());
    print(phoneCode);
    print(phoneNumber);
    final checkCode = await repo.verifyCodeLogin(
      code: code, phoneNum: //phoneCode +
        phoneNumber,lang: lang);
    emit(_mapFailureOrCodeTrueLoginState(checkCode));
  }

  LoginState _mapFailureOrCodeTrueLoginState(Either<Failure, Map<String,dynamic>> either) {
    return either.fold(
          (failure) => ErrorCodeLoginState(errorMsg: _mapFailureToMessage(failure)),
          (map) {timer.cancel();

            token=map['token'];
            userId=map['user_id'];
          userData=UserModel.fromMap(map['user']);

           // print('token =  $token');
           // print('user_id =  $userId');
           // print('user =  $userData');
          saveDataToPrefs();

            return const SuccessCodeLoginState();} ,
    );
  }





 saveDataToPrefs()async{
    emit(StartSaveDataState());
  final prefs = await SharedPreferences.getInstance();
  if(userData==null||token==null||userId==null){
    emit(ErrorSaveDataState());

  }
  else{
    await prefs.setString('user', const UserModel().toJson(userData!));
    await prefs.setString('token',token!);
    await prefs.setInt('user_id',userId!);
    emit(SuccessSaveDataState());

  }


}

Future<bool> getDataFromPrefs()async{
  final prefs = await SharedPreferences.getInstance();

  var userData1=  prefs.getString('user');
  var userId1=  prefs.getInt('user_id');
  var token1=  prefs.getString('token');
  if(userData1==null||token1==null||userId1==null){
    return false;
  }
  else{
    userData=UserModel.fromJson(userData1);
    userId=userId1;
    token=token1;

    print(userId);
    print(UserModel.fromJson(userData1).nickName!);
    print(token);
    return true;
  }

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
