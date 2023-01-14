import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/data/models/car_data_model.dart';
import 'package:dowami/features/register/data/models/car_model.dart';
import 'package:dowami/features/register/data/models/required_doc_model.dart';
import 'package:dowami/features/register/data/models/user_doc_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../constant/strings/failuer_string.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/register_repository.dart';
import '../pages/steps/get_location_dialog.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit({required this.repo}) : super(RegisterInitial());
  static RegisterCubit get(context) => BlocProvider.of(context);
  final RegisterRepo repo;
  bool isAcceptTerms = false;
  bool isMale = true;
  bool isRent = false;
  String birthDate = '';
  String phoneCode = '';
  int smsCode = 0;
  String phoneNumber = '';
  String userType = 'captain';
  String userPassword = '';
  bool isCaptain = false;
  int second = 50;
  late Timer timer;
  String expiredDate='';
  int? userId;
  String? token;
  LatLng? latLng;
  String city='';
  String area='';
  String district='';
  List<CarModel>carsModels=[];
  List<CarDataModel>carsDataModels=[];
  CarModel? selectedCarModel;
  CarDataModel? selectedCarDataModel;
  String? selectedCarYear;
  List<RequiredDocModel>requiredDocuments=[];










/// (1) [sendOtp]
/// (2) [verifyCode]
/// (3) [sendCompleteProfileData]
/// (4) [getCarsModels]
/// (5) [getCarsDataModels]
/// (6) [sendCaptainVehicleData]
/// (7) [getRequiredDocs]
/// (8) [sendDocuments]







  ///{1}------------------------------------------------------------------------
  sendOtp({required String phoneNum}) async {
    emit(StartSendOtpState());
    timerCutDown();
   second = 50;
    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum);

    emit(_sendOtpToState(failureOrSmsCode));
  }
  RegisterState _sendOtpToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpState(errorMsg: _failureToMessage(failure)),
          (code) => SuccessSendOtpState(smsCode: code),
    );
  }


  ///{2}------------------------------------------------------------------------
  verifyCode(int code) async {
    emit(StartVerifyCodeState());
    final checkCode = await repo.verifyCode(
        code: code, phoneNum: phoneCode + phoneNumber,);
    emit(_verifyCodeToState(checkCode));
  }
  RegisterState _verifyCodeToState(Either<Failure, Unit> either) {
    return either.fold(
      (failure) => ErrorCodeState(errorMsg: _failureToMessage(failure)),
      (x) {timer.cancel();  return const SuccessCodeState();} ,
    );
  }


  ///{3}------------------------------------------------------------------------
  sendCompleteProfileData({required UserModel userModel})async{
    emit(StartSendProfileDataState());

   final profileDataResponse= await repo.sendCompleteProfileData(
      userModel: userModel,
       xFile: avatarPicked!
        );
    emit(_sendCompleteProfileDataToState(profileDataResponse));

  }
  RegisterState _sendCompleteProfileDataToState(Either<Failure,  Map<String,dynamic>> either) {
    return either.fold(
          (failure) => ErrorProfileDataState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (map) {

            token=map['token']!;
            userId=map['user_id']!;

            avatarImageFile=null;avatarPicked=null;return SuccessProfileDataState(token:map['token']!,userId:map['user_id']!
            );},
    );
  }


  ///{4}------------------------------------------------------------------------
  getCarsModels()async{
    emit(StartGetCarsModelsState());

    final carsModelsResponse= await repo.getCarModels();
    emit(_getCarsModelsToState(carsModelsResponse));

  }
  RegisterState _getCarsModelsToState(Either<Failure, List<CarModel>> either) {
    return either.fold(
          (failure) => ErrorGetCarsModelsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (cars) {carsModels=cars; return SuccessGetCarsModelsState(cars:cars  );},
    );
  }


  ///{5}------------------------------------------------------------------------
  getCarsDataModels({required int id})async{
    emit(StartGetCarsDataModelsState());
    print('start');

    final carsDataModelsResponse= await repo.getCarDataModels(id: id);
    emit(_getCarsDataModelsToState(carsDataModelsResponse));

  }
  RegisterState _getCarsDataModelsToState(Either<Failure, List<CarDataModel>> either) {
    return either.fold(
          (failure) => ErrorGetCarsDataModelsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (cars) {carsDataModels=cars; return SuccessGetCarsDataModelsState(carsData:cars  );},
    );
  }


  ///{6}------------------------------------------------------------------------
  sendCaptainVehicleData({required CaptainVehicleModel captainVehicleModel})async{
    emit(StartSendCaptainVehicleDataState());

    Either<Failure, Unit> captainVehicleResponse= await repo.sendCaptainVehicle(
       captainVehicleModel: captainVehicleModel,
      xFiles: carImagesPicked
    );
    emit(_sendCaptainVehicleDataToState(captainVehicleResponse));

  }
  RegisterState _sendCaptainVehicleDataToState(Either<Failure,  Unit> either) {
    return either.fold(
          (failure) => ErrorSendCaptainVehicleDataState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (unit) {
            carImagesFiles=[];carImagesPicked=[];
            return const SuccessSendCaptainVehicleDataState();
            },
    );
  }


  ///{7}------------------------------------------------------------------------
  getRequiredDocs()async{
    emit(StartGetRequiredDocumentsState());

    Either<Failure, List<RequiredDocModel>> requiredDocumentsResponse= await repo.getRequiredDocs();

    emit(_getRequiredDocsToState(requiredDocumentsResponse));

  }
  RegisterState _getRequiredDocsToState(Either<Failure,  List<RequiredDocModel>> either) {
    return either.fold(
          (failure) => ErrorGetRequiredDocumentsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (requiredDocs) {
            requiredDocuments= requiredDocs;
            createDocImagesLists(requiredDocsLength: requiredDocs.length);
            return  SuccessGetRequiredDocumentsState(requiredDocs:requiredDocs );},
    );
  }


  ///{8}------------------------------------------------------------------------
  sendDocuments({required UserDocModel userDocModel, required XFile xFile})async{
    emit(StartSendDocumentsState());

    Either<Failure, Unit> sendDocumentsResponse= await repo.sendDocuments(userDocModel: userDocModel, xFile: xFile);

    emit(_sendDocumentsToState(sendDocumentsResponse));
  }
  RegisterState _sendDocumentsToState(Either<Failure,  Unit> either) {
    return either.fold(
          (failure) => ErrorSendRequiredDocumentsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (requiredDocs) {return  const SuccessSendRequiredDocumentsState( );},
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









  /// (1) [onSelectCarModel]
  /// (2) [onSelectDataCarModel]
  /// (3) [onChangedGenderRadio]
  /// (4) [onSelectDate]
  /// (5) [onSelectExpiredDate]
  /// (6) [onChangedAcceptTerms]
  /// (7) [onChangedRadioRent]
  /// (8) [timerCutDown]
  /// (9) [getPermissions]
  /// (10) [pickImageFromGallery]
  /// (11) [pickDocImageFromGallery]
  /// (12) [createDocImagesLists]




  onSelectCarModel(value){
    emit(StartSelectCarModelState());
    selectedCarModel = value;
    selectedCarDataModel=null;
    emit(EndSelectCarModelState());
  }

  onSelectDataCarModel(value){
    emit(StartSelectCarDataModelState());
    selectedCarDataModel = value;
    emit(EndSelectCarDataModelState());
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

  void onSelectExpiredDate(value) {
    emit(StartSelectExpiredDateState());
    expiredDate = value;
    emit(const EndSelectExpiredDateState());
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
















  ImagePicker picker=ImagePicker();
  File? avatarImageFile;
  XFile? avatarPicked;
  List<File>carImagesFiles=[];
  List<XFile>carImagesPicked=[];
  List<File?>docImagesFiles=[];
  List<XFile?>docImagesPicked=[];

  Future<void>pickImageFromGallery({required String photoType})async{
    emit(StartPickImageState());
    try{

      switch(photoType){

        case 'avatar':
          avatarPicked=await picker.pickImage(source: ImageSource.gallery);
          avatarImageFile=File(avatarPicked!.path);
          emit(SuccessPickImageState(imageFile: avatarImageFile!,imagesFiles: []));
          break;

   /*     case 'personalLicense':
          personalLicensePicked=await picker.pickImage(source: ImageSource.gallery);
          personalLicenseImageFile=File(personalLicensePicked!.path);
          emit(SuccessPickImageState(imageFile: personalLicenseImageFile!,imagesFiles: []));
          break;

        case 'driveLicense':
          driveLicensePicked=await picker.pickImage(source: ImageSource.gallery);
          driveLicenseImageFile=File(driveLicensePicked!.path);
          emit(SuccessPickImageState(imageFile: driveLicenseImageFile!,imagesFiles: []));
          break;

        case 'carLicenseOrDoc':
          carLicenseOrDocPicked=await picker.pickImage(source: ImageSource.gallery);
          carLicenseOrDocImageFile=File(carLicenseOrDocPicked!.path);
          emit(SuccessPickImageState(imageFile: carLicenseOrDocImageFile!,imagesFiles: []));
          break;*/

        default:
          carImagesPicked=await picker.pickMultiImage();
          carImagesFiles=carImagesPicked.map((e) =>File(e.path) ).toList();
          emit(SuccessPickImageState(imageFile: carImagesFiles.first,imagesFiles: carImagesFiles));


      }
       debugPrint('image got');
      //imageMultipartFile=   MultipartFile.fromFileSync(imageFile!.path, filename:imageFile!.path.split('/').last);
     // FormData formData = FormData.fromMap({"img": await MultipartFile.fromFile(imageFile!.path, filename:fileName)});
    }on Exception catch(e){
      emit(const ErrorPickImageState(errorMsg: 'image not selected'));
      debugPrint(e.toString());}


  }
  Future<void>pickDocImageFromGallery({required int index})async{


    emit(StartPickImageState());
    try{
      docImagesPicked[index]=await picker.pickImage(source: ImageSource.gallery);
      docImagesFiles[index]=File(docImagesPicked[index]!.path);
      emit(SuccessPickImageState(imageFile: docImagesFiles[index]!,imagesFiles:const []));
      debugPrint('image got');
    }on Exception catch(e){
      emit(const ErrorPickImageState(errorMsg: 'image not selected'));
      debugPrint(e.toString());}
  }
  createDocImagesLists({required int requiredDocsLength}){
    docImagesFiles=List.generate(requiredDocsLength, (index) => File(''));
    docImagesPicked=List.generate(requiredDocsLength, (index) => XFile(''));
  }



/* File? personalLicenseImageFile;
  XFile? personalLicensePicked;
  File? driveLicenseImageFile;
  XFile? driveLicensePicked;
  File? carLicenseOrDocImageFile;
  XFile? carLicenseOrDocPicked;*/

























}
