
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
  const ErrorMakeJobState({required this.errorMsg});
}
//-----------




class StartChangeState extends DowamiClientState {}
class EndChangeState extends DowamiClientState {}