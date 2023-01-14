import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_state.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DowamiBottomBar extends StatelessWidget {

  const DowamiBottomBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<BottomBarCubit,BottomBarState>(
      listener: (context, state) {

      } ,
      builder: (context, state) {
        var cubit=BottomBarCubit.get(context);
        return

          BottomNavigationBar(
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
      },

    );
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
