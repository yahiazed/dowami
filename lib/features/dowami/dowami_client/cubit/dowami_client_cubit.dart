
import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';

import 'package:dowami/features/dowami/dowami_client/cubit/dowami_client_state.dart';
import 'package:dowami/features/dowami/dowami_client/repositories/dowami_client_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DowamiClientCubit extends Cubit<DowamiClientState> {
  DowamiClientCubit({required this.repo}) : super(DowamiClientInitial());
  static DowamiClientCubit get(context) => BlocProvider.of(context);
  final DowamiClientRepo repo;




  ///{1}------------------------------------------------------------------------
  makeJobDowami({required DowamiJobModel dowamiJobModel}) async {
    emit(StartMakeJobState());
    final makeJobResponse = await repo.makeJobDowami(dowamiJobModel: dowamiJobModel );
    emit(_makeJobToState(makeJobResponse));
  }


  DowamiClientState _makeJobToState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorMakeJobState(errorMsg: _failureToMessage(failure)),
          (lol) => const SuccessMakeJobState(),
    );
  }

  onSelectLocation(){
    emit(StartSelectLocationState());

    emit(EndSelectLocationState());
  }

  String _failureToMessage(Failure failure) {
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