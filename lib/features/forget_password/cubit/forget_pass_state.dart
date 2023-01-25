
import 'package:equatable/equatable.dart';
//part of 'forget_pass_cubit.dart';
abstract class ResetPassState extends Equatable {
  const ResetPassState();

  @override
  List<Object> get props => [];
}

class ResetPassInitial extends ResetPassState {}







///(1) [sendOtp]                 [StartSendOtpResetPassState]
///(2) [resendOtp]              [StartResendOtpState]
///(3) [verifyCode]             [StartVerifyCodeState]
///(4) [resetPassword]          [StartResetPassState]
///(5) [onChangeShowPass]       [StartChangeShowPassState]
///(6) [timerCutDown]           [TimeOutSendSmsCodeResetPassState]




///[1] Send OTP   ----------------------------------------------------------------
class StartSendOtpResetPassState extends ResetPassInitial {}
class SuccessSendOtpResetPassState extends ResetPassInitial {
  final int smsCode;
   SuccessSendOtpResetPassState({required this.smsCode,});
}
class ErrorSendOtpResetPassState extends ResetPassInitial {
  final String errorMsg;

   ErrorSendOtpResetPassState({required this.errorMsg});
}

///(2) resend  Otp    ----------------------------------------------------------------
class StartResendOtpState extends ResetPassInitial {}
class SuccessResendOtpState extends ResetPassInitial {
  final int smsCode;
  SuccessResendOtpState({required this.smsCode,});
}
class ErrorResendOtpState extends ResetPassInitial {
  final String errorMsg;

  ErrorResendOtpState({required this.errorMsg});
}

///[3] Verify CODE   ----------------------------------------------------------------
class StartVerifyCodeState extends ResetPassInitial {}
class SuccessCodeState extends ResetPassInitial {

   SuccessCodeState();
}
class ErrorCodeState extends ResetPassInitial {
  final String errorMsg;
   ErrorCodeState({required this.errorMsg,});
}

///(4) resetPassword ----------------------------------------------------------------
class StartResetPassState extends ResetPassInitial {}
class SuccessResetPassState extends ResetPassInitial {

   SuccessResetPassState();
}
class ErrorResetPassState extends ResetPassInitial {
  final String errorMsg;
   ErrorResetPassState({required this.errorMsg,});
}


///(5) onChangeShowPass----------------------------------------------------------------
class StartChangeShowPassState extends ResetPassInitial {}
class EndChangeShowPassState extends ResetPassInitial {}



///[6] Timer        ----------------------------------------------------------------
class TimeOutSendSmsCodeResetPassState extends ResetPassInitial {}
class StartTimeDownResetPassState extends ResetPassInitial {}
class EndTimeDownResetPassState extends ResetPassInitial {}


