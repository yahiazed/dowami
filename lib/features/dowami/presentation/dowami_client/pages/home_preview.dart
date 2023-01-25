import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/loading_widget.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DowamiClientHomePreview extends StatelessWidget {
   DowamiClientHomePreview({Key? key}) : super(key: key);
  final GlobalKey expansionTile =  GlobalKey();
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

    return SizedBox(
        height: .6.heightX(context),
        width: .8.widthX(context),

        child: requestsPreview(context));
  }







  Widget requestsPreview (context){
    return
   DefaultTabController(
     length: 3,
     child:Column(
       children: [


         TabBar(


           tabs:[
           Tab(text: 'مفعله',),
           Tab(text: 'ملغيه',),
           Tab(text: 'تلقى العروض',),
         ],

         ).roundWidget(height: .1.heightX(context),width: .8.widthX(context)),
         TabBarView(

             children: [
           Center(child: Text('مفعله',style:eBold20(context)),),
           Center(child: Text('ملغيه',style:eBold20(context)),),
           Center(child: Text('تلقى العروض',style:eBold20(context)),),
         ]).roundWidget(height: .4.heightX(context),width: .8.widthX(context))
       ],
     )
         //.roundWidget(height: .5.heightX(context),width: .8.widthX(context))

     , );

  }







  Widget jobTile(context){
    bool isOpen=false;
    return  ExpansionTile(
      key:expansionTile ,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isOpen? Text('الوظيفه',style: bold16(context),):Text('opened',style: bold16(context),),
          Column(
            children: [
              CircleAvatar(child: Text('3',style: reg11(context).copyWith(color: Colors.white),),backgroundColor: Colors.red,radius:.02.widthX(context) ),
              Text('تلقى العروض',style: reg11(context).copyWith(color: Colors.red),),
            ],
          ),
          Text('عرض التفاصيل',style: reg11(context).copyWith(color:Recolor.hintColor,decoration: TextDecoration.underline)),
        ],
      ),

      children: const[
        Text('child'),
        Text('child'),
        Text('child'),
        Text('child'),

      ],
      trailing: Icon(Icons.info_outline),
      onExpansionChanged: (d){
        isOpen=d;
        // expansionTile.currentState.collapse();

        //DowamiClientCubit.get(context).onChangeExpansion(d);
      },



    );
  }




}