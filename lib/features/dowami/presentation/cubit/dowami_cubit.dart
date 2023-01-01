import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'dowami_state.dart';

class DowamiCubit extends Cubit<DowamiState> {
  DowamiCubit() : super(DowamiInitial());
}
