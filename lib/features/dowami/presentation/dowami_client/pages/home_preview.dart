import 'dart:math';

import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/extensions/time_extention.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/loading_widget.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';
import 'package:dowami/features/dowami/presentation/dowami_client/components/job_item_widget.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'add_job_preview.dart';

class DowamiClientHomePreview extends StatefulWidget {
   const DowamiClientHomePreview({Key? key}) : super(key: key);

  @override
  State<DowamiClientHomePreview> createState() => _DowamiClientHomePreviewState();
}

class _DowamiClientHomePreviewState extends State<DowamiClientHomePreview> {


  @override
  Widget build(BuildContext context) {
     /* return  BlocConsumer<DowamiClientCubit,DowamiClientState>(
       // listenWhen: (previous, current)=> current==const SuccessMakeJobState(),
       // buildWhen: (previous, current) =>current==const SuccessMakeJobState() ,
        listener: (context, state) {
          var cubit=DowamiClientCubit.get(context);
          var token=LoginCubit.get(context).token;
          var languageCode=MainSettingsCubit.get(context).languageCode;
          if(state is EndStartingPageState){
            cubit.getAllActivatedRequests(token: token!, lang: languageCode);
          }
          if(state is SuccessGetAllActivatedRequestsState){
            cubit.getAllOfferingRequests(token: token!, lang: languageCode);
          }

          if(state is SuccessGetAllOfferingRequestsState){
            cubit.getAllCanceledRequests(token: token!, lang: languageCode);
          }

        },
        builder: (context,state) {
        return FutureBuilder<void>(
          future: DowamiClientCubit.get(context).onStartPage(state is DowamiClientInitial),
          builder: (context, snapshot) {
            return Scaffold(
              body:

              SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        sharedElevatedButton2(
                            onPressed: (){},
                            widget: Column(
                              children: [
                                Text('وظف كابتن',style: eBold18(context).copyWith(color: Theme.of(context).primaryColor),),
                                Icon(Icons.add_circle_outline_rounded,color: Theme.of(context).primaryColor,)
                              ],
                            ),
                            context: context,
                            radius: 10,
                            verticalPadding: .03.heightX(context)

                        ).expandedWidget(flex: 1),
                      ],
                    ).paddingS(context, .04, .02),
                    state is SuccessGetAllCanceledRequestsState
                        ? requestsPreview(context)
                        :loadingWidget(context),
                    Column(
                      children:

                      List.generate(10, (index) => jobTile(context)),
                    )

                  ],

                ),
              ).paddingS(context, .04, .02)




            );
          }
        );
      }
    );*/

    return Column(
      children: [
        _buildHireCaptainButton(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('presentTrips'.tr(context),style: bold18(context),),
          ],
        ).paddingB(context, .025),
        jobs().expandedWidget(flex: 1)



      ],
    ).paddingSH(context, .04);
  }







Widget jobs(){
    return ListView.builder(
      itemBuilder: (context, index) =>ExpansionItem(jobModel: lista[index]) ,
      itemCount: lista.length,
    )
    ;
}




  Widget _noTrips(context){
    return
      Text("NOSUBSCRIPTION".tr(context), style: med16(context).copyWith(color: Recolor.hintColor)).paddingSV(context, 0.03)
    ;
  }

  Widget _buildHireCaptainButton(BuildContext context) {
    return SizedBox(
      height: 0.2.heightX(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text("DAWAMITRIPS".tr(context), style: eBold16(context)).paddingB(context, 0.01),

          sharedElevatedButton2(
              context: context,
              onPressed: () {
                navigateTo(context, AddJobClient());
              },
              radius: 9,
              //  horizontalPadding: 0.05.widthX(context),
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
              )).expandedWidget(flex: 1)
        ],
      ).paddingS(context, 0.05,.03),
    );
  }
}

