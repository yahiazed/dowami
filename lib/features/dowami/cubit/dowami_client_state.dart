
import 'package:dowami/core/error_model.dart';
import 'package:equatable/equatable.dart';

abstract class DowamiClientState extends Equatable {
  const DowamiClientState();
  @override
  List<Object> get props => [];
}

class DowamiClientInitial extends DowamiClientState {}




///[1] MakeJob     [StartMakeJobState]
///
///
class StartMakeJobState extends DowamiClientState {}
class SuccessMakeJobState extends DowamiClientState {
  const SuccessMakeJobState();
}
class ErrorMakeJobState extends DowamiClientState {
  final String errorMsg;
  final ErrorModel errorModel;
  const ErrorMakeJobState({required this.errorMsg,required this.errorModel});
}
//-----------




class StartChangeState extends DowamiClientState {}
class EndChangeState extends DowamiClientState {}


class StartChangeFun1State extends DowamiClientState {}
class EndChangeFun1State extends DowamiClientState {}


class StartChangeFun2State extends DowamiClientState {}
class EndChangeFun2State extends DowamiClientState {}

class StartChangeDaysState extends DowamiClientState {}
class EndChangeDaysState extends DowamiClientState {}

class StartChangeTimeState extends DowamiClientState {}
  class EndChangeTimeState extends DowamiClientState {}

class StartChangePassengerCountState extends DowamiClientState {}
class EndChangePassengerCountState extends DowamiClientState {}

class StartChangeCarSizeState extends DowamiClientState {}
class EndChangeCarSizeState extends DowamiClientState {}


class StartChangeStopPointsState extends DowamiClientState {}
class EndChangeStopPointsState extends DowamiClientState {}

class StartAddStopPointState extends DowamiClientState {}
class EndAddStopPointState extends DowamiClientState {}


class StartChangeIsGoingAndComingState extends DowamiClientState {}
class EndChangeIsGoingAndComingState extends DowamiClientState {}
