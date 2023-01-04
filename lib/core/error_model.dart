import 'package:equatable/equatable.dart';

class ErrorModel extends Equatable{


  final bool? status;
  final String? message;
  final Map<String,dynamic>? errors;
  const ErrorModel({this.status,this.message,this.errors});

  @override
  List<Object?> get props => [status,message,errors];

  factory ErrorModel.fromMap(Map<String,dynamic>map){
    return ErrorModel(
      status:map['status'],
      message:map['message'],
      errors: map['errors']

    );
  }

}