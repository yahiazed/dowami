import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/sharedDrawer.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/home/presentation/cubit/home_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../constant/strings/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          drawer: sharedDrawer(context,
              url: 'https://www.w3schools.com/howto/img_avatar.png',
              userName: 'userName'),
          appBar: sharedHomeAppBar(context,
              title: cubit.titles[cubit.currentIndex],
              url: 'https://www.w3schools.com/howto/img_avatar.png'),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: _buildBottomNavigationBar(cubit, context),
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(HomeCubit cubit, BuildContext context) {
    return BottomNavigationBar(
        currentIndex: cubit.currentIndex,
        onTap: (value) => cubit.changeBottomNavIndex(value),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        unselectedLabelStyle: taj12RegBlue(),
        showSelectedLabels: true,
        unselectedFontSize: 14,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(homeSvg),
              activeIcon: SvgPicture.asset(activeHomeSvg),
              label: 'Home'.tr(context)),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(dawamiSvg),
              activeIcon: SvgPicture.asset(activeDowamSvg),
              label: 'Dawami'.tr(context)),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(wadeny2Svg),
              activeIcon: SvgPicture.asset(wadenySvg),
              label: 'Wadini'.tr(context)),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(messageNoneSvg),
              activeIcon: SvgPicture.asset(activeMessageSvg),
              label: 'Chats'.tr(context)),
          _buildBottomNavigationItem(context,
              activeIcon: activeNotifySvg,
              icon: notifySvg,
              label: 'Notification'),
        ]).cardUP(radius: 25, cardColor: Recolor.whiteColor, elevation: 7);
  }

  BottomNavigationBarItem _buildBottomNavigationItem(BuildContext context,
      {required String activeIcon,
      required String icon,
      required String label}) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(icon),
        activeIcon: SvgPicture.asset(activeIcon),
        label: label.tr(context));
  }
}
