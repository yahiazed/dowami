import 'package:dowami/features/profile/data/models/user_approval_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState  extends Equatable{
  const ProfileState();
  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}






class StartCheckApprovalState extends ProfileState {}
class SuccessCheckApprovalState extends ProfileState {
  final UserApprovalResponseModel userApprovalResponseModel;
  const SuccessCheckApprovalState({required this.userApprovalResponseModel,});
}
class ErrorCheckApprovalState extends ProfileState {
  final String errorMsg;

  const ErrorCheckApprovalState({required this.errorMsg});
}