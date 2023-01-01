import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../constant/strings/failuer_string.dart';
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

//step one
  sendOtp({required String phoneNum}) async {
    timerCutDown();
    second = 60;
    final failureOrSmsCode = await repo.sendOtp(phone: phoneNum);

    emit(_mapFailureOrSmsCodeToState(failureOrSmsCode));
  }

  //step two
  verifyCode(int code) async {
    final checkCode = await repo.verifyCode(
        code: code, phoneNum: phoneCode + phoneNumber, type: userType);
    emit(_mapFailureOrCodeTrueState(checkCode));
  }

  RegisterState _mapFailureOrCodeTrueState(Either<Failure, Unit> either) {
    return either.fold(
      (failure) => ErrorCodeState(errorMsg: _mapFailureToMessage(failure)),
      (unit) => SuccessCodeState(),
    );
  }

  RegisterState _mapFailureOrSmsCodeToState(Either<Failure, int> either) {
    return either.fold(
      (failure) => ErrorSendOtpState(errorMsg: _mapFailureToMessage(failure)),
      (code) => SuccessSendOtpState(smsCode: code),
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
      emit(StartTimeDownState());
      second--;
      emit(EndTimeDownState());
      if (second == 0) {
        timer.cancel();

        emit(TimeOutSendSmsCodeState());
      }
    });
  }
}
