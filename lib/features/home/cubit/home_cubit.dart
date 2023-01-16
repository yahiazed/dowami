import 'package:bloc/bloc.dart';
import 'package:dowami/features/home/presentation/pages/hom_module_screen.dart';
import 'package:dowami/features/messages/presentation/pages/message_screen.dart';
import 'package:dowami/features/notification/presentation/pages/notifications_screen.dart';
import 'package:dowami/features/wadiny/presentation/pages/wadiny_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  List<Widget> screens = [
    const HomeModuleScreen(),
   // const DawamiScreen(),
    const WadinyScreen(),
    const MessageScreen(),
    const NotificationScreen()
  ];
  List<String> titles = [
    "Home",
    "Dawami",
    "Wadini",
    "Chats",
    "Notification",
  ];

  static HomeCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeBottomNavIndex(int index) {
    emit(StartChangeBottomNavIndexState());
    currentIndex = index;
    emit(EndChangeBottomNavIndexState());
  }
}
