import 'package:dowami/features/bottom_bar/cubit/bottom_bar_state.dart';
import 'package:dowami/features/dowami/presentation/dowami_captain/pages/dowami_captain.dart';
import 'package:dowami/features/dowami/presentation/dowami_captain/pages/settings_captain_dowami.dart';
import 'package:dowami/features/dowami/presentation/dowami_client/pages/add_job_client_screen.dart';
import 'package:dowami/features/home/presentation/pages/hom_module_screen.dart';
 import 'package:dowami/features/messages/presentation/pages/message_screen.dart';
import 'package:dowami/features/notification/presentation/pages/notifications_screen.dart';
import 'package:dowami/features/wadiny/presentation/pages/wadiny_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class BottomBarCubit extends Cubit<BottomBarState> {
  BottomBarCubit() : super(BottomBarInitial());


  List<Widget> screens = [
    const HomeModuleScreen(),
    const DowamiCaptain(),
    const WadinyScreen(),
    const MessageScreen(),
    const NotificationScreen()
  ];

  List<Widget> captainScreens = [
    const HomeModuleScreen(),
   // const DowamiCaptain(),
    const SettingCaptainDowamiScreen(),
    const WadinyScreen(),
    const MessageScreen(),
    const NotificationScreen()
  ];

  List<Widget> clientScreens = [
    const HomeModuleScreen(),
     AddJobClient(),
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

  static BottomBarCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  void changeBottomNavIndex(int index) {
    emit(StartChangeBottomNavIndexState());
    currentIndex = index;
    emit(EndChangeBottomNavIndexState());
  }
}
