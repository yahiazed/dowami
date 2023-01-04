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


class StartVerifyCodeState extends RegisterState {}
class SuccessCodeState extends RegisterState {
  final int userId;
  const SuccessCodeState({required this.userId});
}
class ErrorCodeState extends RegisterState {
  final String errorMsg;
  const ErrorCodeState({required this.errorMsg,});
}

//-----

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
  const SuccessProfileDataState({required this.token});
}
class ErrorProfileDataState extends RegisterState {
  final String errorMsg;
  final ErrorModel errorModel;

  const ErrorProfileDataState({required this.errorMsg,required this.errorModel});
}
//------------------------------------------------------------------------------


/// {( Captain )} [fill_data_screen]  {3}
///[2] isRent     [StartChangeRadioRentState]

class StartChangeRadioRentState extends RegisterState {}
class EndChangeRadioRentState extends RegisterState {}






















