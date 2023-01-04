import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constant/strings/failuer_string.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/repository.dart';
import '../pages/steps/get_location_dialog.dart';

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
  String token='';

  LatLng? latLng;
  String city='';
  String area='';
  String district='';

//step one
  sendOtp({required String phoneNum}) async {
    emit(StartSendOtpState());
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
    emit(StartVerifyCodeState());
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
    emit(StartSendProfileDataState());

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
      case DioResponseFailure:
        return (failure as DioResponseFailure).errorModel!.errors!.values.toString() ;
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


  getPermissions(context)async{
    emit(StartPermissionsLocationState());
    bool serviceEnabled;
    LocationPermission permission;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {return Future.error('Location services are disabled.');}

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {return Future.error('Location permissions are denied');}
    }

    if (permission == LocationPermission.deniedForever) {return Future.error('Location permissions are permanently denied, we cannot request permissions.');}





    emit(const SuccessPermissionsLocationState());

  }














  ImagePicker picker=ImagePicker();
  File? imageFile;
  XFile? picked;
  MultipartFile? imageMultipartFile;

  Future<void>pickImageFromGallery()async{
    emit(StartPickImageState());
    try{
      picked=await picker.pickImage(source: ImageSource.gallery);
      imageFile=File(picked!.path);
      debugPrint('image got');
      imageMultipartFile=   MultipartFile.fromFileSync(imageFile!.path, filename:imageFile!.path.split('/').last);
     // FormData formData = FormData.fromMap({"img": await MultipartFile.fromFile(imageFile!.path, filename:fileName)});
      emit(SuccessPickImageState(imageFile: imageFile!));
    }on Exception catch(e){
      emit(const ErrorPickImageState(errorMsg: 'image not selected'));
      debugPrint(e.toString());}


  }
























}
