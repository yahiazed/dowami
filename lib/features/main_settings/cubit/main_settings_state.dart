
import 'package:dowami/features/main_settings/data/models/main_settings_model.dart';
import 'package:equatable/equatable.dart';




abstract class MainSettingsState extends Equatable {
  const MainSettingsState();

  @override
  List<Object> get props => [];
}

class MainSettingsInitial extends MainSettingsState {}





class StartGetSettingsState extends MainSettingsState {}
class SuccessGetSettingsState extends MainSettingsState {
  final MainSettingsModel mainSettingsModel;
  const SuccessGetSettingsState({required this.mainSettingsModel,});
}
class ErrorGetSettingsState extends MainSettingsState {
  final String errorMsg;

  const ErrorGetSettingsState({required this.errorMsg});
}






class StartTimeDownLoginState extends MainSettingsState {}
class EndTimeDownLoginState extends MainSettingsState {}