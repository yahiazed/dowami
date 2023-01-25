import 'package:dowami/features/profile/data/models/user_approval_doc_model.dart';
import 'package:equatable/equatable.dart';

class UserApprovalResponseModel extends Equatable {
  final bool? status;
  final int? result;
  final int? carData;
  final List<UserApprovalDocModel>? docs;


  const UserApprovalResponseModel({
    this.status,
    this.result,
    this.docs,
    this.carData,
  });




  factory UserApprovalResponseModel.fromMap(Map<String,dynamic> map){
    return UserApprovalResponseModel(
      status: map['status'],
        result: map['result'],
      carData: map['car_data'],
      docs: map['docs'] != null
            ? List<UserApprovalDocModel>.from(map['docs']?.map((x) => UserApprovalDocModel.fromMap(x)))
            : null


    );
  }

  Map<String,dynamic> toMap(){
    return
      {
        'status':status,
        'result':result,
        'car_data':carData,
        'docs':docs?.map((x) => x.toMap()).toList(),


      }
    ;
  }

  @override
  List<Object?> get props => [status,carData,docs];



}
