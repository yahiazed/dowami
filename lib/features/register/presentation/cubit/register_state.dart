// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'register_cubit.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class StartChangeRadioRentState extends RegisterState {}

class EndChangeRadioRentState extends RegisterState {}

class StartChangeAcceptTermsState extends RegisterState {}

class EndChangeAcceptTermsState extends RegisterState {}

class StartChangeGenderRadioState extends RegisterState {}

class EndChangeGenderRadioState extends RegisterState {}

class StartSelectDateState extends RegisterState {}

class EndSelectDateState extends RegisterState {}

class SuccessSendOtpState extends RegisterState {
  int smsCode;
  SuccessSendOtpState({
    required this.smsCode,
  });
}

class ErrorSendOtpState extends RegisterState {
 final String errorMsg;

  const ErrorSendOtpState({required this.errorMsg});
}

class TimeOutSendSmsCodeState extends RegisterState {}

class StartTimeDownState extends RegisterState {}


class SuccessCodeState extends RegisterState {
  int userId;
  SuccessCodeState({required this.userId});
}

class ErrorCodeState extends RegisterState {
  String errorMsg;
  ErrorCodeState({
    required this.errorMsg,
  });
}

class EndTimeDownState extends RegisterState {}

class StartPickImageState extends RegisterState {}
class SuccessPickImageState extends RegisterState {
  final File imageFile;
   const SuccessPickImageState({required this.imageFile});
}

class ErrorPickImageState extends RegisterState {
  final String errorMsg;

  const ErrorPickImageState({required this.errorMsg});
}


class SuccessProfileDataState extends RegisterState {
  final String token;
  const SuccessProfileDataState({required this.token});
}
class ErrorProfileDataState extends RegisterState {
  final String errorMsg;

  const ErrorProfileDataState({required this.errorMsg});
}