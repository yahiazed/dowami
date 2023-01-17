import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';

class HomeModuleScreen extends StatelessWidget {
  const HomeModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(onPressed: (){
            MainSettingsCubit.get(context).onChangeLanguage('en');
          }, icon: Icon(Icons.abc_outlined)),

          IconButton(onPressed: (){
            MainSettingsCubit.get(context).onChangeLanguage('ar');
          }, icon: Icon(Icons.access_time_filled_sharp)),



          _buildHeaderBanner(context),
          _buildHireCaptinButton(context),
          _buildHaveTripButton(context),
          Row(
            children: [
              _buildComingTrip(context,
                  tripName: 'الوظيفة', hour: 12, minutes: 59, second: 55)
            ],
          )
        ],
      ).paddingSH(context, .05),
    );
  }

  Widget _buildComingTrip(BuildContext context,
      {required String tripName,
      required int hour,
      required int minutes,
      required int second}) {
    return Column(
      children: [
        Text(tripName, style: med18(context).copyWith(  color: Theme.of(context).primaryColor,)).paddingT(context, 0.009),
        Text('Captain will come through'.tr(context), style: taj11MedBlue())
            .paddingSV(context, 0.01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItemTimeContainer(context, headText: 'Hour', time: '$hour'),
            _buildItemTimeContainer(context,
                headText: 'Minute', time: '$minutes'),
            _buildItemTimeContainer(context,
                headText: 'Second', time: '$second'),
          ],
        )
      ],
    ).cardAllSized(
      context,
      width: .4,
      height: 0.13,
      radius: 15,
      cardColor: Recolor.card3Color,
    );
  }

  Widget _buildItemTimeContainer(BuildContext context,
      {required String headText, required String time}) {
    return SizedBox(
      height: 0.04.heightX(context),
      width: 0.07.widthX(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            headText.tr(context),
            style: taj7MedGrey(),
          ),
          Text(time, style:  med16(context).copyWith(  color: Theme.of(context).primaryColor,)),
        ],
      ),
    )
        .paddingA(3)
        .cardAll(radius: 10, cardColor: Recolor.whiteColor, elevation: 5);
  }

  Column _buildHaveTripButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("WADINITRIPS".tr(context), style: eBold16(context))
            .paddingB(context, 0.01),
        Text("NOMESHOAR".tr(context), style: taj11MedGreeHint()),
        Center(
          child: sharedElevatedButton2(
            context: context,
              onPressed: () {},
              radius: 9,
              horizontalPadding: 0.05.widthX(context),
              verticalPadding: 0.023.heightX(context),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "I have a ride".tr(context),
                    style: eBold18(context).copyWith( color: Theme.of(context).primaryColor,),
                  ),
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: Theme.of(context).primaryColor,
                    size: .09.widthX(context),
                  )
                ],
              )),
        ).paddingSV(context, 0.02),
      ],
    );
  }

  Widget _buildHireCaptinButton(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("DAWAMITRIPS".tr(context), style: eBold16(context))
            .paddingB(context, 0.01),
        Text("NOSUBSCRIPTION".tr(context), style: taj11MedGreeHint()),
        Center(
          child: sharedElevatedButton2(
            context: context,
              onPressed: () {},
              radius: 9,
              horizontalPadding: 0.05.widthX(context),
              verticalPadding: 0.023.heightX(context),
              widget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Hire a captain".tr(context),
                    style: eBold18(context).copyWith( color: Theme.of(context).primaryColor,),
                  ),
                  Icon(
                    Icons.add_circle_outline_outlined,
                    color: Theme.of(context).primaryColor,
                    size: .09.widthX(context),
                  )
                ],
              )),
        ).paddingSV(context, 0.02),
      ],
    ).paddingSV(context, 0.03);
  }

  Widget _buildHeaderBanner(BuildContext context) {
    return Container(
      width: .9.widthX(context),
      height: 0.22.heightX(context),
      color: Recolor.whiteColor,
    ).cardAll(radius: 20, elevation: 10).paddingSV(context, 0.02);
  }
}
