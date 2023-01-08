part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}





/// [] {1}
///[1] Send OTP     [StartSendOtpLoginState]
///[2] Verify CODE     [StartVerifyCodeLoginState]








///[1] Send OTP     [StartSendOtpLoginState]
class StartSendOtpLoginState extends LoginState {}
class SuccessSendOtpLoginState extends LoginState {
  final int smsCode;
  const SuccessSendOtpLoginState({required this.smsCode,});
}
class ErrorSendOtpLoginState extends LoginState {
  final String errorMsg;

  const ErrorSendOtpLoginState({required this.errorMsg});
}





///[2] Verify CODE     [StartVerifyCodeLoginState]

class StartVerifyCodeLoginState extends LoginState {}
class SuccessCodeLoginState extends LoginState {

  const SuccessCodeLoginState();
}
class ErrorCodeLoginState extends LoginState {
  final String errorMsg;
  const ErrorCodeLoginState({required this.errorMsg,});
}


//-----
///[3] Timer     [StartTimeDownState]
class TimeOutSendSmsCodeLoginState extends LoginState {}
class StartTimeDownLoginState extends LoginState {}
class EndTimeDownLoginState extends LoginState {}