
import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/profile/cubit/profile_state.dart';
import 'package:dowami/features/profile/data/models/user_approval_response_model.dart';
import 'package:dowami/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState>{
  ProfileCubit({required this.repo}) : super(ProfileInitial());
  static ProfileCubit get(context) => BlocProvider.of(context);
  final ProfileRepo repo;



  UserApprovalResponseModel? userApprovalResponseModel;



String n='bota';





  checkApproval({required String userId,required String lang}) async {
    emit(StartCheckApprovalState());


    final failureOrCheck = await repo.checkUserApproval(userId: userId,lang: lang);

    emit(_mapFailureOrCheckState(failureOrCheck));
  }
  ProfileState _mapFailureOrCheckState(Either<Failure, UserApprovalResponseModel> either) {
    return either.fold(
          (failure) => ErrorCheckApprovalState(errorMsg: _mapFailureToMessage(failure)),
          (userApprovalResponseModel) {
            this.userApprovalResponseModel=userApprovalResponseModel;
            print(userApprovalResponseModel);
            return SuccessCheckApprovalState(userApprovalResponseModel: userApprovalResponseModel);}
    );
  }










  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      case DioResponseFailure:
        return (failure as DioResponseFailure).errorModel!.errors!.values.toString() ;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }


}