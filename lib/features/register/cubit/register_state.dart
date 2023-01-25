// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}




///[1] Send OTP                  [StartSendOtpState]
///[2] Verify CODE            [StartVerifyCodeState]
///[3] Timer                 [StartTimeDownState]
///[4] Pick Image            [StartPickImageState]
///[5] gender              [StartChangeGenderRadioState]
///[6] date                  [StartSelectDateState]
///[7] location              [StartPermissionsLocationState]
///[8] terms       [StartChangeAcceptTermsState]
///[9] sendProfileData       [StartSendProfileDataState]


/// {( Captain )}
///[1] isRent                         [StartChangeRadioRentState]
///[2] get cars models                [StartChangeRadioRentState]
///[3] get cars data models            [StartChangeRadioRentState]
///[4] select car model              [StartSelectCarModelState]
///[5] select car  data model         [StartSelectCarDataModelState]
///[6] send captain vehicle         [StartSendCaptainVehicleDataState]
///[7] get Required Documents         [StartGetRequiredDocumentsState]
///[8] send Documents                 [StartGetRequiredDocumentsState]
///[9] select Expired Date         [StartSelectExpiredDateState]

























class RegisterInitial extends RegisterState {}
class StartingPageState extends RegisterState {}
class EndStartingPageState extends RegisterState {}



///[1] Send OTP                                                     [StartSendOtpState]
///[2] Verify CODE                                               [StartVerifyCodeState]
///[3] Timer                                                    [StartTimeDownState]
///[4] Pick Image                                               [StartPickImageState]
///[5] gender                                                 [StartChangeGenderRadioState]
///[6] date                                                     [StartSelectDateState]
///[7] Address(city,area,district) and location              [StartPermissionsLocationState]
///[8] terms                                                  [StartChangeAcceptTermsState]
///[9] sendProfileData                                        [StartSendProfileDataState]







///[1] Send OTP
class StartSendOtpState extends RegisterState {}
class SuccessSendOtpState extends RegisterState {
  final int smsCode;
  const SuccessSendOtpState({required this.smsCode,});
}
class ErrorSendOtpState extends RegisterState {
  final String errorMsg;

  const ErrorSendOtpState({required this.errorMsg});
}
//-----------

///[1] Send OTP
class StartResendOtpState extends RegisterState {}
class SuccessResendOtpState extends RegisterState {
  final int smsCode;
  const SuccessResendOtpState({required this.smsCode,});
}
class ErrorResendOtpState extends RegisterState {
  final String errorMsg;

  const ErrorResendOtpState({required this.errorMsg});
}
//-----------


///[2] Verify CODE
class StartVerifyCodeState extends RegisterState {}
class SuccessCodeState extends RegisterState {

  const SuccessCodeState();
}
class ErrorCodeState extends RegisterState {
  final String errorMsg;
  const ErrorCodeState({required this.errorMsg,});
}
//-----


///[3] Timer
class TimeOutSendSmsCodeState extends RegisterState {}
class StartTimeDownState extends RegisterState {}
class EndTimeDownState extends RegisterState {}
//---------


///[4] Pick Image
class StartPickImageState extends RegisterState {}
class SuccessPickImageState extends RegisterState {
  final File imageFile;
  final List <File> imagesFiles;
  const SuccessPickImageState({required this.imageFile,required this.imagesFiles});
}
class ErrorPickImageState extends RegisterState {
  final String errorMsg;

  const ErrorPickImageState({required this.errorMsg});
}
//----


///[5] gender
class StartChangeGenderRadioState extends RegisterState {}
class EndChangeGenderRadioState extends RegisterState {}
//-----


///[7] Address and location


class StartGetCitiesState extends RegisterState {}
class SuccessGetCitiesState extends RegisterState {
  final List<City>cities;
  const SuccessGetCitiesState({required this.cities});
}
class ErrorGetCitiesState extends RegisterState {
  final String errorMsg;


  const ErrorGetCitiesState({required this.errorMsg });
}

class StartGetAreasState extends RegisterState {}
class SuccessGetAreasState extends RegisterState {
  final List<Area>areas;
  const SuccessGetAreasState({required this.areas});
}
class ErrorGetAreasState extends RegisterState {
  final String errorMsg;


  const ErrorGetAreasState({required this.errorMsg });
}

class StartGetDistrictsState extends RegisterState {}
class SuccessGetDistrictsState extends RegisterState {
  final List<District>districts;
  const SuccessGetDistrictsState({required this.districts});
}
class ErrorGetDistrictsState extends RegisterState {
  final String errorMsg;


  const ErrorGetDistrictsState({required this.errorMsg });
}
//-----


