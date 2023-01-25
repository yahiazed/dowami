import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/extensions/file_extention.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/failure.dart';
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
import '../data/models/user_model.dart';
import '../data/repositories/register_repository.dart';

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
  int second = 0;
  late Timer timer;
  String expiredDate='';
  int? userId;
  String? token;
  LatLng? latLng;
  //String city='';
  //String area='';
 // String district='';
  List<CarModel>carsModels=[];
  List<CarDataModel>carsDataModels=[];
  CarModel? selectedCarModel;
  CarDataModel? selectedCarDataModel;
  String? selectedCarYear;
  List<RequiredDocModel>requiredDocuments=[];

  bool showPass=true;
  final TextEditingController passController = TextEditingController();
  final TextEditingController rePassController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  List<City>cities=[];
  List<Area>areas=[];
  List<District>districts=[];

  City? city;
  Area? area;
  District? district;




/// (1) [sendOtp]
/// (2) [verifyCode]
/// (3) [sendCompleteProfileData]
/// (4) [getCarsModels]
/// (5) [getCarsDataModels]
/// (6) [sendCaptainVehicleData]
/// (7) [getRequiredDocs]
/// (8) [sendDocuments]


  onStartPage(bool value){
    if(value){
      emit(StartingPageState());
      debugPrint('start');
      emit(EndStartingPageState());
      debugPrint('end');
    }}




  ///{1}------------------------------------------------------------------------
  sendOtp({required String phoneNum,required String lang}) async {
    emit(StartSendOtpState());


    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum,lang: lang);

    emit(_sendOtpToState(failureOrSmsCode));
  }
  RegisterState _sendOtpToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorSendOtpState(errorMsg: _failureToMessage(failure)),
          (code) {
            second = 50;
            timerCutDown();
            return SuccessSendOtpState(smsCode: code);},
    );
  }

  ///{1}------------------------------------------------------------------------
  resendOtp({required String phoneNum,required String lang}) async {
    emit(StartResendOtpState());

    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum,lang: lang);

    emit(_resendOtpToState(failureOrSmsCode));
  }
  RegisterState _resendOtpToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorResendOtpState(errorMsg: _failureToMessage(failure)),
          (code)  {
            second = 50;
            timerCutDown();
            return SuccessResendOtpState(smsCode: code);},
    );
  }


  ///{2}------------------------------------------------------------------------
  verifyCode({required int code,required String lang}) async {
    emit(StartVerifyCodeState());
    final checkCode = await repo.verifyCode(
        code: code, phoneNum: phoneCode + phoneNumber,lang: lang);
    emit(_verifyCodeToState(checkCode));
  }
  RegisterState _verifyCodeToState(Either<Failure, Unit> either) {
    return either.fold(
      (failure) => ErrorCodeState(errorMsg: _failureToMessage(failure)),
      (x) {
        //timer.cancel(); second=0;
        return const SuccessCodeState();} ,
    );
  }


  ///{3}------------------------------------------------------------------------
  sendCompleteProfileData({required UserModel userModel,required String lang})async{
    emit(StartSendProfileDataState());

   final profileDataResponse= await repo.sendCompleteProfileData(
      userModel: userModel,
       xFile: avatarPicked
       ,
     lang: lang
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
  getCarsModels({required String lang})async{
    emit(StartGetCarsModelsState());

    final carsModelsResponse= await repo.getCarModels(lang:lang );
    emit(_getCarsModelsToState(carsModelsResponse));

  }
  RegisterState _getCarsModelsToState(Either<Failure, List<CarModel>> either) {
    return either.fold(
          (failure) => ErrorGetCarsModelsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (cars) {carsModels=cars; return SuccessGetCarsModelsState(cars:cars  );},
    );
  }


  ///{5}------------------------------------------------------------------------
  getCarsDataModels({required int id,required String lang})async{
    emit(StartGetCarsDataModelsState());
    print('start');

    final carsDataModelsResponse= await repo.getCarDataModels(id: id,lang:lang);
    emit(_getCarsDataModelsToState(carsDataModelsResponse));

  }
  RegisterState _getCarsDataModelsToState(Either<Failure, List<CarDataModel>> either) {
    return either.fold(
          (failure) => ErrorGetCarsDataModelsState(errorMsg: _failureToMessage(failure),errorModel:(failure as DioResponseFailure).errorModel!
          ),
          (cars) {carsDataModels=cars; return SuccessGetCarsDataModelsState(carsData:cars  );},
    );
  }


  ///{6}------------------------------------------------------------------------
  sendCaptainVehicleData({required CaptainVehicleModel captainVehicleModel,required String lang})async{
    emit(StartSendCaptainVehicleDataState());

    Either<Failure, Unit> captainVehicleResponse= await repo.sendCaptainVehicle(
       captainVehicleModel: captainVehicleModel,
      xFiles: carImagesPicked
        ,lang:lang
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
  getRequiredDocs({required String lang})async{
    emit(StartGetRequiredDocumentsState());

    Either<Failure, List<RequiredDocModel>> requiredDocumentsResponse= await repo.getRequiredDocs(lang:lang);

    emit(_getRequiredDocsToState(requiredDocumentsResponse));

  }
  RegisterState _getRequiredDocsToState(Either<Failure,  List<RequiredDocModel>> either) {
    return either.fold(
          (failure) => ErrorGetRequiredDocumentsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (requiredDocs) {
            requiredDocuments= requiredDocs;
            createDocLists(requiredDocsLength: requiredDocs.length);
            return  SuccessGetRequiredDocumentsState(requiredDocs:requiredDocs );},
    );
  }


  ///{8}------------------------------------------------------------------------
  sendDocuments({required UserDocModel userDocModel, required XFile xFile,required String lang})async{
    emit(StartSendDocumentsState());

    Either<Failure, Unit> sendDocumentsResponse= await repo.sendDocuments(userDocModel: userDocModel, xFile: xFile,lang:lang);

    emit(_sendDocumentsToState(sendDocumentsResponse));
  }
  RegisterState _sendDocumentsToState(Either<Failure,  Unit> either) {
    return either.fold(
          (failure) => ErrorSendRequiredDocumentsState(errorMsg: _failureToMessage(failure),errorModel: (failure as DioResponseFailure).errorModel!),
          (requiredDocs) {return  const SuccessSendRequiredDocumentsState( );},
    );
  }

  successGetSendALLDocs(){
    emit(SuccessSendAllDocState());
  }





  List<Color>docsStatusColors=[];
  List<int>docsStatusIntegers=[];


  getDocStatus({ required String docId, required String lang})async{
    var res=await repo.checkApprovalDoc( lang: lang,userId:'7'// userId.toString()
        ,docId: docId);
    emit(StartGetDocStatusState());

    emit(_getCheckApprovalToState(res));
  }

  RegisterState _getCheckApprovalToState(Either<Failure,  int> either) {
    return either.fold(
          (failure) => ErrorGetDocStatusState(errorMsg: _failureToMessage(failure)),
          (status) {
        docsStatusIntegers.add(status);
        return  const SuccessGetDocStatusState( );},
    );
  }



  getStatusOfDocs({required String lang})async{
    docsStatusIntegers=[];
    docsStatusColors=[];
    List<RequiredDocModel> requiredDocsList = requiredDocuments;

    for (var doc in requiredDocsList){
      await  getDocStatus(lang:lang,docId: doc.id.toString() );

    }
    for(var i in docsStatusIntegers){

      switch(i){
        case 0:docsStatusColors.add(Recolor.amberColor);break;
        case 1:docsStatusColors.add(Recolor.onlineColor);break;
        case 2:docsStatusColors.add(Recolor.txtRefuseColor);break;
        default :docsStatusColors.add(Recolor.whiteColor);break;

      }
    }

    emit(SuccessGetAllDocStatusState());



  }


  bool finishCarPaperPage=false;
  bool loading=false;




  ///{9}------------------------------------------------------------------------
  getCities({required String lang})async{
    emit(StartGetCitiesState());
    var cityResponse=await repo.getCities(lang: lang);
    emit(_getCitiesToState(cityResponse));
  }
  RegisterState _getCitiesToState(Either<Failure,  List<City>> either) {
    return either.fold(
          (failure) => ErrorGetCitiesState(errorMsg: _failureToMessage(failure)),
          (cities) {
            this.cities=cities;
            areas=[];
            districts=[];

            print(cities);
        return  SuccessGetCitiesState(cities:cities );},
    );
  }

  ///{10}------------------------------------------------------------------------
  getAreas({required String lang,required String cityId})async{
    emit(StartGetAreasState());
    var areaResponse=await repo.getAreas(lang: lang,cityId:cityId );
    emit(_getAreasToState(areaResponse));
  }
  RegisterState _getAreasToState(Either<Failure,  List<Area>> either) {
    return either.fold(
          (failure) => ErrorGetAreasState(errorMsg: _failureToMessage(failure)),
          (areas) {
        this.areas=areas;
        districts=[];
        return  SuccessGetAreasState(areas:areas );},
    );
  }

  ///{11}------------------------------------------------------------------------
  getDistricts({required String lang,required String areaId})async{
    emit(StartGetDistrictsState());
    var districtResponse=await repo.getDistricts(lang: lang,areaId:areaId );
    emit(_getDistrictToState(districtResponse));
  }
  RegisterState _getDistrictToState(Either<Failure,  List<District>> either) {
    return either.fold(
          (failure) => ErrorGetDistrictsState(errorMsg: _failureToMessage(failure)),
          (districts) {
        this.districts=districts;
        return  SuccessGetDistrictsState(districts:districts );},
    );
  }


  onSelectCity({required City city,required String lang})async{
    emit(StartSelectCityState());
    this.city=city;
    cityController.text=city.name!;
    areaController.clear();
    districtController.clear();
    emit(EndSelectCityState());
    await getAreas(lang: lang, cityId: city.id.toString());
    print(areas);
  }
  onSelectArea({required Area area,required String lang})async{
    emit(StartSelectAreaState());
    this.area=area;
    areaController.text=area.name!;
    districtController.clear();
    emit(EndSelectAreaState());
    await getDistricts(lang: lang,areaId:area.id.toString() );
  }
  onSelectDistrict({required District district}){
    emit(StartSelectDistrictState());
    this.district=district;
    districtController.text=district.name!;
    emit(EndSelectDistrictState());
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
    carsDataModels=[];
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

  void onChangeShowPass(val) {
    emit(StartChangeShowPassState());
    showPass = val;
    emit(EndChangeShowPassState());
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
  List<TextEditingController> dateControllers =[];
  List<TextEditingController> idNumbersControllers =[];


  Future<void>pickImageFromGallery({required String photoType})async{
    emit(StartPickImageState());
    try{

      switch(photoType){

        case 'avatar':
          avatarPicked=await picker.pickImage(source: ImageSource.gallery);
          avatarImageFile=File(avatarPicked!.path);

          emit(SuccessPickImageState(imageFile: avatarImageFile!,imagesFiles: []));
          break;



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
      debugPrint(getFileSize(docImagesFiles[index]!)
          //docImagesFiles[index]!.size()
          .toString()
    );
      emit(SuccessPickImageState(imageFile: docImagesFiles[index]!,imagesFiles:const []));
      debugPrint('image got0');
    }on Exception catch(e){
      emit(const ErrorPickImageState(errorMsg: 'image not selected'));
      debugPrint(e.toString());}
  }
  createDocLists({required int requiredDocsLength}){
    docImagesFiles=List.generate(requiredDocsLength, (index) => File(''));
    docImagesPicked=List.generate(requiredDocsLength, (index) => XFile(''));
    dateControllers=List.generate(requiredDocsLength, (index) => TextEditingController());
    idNumbersControllers=List.generate(requiredDocsLength, (index) => TextEditingController());
  }




/* File? personalLicenseImageFile;
  XFile? personalLicensePicked;
  File? driveLicenseImageFile;
  XFile? driveLicensePicked;
  File? carLicenseOrDocImageFile;
  XFile? carLicenseOrDocPicked;*/














}
