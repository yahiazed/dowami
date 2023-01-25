
import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';

import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';
import 'package:dowami/features/dowami/data/repositories/dowami_client_repository.dart';
import 'package:dowami/features/dowami/presentation/dowami_client/pages/home_preview.dart';
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
  List<DowamiJobModel> canceledRequests=[];
  List<DowamiJobModel> activatedRequests=[];
  List<DowamiJobModel> offeringRequests=[];

  Widget pagePreview=DowamiClientHomePreview();


  onStartPage(bool value){
    if(value){
      emit(StartingPageState());
      debugPrint('start');
      emit(EndStartingPageState());
      debugPrint('end');
    }}
  onChangePreview(Widget newPagePreview){

      emit(StartingChangePagePreviewState());
      pagePreview=newPagePreview;
      emit(EndChangePagePreviewState());


  }

  ///{1}------------------------------------------------------------------------
  makeJobDowami({required DowamiJobModel dowamiJobModel,required String token,required String lang}) async {
    emit(StartMakeJobState());
    final makeJobResponse = await repo.makeJobDowami(dowamiJobModel: dowamiJobModel,token: token,lang:lang );
    emit(_makeJobToState(makeJobResponse));
  }


  DowamiClientState _makeJobToState(Either<Failure, Unit> either) {
    return either.fold(
          (failure) => ErrorMakeJobState(errorMsg: _failureToMessage(failure),errorModel:(failure as DioResponseFailure).errorModel! ),
          (lol) =>  SuccessMakeJobState(),
    );
  }




  ///{1}------------------------------------------------------------------------
  getAllCanceledRequests({required String token,required String lang}) async {
    emit(StartGetAllCanceledRequestsState());
    final getAllCanceledRequestsResponse  = await repo.getAllCanceledRequests(token: token,lang:lang );
    emit(_getAllCanceledRequestsToState(getAllCanceledRequestsResponse));
  }


  DowamiClientState _getAllCanceledRequestsToState(Either<Failure, List<DowamiJobModel>> either) {
    return either.fold(
          (failure) => ErrorGetAllCanceledRequestsState(errorMsg: _failureToMessage(failure),  ),
          (canceledRequests) {
              this.canceledRequests=canceledRequests;
              return SuccessGetAllCanceledRequestsState();}
    );
  }


  ///{2}------------------------------------------------------------------------
  getAllActivatedRequests({required String token,required String lang}) async {
    emit(StartGetAllActivatedRequestsState());
     final getAllActivatedRequestsResponse =await repo.getAllActivatedRequests( token: token,lang:lang );
     emit(_getAllActivatedRequestsToState(getAllActivatedRequestsResponse));
  }


  DowamiClientState _getAllActivatedRequestsToState(Either<Failure, List<DowamiJobModel>> either) {
    return either.fold(
            (failure) => ErrorGetAllActivatedRequestsState(errorMsg: _failureToMessage(failure),  ),
            (activatedRequests) {
          this.activatedRequests=activatedRequests;
          return SuccessGetAllActivatedRequestsState();}
    );
  }



  ///{3}------------------------------------------------------------------------
  getAllOfferingRequests({required String token,required String lang}) async {
    emit(StartGetAllOfferingRequestsState());
     final getAllOfferingRequestsResponse= await repo.getAllOfferingRequests( token: token,lang:lang );
     emit(_getAllOfferingRequestsToState(getAllOfferingRequestsResponse));
  }


  DowamiClientState _getAllOfferingRequestsToState(Either<Failure, List<DowamiJobModel>> either) {
    return either.fold(
            (failure) => ErrorGetAllOfferingRequestsState(errorMsg: _failureToMessage(failure),  ),
            (offeringRequests) {
          this.offeringRequests=offeringRequests;
          return SuccessGetAllOfferingRequestsState();}
    );
  }






  onChangeMakeDowami(){
    emit(StartMakeJobState());
    emit( SuccessMakeJobState());
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

  bool expansionValue=false;
  onChangeExpansion(bool value){
    emit(StartChangeCarSizeState());
    expansionValue=value;
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