///[8] terms
class StartChangeAcceptTermsState extends RegisterState {}
class EndChangeAcceptTermsState extends RegisterState {}
//----


///[6] date
class StartSelectDateState extends RegisterState {}
class EndSelectDateState extends RegisterState {}
//-----


///[9] sendProfileData
class StartSendProfileDataState extends RegisterState {}
class SuccessProfileDataState extends RegisterState {
  final String token;
  final int userId;
  const SuccessProfileDataState({required this.token,required this.userId});
}
class ErrorProfileDataState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorProfileDataState({required this.errorMsg,required this.errorModel});
}
//--------------------------------------------------------------------------------------------------------------------------------------------

///select Address<City,Area,District>

class StartSelectCityState extends RegisterState {}
class EndSelectCityState extends RegisterState {}

class StartSelectAreaState extends RegisterState {}
class EndSelectAreaState extends RegisterState {}

class StartSelectDistrictState extends RegisterState {}
class EndSelectDistrictState extends RegisterState {}












/// {( Captain )}
///[1] isRent                         [StartChangeRadioRentState]
///[2] get cars models                [StartChangeRadioRentState]
///[3] get cars data models            [StartChangeRadioRentState]
///[4] select car model              [StartSelectCarModelState]
///[5] select car  data model         [StartSelectCarDataModelState]
///[6] send captain vehicle         [StartSendCaptainVehicleDataState]
///[7] get Required Documents         [StartGetRequiredDocumentsState]
///[8] send Documents                 [StartGetRequiredDocumentsState]
///[9] select Expired Date         [StartSelectExpiredDateState]






///[1] isRent
class StartChangeRadioRentState extends RegisterState {}
class EndChangeRadioRentState extends RegisterState {}
//-------------


///[2] get cars models
class StartGetCarsModelsState extends RegisterState {}
class SuccessGetCarsModelsState extends RegisterState {
  final List<CarModel>cars;
 const SuccessGetCarsModelsState({required this.cars});
}
class ErrorGetCarsModelsState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorGetCarsModelsState({required this.errorMsg,required this.errorModel});
}
//----------


///[3] get cars Data models
class StartGetCarsDataModelsState extends RegisterState {}
class SuccessGetCarsDataModelsState extends RegisterState {
  final List<CarDataModel>carsData;
  const SuccessGetCarsDataModelsState({required this.carsData});
}
class ErrorGetCarsDataModelsState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorGetCarsDataModelsState({required this.errorMsg,required this.errorModel});
}
//----------


///[4] select car model
class StartSelectCarModelState extends RegisterState {}
class EndSelectCarModelState extends RegisterState {}
//----------


///[5] select car  data model
class StartSelectCarDataModelState extends RegisterState {}
class EndSelectCarDataModelState extends RegisterState {}
//----------


///[6] send captain vehicle
class StartSendCaptainVehicleDataState extends RegisterState {}
class SuccessSendCaptainVehicleDataState extends RegisterState {

  const SuccessSendCaptainVehicleDataState();
}
class ErrorSendCaptainVehicleDataState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorSendCaptainVehicleDataState({required this.errorMsg,required this.errorModel});
}
//----------


///[7] get Required Documents
class StartGetRequiredDocumentsState extends RegisterState {}
class SuccessGetRequiredDocumentsState extends RegisterState {
final List<RequiredDocModel> requiredDocs;
  const SuccessGetRequiredDocumentsState({required this.requiredDocs});
}
class ErrorGetRequiredDocumentsState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorGetRequiredDocumentsState({required this.errorMsg,required this.errorModel});
}
//----------


///[8] send Documents
class StartSendDocumentsState extends RegisterState {}
class SuccessSendRequiredDocumentsState extends RegisterState {

  const SuccessSendRequiredDocumentsState();
}
class ErrorSendRequiredDocumentsState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorSendRequiredDocumentsState({required this.errorMsg,required this.errorModel});
}
//----------


///[9] select Expired Date
class StartSelectExpiredDateState extends RegisterState {}
class EndSelectExpiredDateState extends RegisterState {

  const EndSelectExpiredDateState();
}


///[10] get  Doc status
class StartGetDocStatusState extends RegisterState {}
class SuccessGetDocStatusState extends RegisterState {

  const SuccessGetDocStatusState();
}
class ErrorGetDocStatusState extends RegisterState {
  final String errorMsg;


  const ErrorGetDocStatusState({required this.errorMsg});
}
//----------

class SuccessSendAllDocState extends RegisterState {}

class SuccessGetAllDocStatusState extends RegisterState {}


class StartChangeShowPassState extends RegisterState {}
class EndChangeShowPassState extends RegisterState {}