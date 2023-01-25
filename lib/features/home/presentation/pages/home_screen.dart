
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/loading_widget.dart';
import 'package:dowami/constant/shared_widgets/sharedDrawer.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_state.dart';
import 'package:dowami/features/bottom_bar/presentation/dowami_bottom_bar.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/profile/cubit/profile_cubit.dart';
import 'package:dowami/features/profile/cubit/profile_state.dart';
import 'package:dowami/features/profile/presentation/pages/car_screen.dart';
import 'package:dowami/features/profile/presentation/pages/docs_screen.dart';
import 'package:dowami/features/profile/presentation/pages/wait_car_accept_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool loading=false;
  checkUserApproval()async{
    var loginCubit=LoginCubit.get(context);
    var profileCubit=ProfileCubit.get(context);
    if(loginCubit.isCaptain){
      setState(() {
        loading=true;
      });
      await profileCubit.checkApproval(userId: loginCubit.userId.toString(), lang:MainSettingsCubit.get(context).languageCode );

      if(profileCubit.state is SuccessCheckApprovalState){
        if(profileCubit.userApprovalResponseModel!.result==0){
                            if(profileCubit.userApprovalResponseModel!.carData==0){navigateRep(context,ProfileCarScreen() );}
                            if(profileCubit.userApprovalResponseModel!.carData==1&&profileCubit.userApprovalResponseModel!.docs!.isEmpty){navigateRep(context,ProfileCarWaitingAccept() );}///waiting accept
                            else{navigateRep(context,ProfileDocsScreen(docs:profileCubit.userApprovalResponseModel!.docs! ,) );}
        }

        setState(() {
          loading=false;
        });

      }
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //checkUserApproval();
    //func();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BottomBarCubit,BottomBarState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = BottomBarCubit.get(context);
        if(loading){return loadingWidget(context);}
        else{
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

                  if(LoginCubit.get(context).isCaptain)
                  { return cubit.captainScreens[cubit.currentIndex];}
                  else{ return cubit.clientScreens[cubit.currentIndex];}
                }
            ),




            bottomNavigationBar: const DowamiBottomBar(),


          );
        }

      },
    );
  }
}
