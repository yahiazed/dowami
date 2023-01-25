import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/login/data/repositories/login_repository.dart';
import 'package:dowami/features/register/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.repo}) : super(LoginInitial());

  static LoginCubit get(context) => BlocProvider.of(context);
  final LoginRepo repo;


  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isAcceptTerms = false;
  String phoneCode = '';
  int smsCode = 0;
  String phoneNumber = '';
  String password = '';


  bool isCaptain=false;
  String? token;
 int? userId;
  UserModel? userData;
bool showPass=true;


onShowPass(){
  emit(StartShowPassState());
  showPass=!showPass;
  emit(EndShowPassState());
}


  sendOtp({required String phoneNum,required String lang}) async {
    emit(StartSendOtpLoginState());


    final failureOrSmsCode = await repo.sendOtpLogin(phone: phoneNum,lang: lang);

    emit(_mapFailureOrSmsCodeToLoginState(failureOrSmsCode));
  }
  LoginState _mapFailureOrSmsCodeToLoginState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpLoginState(errorMsg: _mapFailureToMessage(failure)),
          (code) => SuccessSendOtpLoginState(smsCode: code),
    );
  }


  login({required String lang}) async {
    emit(StartLoginState());
    print(phoneCode);
    print(phoneNumber);
    final loginRes = await repo.login(
       phoneNum:
       phoneNumber.contains('+')?phoneNumber: phoneCode + phoneNumber,
      lang: lang,
      password: password

    );
    emit(_mapFailureLoginState(loginRes));
  }

  LoginState _mapFailureLoginState(Either<Failure, Map<String,dynamic>> either) {
    return either.fold(
          (failure) => ErrorLoginState(errorMsg: _mapFailureToMessage(failure)),
          (map) {

            token=map['token'];
            userId=map['user_id'];
          userData=UserModel.fromMap(map['user']);

            print('token =  $token');
            print('user_id =  $userId');
            print('user =  $userData');
         // saveDataToPrefs();
            phoneController.clear();
            passController.clear();
            return const SuccessLoginState();} ,
    );
  }





 saveDataToPrefs()async{
    emit(StartSaveDataState());
  final prefs = await SharedPreferences.getInstance();
  if(userData==null||token==null||userId==null){
    print('save error');
    emit(ErrorSaveDataState());

  }
  else{
    await prefs.setString('user', const UserModel().toJson(userData!));
    await prefs.setString('token',token!);
    await prefs.setString('phoneNumber',phoneCode+phoneNumber);
    await prefs.setString('password',password);
    await prefs.setString('phoneCode',phoneCode);
    await prefs.setInt('user_id',userId!);
    print('save success');
    emit(SuccessSaveDataState());


  }


}

Future<bool> getDataFromPrefs()async{
  final prefs = await SharedPreferences.getInstance();

  var userData1=  prefs.getString('user');
  var userId1=  prefs.getInt('user_id');
  var token1=  prefs.getString('token');
  var phoneNumber1=  prefs.getString('phoneNumber');
  var password1=  prefs.getString('password');
  var phoneCode1=  prefs.getString('phoneCode');
  if(userData1==null||token1==null||userId1==null||phoneNumber1==null||password1==null||phoneCode1==null){
    return false;
  }
  else{
    userData=UserModel.fromJson(userData1);
    userId=userId1;
    token=token1;
    phoneNumber=phoneNumber1;
    password=password1;
    phoneCode=phoneCode1;
    isCaptain=userData!.userType=='captain'?true:false;

    print(userId);
    print(UserModel.fromJson(userData1).nickName!);
    print(token);
    print(phoneNumber);
    print(password);
    return true;
  }

}
 clearCache()async{
  final prefs = await SharedPreferences.getInstance();
prefs.remove('token');
prefs.remove('user_id');
prefs.remove('phoneNumber');
prefs.remove('password');
prefs.remove('phoneCode');

token=null;
userId=null;


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





}
