import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit() : super(TermsInitial());
}
