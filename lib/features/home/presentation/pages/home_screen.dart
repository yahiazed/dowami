
import 'package:dowami/constant/shared_widgets/sharedDrawer.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_state.dart';
import 'package:dowami/features/bottom_bar/presentation/dowami_bottom_bar.dart';
import 'package:dowami/features/home/presentation/cubit/home_cubit.dart';
import 'package:dowami/features/login/data/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomBarCubit,BottomBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BottomBarCubit.get(context);
        return Scaffold(
          drawer: sharedDrawer(context,
              url: 'https://www.w3schools.com/howto/img_avatar.png',
              userName: 'userName'),
          appBar: sharedHomeAppBar( context,
              title: cubit.titles[cubit.currentIndex],
              url: 'https://www.w3schools.com/howto/img_avatar.png'),


          body:  BlocConsumer<BottomBarCubit,BottomBarState>(
              listener: (context, state) {},
              builder: (context,state) {

                if(LoginCubit.get(context).isCaptain){ return cubit.captainScreens[cubit.currentIndex];}
                else{ return cubit.clientScreens[cubit.currentIndex];}
              }
          ),
          bottomNavigationBar: const DowamiBottomBar(),
        );
      },
    );
  }


}
