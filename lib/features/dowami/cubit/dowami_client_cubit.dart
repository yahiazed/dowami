
import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';

import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';
import 'package:dowami/features/dowami/data/repositories/dowami_client_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DowamiClientCubit extends Cubit<DowamiClientState> {
  DowamiClientCubit({required this.repo}) : super(DowamiClientInitial());
  static DowamiClientCubit get(context) => BlocProvider.of(context);
  final DowamiClientRepo repo;


  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<TextEditingController> stopPointsControllers = [];
  List<LatLng> stopPointsLocs = [];
  LatLng? startLoc;
  LatLng? endLoc;
  bool isGoingAndComing=false;
  TimeOfDay  goingTime=TimeOfDay.now();
  TimeOfDay  comingTime=TimeOfDay.now();
  int passengerCount=1;
  List<String>selectedDaysIds=[];

  String selectedSize='Sedan';






  ///{1}------------------------------------------------------------------------
  makeJobDowami({required DowamiJobModel dowamiJobModel,required String token}) async {
    emit(StartMakeJobState());
    final makeJobResponse = await repo.makeJobDowami(dowamiJobModel: dowamiJobModel,token: token );
    emit(_makeJobToState(makeJobResponse));
  }


  DowamiClientState _makeJobToState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorMakeJobState(errorMsg: _failureToMessage(failure),errorModel:(failure as DioResponseFailure).errorModel! ),
          (lol) => const SuccessMakeJobState(),
    );
  }


  onChangeMakeDowami(){
    emit(StartMakeJobState());
    emit(const SuccessMakeJobState());
  }


  onAddStopPoint(){
    emit(StartAddStopPointState());
    stopPointsControllers.add(TextEditingController());
    stopPointsLocs.add(const LatLng(0, 0));
    emit(EndAddStopPointState());

  }



  onChangeDays(id){
    emit(StartChangeDaysState());
    if(selectedDaysIds.contains(id)) {selectedDaysIds.remove(id);}
    else{selectedDaysIds.add(id);}
    emit(EndChangeDaysState());
  }

onChangeIsGoingAndComing(value){
  emit(StartChangeIsGoingAndComingState());
  isGoingAndComing=value;
  emit(EndChangeIsGoingAndComingState());

}

  onChangeTime({going,coming}){
    emit(StartChangeTimeState());
    goingTime=going;
    comingTime=coming;
    emit(EndChangeTimeState());
  }


  onChangePassengerCount(value){
    emit(StartChangePassengerCountState());
    passengerCount=value;
    emit(EndChangePassengerCountState());
  }
  onChangeCarSize(String value){
    emit(StartChangeCarSizeState());
    selectedSize=value;
    emit(EndChangeCarSizeState());
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