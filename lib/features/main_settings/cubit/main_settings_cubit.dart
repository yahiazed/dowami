import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dowami/constant/strings/failuer_string.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/login/data/repositories/login_repository.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_state.dart';
import 'package:dowami/features/main_settings/data/main_settings_repository/main_settings_repository.dart';
import 'package:dowami/features/main_settings/data/models/main_settings_model.dart';
import 'package:dowami/features/register/data/models/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class MainSettingsCubit extends Cubit<MainSettingsState> {
  MainSettingsCubit({required this.repo}) : super(MainSettingsInitial());

  static MainSettingsCubit get(context) => BlocProvider.of(context);
  final MainSettingsRepo repo;




  MainSettingsModel? mainSettingsModel;







  getMainSettings( ) async {
    emit(StartGetSettingsState());

    final getSettingsResponse = await repo.getMainSettings();

    emit(_mapFailureOrGetSettingsToLoginState(getSettingsResponse));
  }
    _mapFailureOrGetSettingsToLoginState(Either<Failure, MainSettingsModel> either) {
    return either.fold(
          (failure) => ErrorGetSettingsState(errorMsg: _mapFailureToMessage(failure)),
          (mainSettingsModel) {
            this.mainSettingsModel=mainSettingsModel;
            return
            SuccessGetSettingsState(mainSettingsModel: mainSettingsModel);
          },
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
