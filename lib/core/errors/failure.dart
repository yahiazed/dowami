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
class PhoneNumberAlreadyRegisteredFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
class PhoneNumberNotValidFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}

class InvalidCodeFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
class InvalidNationalIdFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
class  NationalIdAlreadyRegisteredFailure implements Failure {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => true;
}
