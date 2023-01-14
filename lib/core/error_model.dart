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


/// error.response!.
///
/// statusCode==500 >>> [unExpected error]
/// statusCode==401 >>> [UnAuthorized    response with error]

/// statusCode==404 >>> [Not found ]
/// statusCode==405 >>> [Method Not Allowed    maybe url wrong   check[/]]
/// statusCode==200 >>> [success]