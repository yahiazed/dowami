
import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/cubit/dowami_captain_state.dart';
import 'package:dowami/features/dowami/data/repositories/dowami_captain_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DowamiCaptainCubit extends Cubit<DowamiCaptainState> {
  DowamiCaptainCubit({required this.repo}) : super(DowamiCaptainInitial());
  static DowamiCaptainCubit get(context) => BlocProvider.of(context);
  final DowamiCaptainRepo repo;


   int step=1;

   onChangeSteps({required int step}){

     emit(StartChangeStepsState());
     this.step=step;
     emit(const EndChangeStepsState());
   }




  ///{1}------------------------------------------------------------------------
  first({required String x}) async {
    emit(StartFirstState());


    final firstResponse = await repo.first(x: '');

    emit(_firstToState(firstResponse));
  }
  DowamiCaptainState _firstToState(Either<Failure, int> either) {
    return either.fold(
          (failure) => ErrorFirstState(errorMsg: _failureToMessage(failure)),
          (lol) => SuccessFirstState(lol:  lol),
    );
  }


/*  onSelectCarModel(value){
    emit(StartSelectCarModelState());
    selectedCarModel = value;
    selectedCarDataModel=null;
    emit(EndSelectCarModelState());
  }*/
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