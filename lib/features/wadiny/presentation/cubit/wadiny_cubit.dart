import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wadiny_state.dart';

class WadinyCubit extends Cubit<WadinyState> {
  WadinyCubit() : super(WadinyInitial());
}
