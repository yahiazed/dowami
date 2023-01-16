
import 'package:equatable/equatable.dart';

abstract class DowamiCaptainState extends Equatable {
  const DowamiCaptainState();
  @override
  List<Object> get props => [];
}

class DowamiCaptainInitial extends DowamiCaptainState {}




///[1] first
class StartFirstState extends DowamiCaptainState {}
class SuccessFirstState extends DowamiCaptainState {
  final int lol;
  const SuccessFirstState({required this.lol,});
}
class ErrorFirstState extends DowamiCaptainState {
  final String errorMsg;

  const ErrorFirstState({required this.errorMsg});
}
//-----------




class StartChangeStepsState extends DowamiCaptainState {}
class EndChangeStepsState extends DowamiCaptainState {
  const EndChangeStepsState( );
}