// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

/// [register_step_one_screen] {1}
///[1] Send OTP     [StartSendOtpState]



/// [register_step_two_screen] {2}
///[1] Verify CODE     [StartVerifyCodeState]
///[2] Timer     [StartTimeDownState]




/// {( client )} [fill_data_screen]  {3}
///[1] Pick Image     [StartPickImageState]
///[2] gender     [StartChangeGenderRadioState]
///[3] date     [StartSelectDateState]
///[4] location     [StartPermissionsLocationState]
///[5] sendProfileData     [StartSendProfileDataState]




class RegisterInitial extends RegisterState {}


/// [register_step_one_screen] {1}
///[1] Send OTP     [StartSendOtpState]


class StartSendOtpState extends RegisterState {}
class SuccessSendOtpState extends RegisterState {
  final int smsCode;
  const SuccessSendOtpState({required this.smsCode,});
}
class ErrorSendOtpState extends RegisterState {
  final String errorMsg;

  const ErrorSendOtpState({required this.errorMsg});
}
//------------------------------------------------------------------------------




/// [register_step_two_screen] {2}
///[1] Verify CODE     [StartVerifyCodeState]
///[2] Timer     [StartTimeDownState]









///[1] Verify CODE     [StartVerifyCodeState]

class StartVerifyCodeState extends RegisterState {}
class SuccessCodeState extends RegisterState {

  const SuccessCodeState();
}
class ErrorCodeState extends RegisterState {
  final String errorMsg;
  const ErrorCodeState({required this.errorMsg,});
}

//-----
///[2] Timer     [StartTimeDownState]
class TimeOutSendSmsCodeState extends RegisterState {}
class StartTimeDownState extends RegisterState {}
class EndTimeDownState extends RegisterState {}

//------------------------------------------------------------------------------



/// {( client )} [fill_data_screen]  {3}
///[1] Pick Image     [StartPickImageState]
///[2] gender     [StartChangeGenderRadioState]
///[3] date     [StartSelectDateState]
///[4] location     [StartPermissionsLocationState]
///[5] sendProfileData     [StartSendProfileDataState]



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

//-----

class StartChangeGenderRadioState extends RegisterState {}
class EndChangeGenderRadioState extends RegisterState {}

//-----

class StartPermissionsLocationState extends RegisterState {}
class SuccessPermissionsLocationState extends RegisterState {}
class ErrorPermissionsLocationState extends RegisterState {
  final String errorMsg;
  const ErrorPermissionsLocationState({required this.errorMsg});
}

//-----

class StartChangeAcceptTermsState extends RegisterState {}
class EndChangeAcceptTermsState extends RegisterState {}

//-----

class StartSelectDateState extends RegisterState {}
class EndSelectDateState extends RegisterState {}

//-----

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
//------------------------------------------------------------------------------


/// {( Captain )} [fill_data_screen]  {3}
///[2] isRent     [StartChangeRadioRentState]
///[3] get cars models     [StartChangeRadioRentState]
///[4] get cars data models     [StartChangeRadioRentState]
///[5] select car model     [StartSelectCarModelState]
///[6] select car  data model     [StartSelectCarDataModelState]
///[7] send captain vehicle      [StartSendCaptainVehicleDataState]
///[8] get Required Documents      [StartGetRequiredDocumentsState]
///[9] send Documents     [StartGetRequiredDocumentsState]

class StartChangeRadioRentState extends RegisterState {}
class EndChangeRadioRentState extends RegisterState {}

//------------------------------------------------------------------------------


///[3] get cars models
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

///[4] get cars Data models
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

//------------------------------------------------------------------------------
///[5] select car model
class StartSelectCarModelState extends RegisterState {}
class EndSelectCarModelState extends RegisterState {}

//------------------------------------------------------------------------------

///[6] select car  data model
class StartSelectCarDataModelState extends RegisterState {}
class EndSelectCarDataModelState extends RegisterState {}


///[7] send captain vehicle
class StartSendCaptainVehicleDataState extends RegisterState {}
class SuccessSendCaptainVehicleDataState extends RegisterState {

  const SuccessSendCaptainVehicleDataState();
}
class ErrorSendCaptainVehicleDataState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorSendCaptainVehicleDataState({required this.errorMsg,required this.errorModel});
}

///[8] get Required Documents

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


///[9] send Documents

class StartSendDocumentsState extends RegisterState {}
class SuccessSendRequiredDocumentsState extends RegisterState {

  const SuccessSendRequiredDocumentsState();
}
class ErrorSendRequiredDocumentsState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorSendRequiredDocumentsState({required this.errorMsg,required this.errorModel});
}


///[9] select Expired Date

class StartSelectExpiredDateState extends RegisterState {}
class EndSelectExpiredDateState extends RegisterState {

  const EndSelectExpiredDateState();
}
