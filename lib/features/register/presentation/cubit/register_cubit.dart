import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constant/strings/failuer_string.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/repository.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.repo}) : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  final RegisterRepo repo;
  bool isAcceptTerms = true;
  bool isMale = true;
  bool isRent = false;
  String birthDate = '';
  String phoneCode = '';
  int smsCode = 0;
  String phoneNumber = '';
  String userType = '';
  String userPassword = '';
  bool isCaptain = false;
  int second = 50;
  late Timer timer;
  int userId=0;

//step one
  sendOtp({required String phoneNum}) async {
    timerCutDown();
    second = 6;
    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum);

    emit(_mapFailureOrSmsCodeToState(failureOrSmsCode));
  }
  RegisterState _mapFailureOrSmsCodeToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpState(errorMsg: _mapFailureToMessage(failure)),
          (code) => SuccessSendOtpState(smsCode: code),
    );
  }

  //step two
  verifyCode(int code) async {
    final checkCode = await repo.verifyCode(
        code: code, phoneNum: phoneCode + phoneNumber, type: userType);
    emit(_mapFailureOrCodeTrueState(checkCode));
  }

  RegisterState _mapFailureOrCodeTrueState(Either<Failure, int> either) {
    return either.fold(
      (failure) => ErrorCodeState(errorMsg: _mapFailureToMessage(failure)),
      (userId) => SuccessCodeState(userId: userId),
    );
  }

  sendCompleteProfileData({required UserModel userModel})async{
   final profileDataResponse= await repo.sendCompleteProfileData(
      userModel: userModel,
       xFile: picked!
        );
    emit(_mapFailureOrProfileDataState(profileDataResponse));

  }
  RegisterState _mapFailureOrProfileDataState(Either<Failure, String> either) {
    return either.fold(
          (failure) => ErrorProfileDataState(errorMsg: _mapFailureToMessage(failure)),
          (token) => SuccessProfileDataState(token:token  ),
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
      case PhoneNumberAlreadyRegisteredFailure:
        return ALREADY_REGISTERED_FAILURE_MESSAGE;
      case PhoneNumberNotValidFailure:
        return VALID_PHONE_NUMBER_FAILURE_MESSAGE;
        case InvalidCodeFailure:
        return INVALID_CODE_FAILURE_MESSAGE;
      case InvalidNationalIdFailure:
        return INVALID_National_Id_MESSAGE;
      case NationalIdAlreadyRegisteredFailure:
        return National_Id_Already_Registered_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }

  void onChangedGenderRadio(value) {
    emit(StartChangeGenderRadioState());
    isMale = value;
    emit(EndChangeGenderRadioState());
  }

  void onSelectDate(value) {
    emit(StartSelectDateState());
    birthDate = value;
    emit(EndSelectDateState());
  }

  void onChangedAcceptTerms(val) {
    emit(StartChangeAcceptTermsState());
    isAcceptTerms = val;
    emit(EndChangeAcceptTermsState());
  }

  void onChangedRadioRent(val) {
    emit(StartChangeRadioRentState());
    isRent = val;
    emit(EndChangeRadioRentState());
  }

  void timerCutDown() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
    //  emit(StartTimeDownState());
    //  second--;
     // emit(EndTimeDownState());
      if (second <= 0) {
        timer.cancel();

        emit(TimeOutSendSmsCodeState());
      }else{
        emit(StartTimeDownState());
        second--;
        emit(EndTimeDownState());
      }
    });
  }













  List? images;

  ImagePicker picker=ImagePicker();
 // String? _imageUrl;
  //String? get imageUrl=> _imageUrl;
  File? imageFile;
  XFile? picked;

  bool uploading=false;

  MultipartFile? imageMultipartFile;


  Future<void>pickImageFromGallery()async{
    emit(StartPickImageState());
    try{
      picked=await picker.pickImage(source: ImageSource.gallery);
      imageFile=File(picked!.path);

      debugPrint('image got');


      imageMultipartFile=   MultipartFile.fromFileSync(imageFile!.path, filename:imageFile!.path.split('/').last);
     // FormData formData = FormData.fromMap({"img": await MultipartFile.fromFile(imageFile!.path, filename:fileName)});
      print(imageFile);
      print(imageMultipartFile);
      emit(SuccessPickImageState(imageFile: imageFile!));
    }on Exception catch(e){
      emit(const ErrorPickImageState(errorMsg: 'image not selected'));
      debugPrint(e.toString());}


  }


  final _dio = Dio();


/*  Future<bool>uploadImage({required String token, })async{

    // photoLoc=Uri.file(picked!.path).pathSegments.last;

     await pickImageFromGallery();

    uploading=true;
    if(imageFile==null){ uploading=false; return false;}

    String fileName = imageFile!.path.split('/').last;
    _dio.options.headers["Authorization"] = "Bearer $token";
    MultipartFile i= await MultipartFile.fromFile(imageFile!.path, filename:fileName);
    FormData formData = FormData.fromMap({"img": await MultipartFile.fromFile(imageFile!.path, filename:fileName)});


    try{
      Response response = await _dio.post(ApiData.uploadImage, data: formData);
      debugPrint('image has been uploaded');
      imageFile=null;
      uploading=false;
      await getImages(token: token);

      return true;
    }on Exception catch(e){
      debugPrint('image upload error ');
      debugPrint(e.toString());


      imageFile=null;
      uploading=false;
      return false;
    }


  }*/

  getImages({required String token})async{




  }
















}
