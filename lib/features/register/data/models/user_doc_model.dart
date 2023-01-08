import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserDocModel extends Equatable {
  final String? docId;
  final String? userId;
  final String? expiredDate;
  final String? idNumber;


  const UserDocModel({
    this.docId,
    this.userId,
    this.expiredDate,
    this.idNumber,
  });

  factory UserDocModel.fromMap(Map<String,dynamic> map){
    return UserDocModel(
      docId: map['document_id'],
      userId: map['user_id'],
      expiredDate: map['expire_date'],
      idNumber: map['id_number'],
    );
  }

  Map<String,dynamic> toMap(UserDocModel userDocModel){
    return
      {
        'document_id':userDocModel.docId,
        'user_id':userDocModel.userId,
        'expire_date':userDocModel.expiredDate,
        'id_number':userDocModel.idNumber,
      }
    ;
  }



  String toJson(UserDocModel userDocModel) => json.encode(toMap(userDocModel));

  factory UserDocModel.fromJson(String source) => UserDocModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [docId];
}
