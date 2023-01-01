import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class OfflineFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class EmptyCacheFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
