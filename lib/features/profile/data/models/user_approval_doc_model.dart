import 'dart:convert';

import 'package:equatable/equatable.dart';

class UserApprovalDocModel extends Equatable {
  final int? id;
  final String? docId;
  final String? docFile;
  final String? approveStatus;

  const UserApprovalDocModel({
    this.id,
    this.docId,
    this.docFile,
    this.approveStatus,
  });


  factory UserApprovalDocModel.fromMap(Map<String,dynamic> map){
   return UserApprovalDocModel(
    id: map['id'],
    docId: map['doc_id'],
     docFile: map['doc_file'],
     approveStatus: map['approve_status'],


   );
  }

  Map<String,dynamic> toMap(){
   return
    {
     'id':id,
     'doc_id':docId,
     'doc_file':docFile,
     'approve_status':approveStatus,

    }
   ;
  }

  String toJson(UserApprovalDocModel userApprovalDocModel) => json.encode(toMap());

  factory UserApprovalDocModel.fromJson(String source) => UserApprovalDocModel.fromMap(json.decode(source));

  @override
  List<Object?> get props => [docId,approveStatus];
}
