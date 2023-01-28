import 'package:dowami/constant/enums/days_enums.dart';
import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/extensions/time_extention.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/sharedDrawer.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/maps/map_widget/location_dialog.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddJobClient extends StatelessWidget {
  AddJobClient({Key? key}) : super(key: key);
  final fromLocController = TextEditingController();
  final toLocController = TextEditingController();
  final GlobalKey<FormState> dataFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: sharedAppBar(context: context, onTap: (){Navigator.pop(context);}),

      body: preview(context),

    );
  }

  Widget preview(context) {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
       listenWhen: (previous, current)=> current== SuccessMakeJobState(),
       buildWhen: (previous, current) =>current== SuccessMakeJobState() ,
        listener: (context, state) {},
        builder: (context,state){
         if(state is SuccessMakeJobState){
           return successPreview(context);
         }
         else{
           return makeJobPreview(context );
         }

      }
    );
  }

  Widget successPreview(context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${'trip'.tr(context)} ( ${DowamiClientCubit.get(context).nameController.text} )',style: med24(context),),

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('orderAdded'.tr(context),style: eBold28(context),).paddingB(context, .02),
              Text('offersWillBeDisplay'.tr(context),style: reg18(context),textAlign: TextAlign.center,).roundWidget(width: .6.widthX(context)).paddingB(context, .05),
              Text('youCanFollow'.tr(context),style: med18(context),).paddingB(context, .005),
              Text('Dawami'.tr(context),style: eBold18(context).copyWith(color: Theme.of(context).primaryColor),),
            ],
          ),

          Text(' ' ,style: eBold30(context),),
        ],
      ),
    );

  }





 Widget makeJobPreview(context, ) {

    return SingleChildScrollView(
      child: Form(
        key: dataFormKey,
        child: Column(
          children: [

            _tripName(context),
            _startPoint(context),
            _endPoint(context),
            _stopPoints(context),
            _days(),
            _timeAndComingAndGoing(),
            _passengersCount(),
            _carSize(),
            _offerPrice(context),
            _buildErrorsMessages(context)
                .cardAll(elevation: 1, radius: 0)
                .paddingSV(context,0.01),
            _saveButton()
          ],
        ),
      ),
    ).paddingS(context, .05, .02);
  }





   List<dynamic> errors=[];
  Widget _buildErrorsMessages(context){
    return Column(


      crossAxisAlignment: CrossAxisAlignment.end,
      children:errors.map((e) =>
          Text('$e  * ',style: med11(context).copyWith(color: Colors.red) ,)
      ).toList() ,
    );
  }






  Widget getLocButton({required BuildContext context, required TextEditingController controller, required String hint, required Function(LatLng l) func}) {
    return SizedBox(
      height: .05.heightX(context),
      child: sharedBorderedInput(context,
          controller: controller,
          hintText: hint,
          borderWidth: 2,
          fillColor: Recolor.whiteColor,
          isPassword: false,
          radius: 5,
          suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
          keyboardType: TextInputType.none,
          hintStyle: bold12(context).copyWith(color: Recolor.txtGreyColor),
          textStyle: bold14(context).copyWith(color: Recolor.txtGreyColor),
          readOnly: true, onTap: () async {
        LatLng? selectedLatLng = await openLocationDialog(context);
        if (selectedLatLng == null) {
          return;
        }

        Placemark myAddress = await selectedLatLng.getPlaceMark();

        var city = myAddress.administrativeArea!;
        var area = myAddress.subAdministrativeArea!;
        var district = myAddress.locality!;
        controller.text = '$city,$area,$district';
        func(selectedLatLng);
       // print(startLoc);
       // print(endLoc);
      }).cardAllSized(context,
          width: 1, height: .04, cardColor: Colors.transparent, elevation: 0),
    );
  }

  Widget _tripName(context) {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
       // listenWhen: (previous, current) {return current==EndChangeStopPointsState();},
       // buildWhen: (previous, current) =>current==EndChangeStopPointsState() ,
        listener: (context, state) {},
        builder: (context,state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'tripName'.tr(context),
              style: eBold16(context),
            ).paddingB(context, .01),
            SizedBox(
              height: .05.heightX(context),
              child: sharedBorderedInput(
                context,
                controller:DowamiClientCubit.get(context) .nameController,
                hintText: '',
                borderWidth: 2,
                fillColor: Recolor.whiteColor,
                isPassword: false,
                radius: 5,
                suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
                // keyboardType: TextInputType.none,
                hintStyle: bold12(context).copyWith(color: Recolor.txtGreyColor),
                textStyle: bold14(context).copyWith(color: Recolor.txtGreyColor),
                readOnly: false,

              ).cardAllSized(context,
                  width: 1, height: .04, cardColor: Colors.transparent, elevation: 0),
            )
          ],
        ).paddingSV(context, .01);
      }
    );
  }

  Widget _startPoint(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
            name: 'startPoint'.tr(context),
            icon: Icons.location_on_outlined,
            context: context),
        getLocButton(
            context: context,
            controller: fromLocController,
            hint: '',
            func: (l) {
              DowamiClientCubit.get(context). startLoc = l;
            }),
      ],
    ).paddingSV(context, .01);
  }

  Widget _endPoint(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
            name: 'endPoint'.tr(context),
            icon: Icons.location_on_outlined,
            context: context),
        getLocButton(
            context: context,
            controller: toLocController,
            hint: '',
            func: (l) {
              DowamiClientCubit.get(context). endLoc = l;
            }),
      ],
    ).paddingSV(context, .01);
  }

  Widget _stopPoints(context,) {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current) {return current==EndAddStopPointState();},
        buildWhen: (previous, current) =>current==EndAddStopPointState() ,
        listener: (context, state) {},
        builder: (context,state) {
          var cubit=DowamiClientCubit.get(context);
        return Column(
          children: [
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _title(
                      name: 'stopPoint'.tr(context),
                      icon: Icons.location_on_outlined,
                      context: context),
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color:Theme.of(context).canvasColor,
                  ).paddingB(context, .01)
                ],
              ),
              onTap: () {cubit.onAddStopPoint();},
            ),
            Column(
              children:cubit. stopPointsControllers
                  .map((controller) =>
                  _stopPointWidget(
                          index:cubit. stopPointsControllers.indexOf(controller),
                          controller: controller,
                          context: context))
                  .toList(),
            )
          ],
        ).paddingSV(context, .01);
      }
    );
  }

  Widget _stopPointWidget({context, required int index, required TextEditingController controller}) {
    return Column(
      children: [
        _title(
            name: '${'stop'.tr(context)} ${index + 1}',
            icon: Icons.warning_amber,
            context: context),
        getLocButton(
            context: context,
            controller: controller,
            hint: '',
            func: (l) {
              DowamiClientCubit.get(context). stopPointsLocs[index] = l;
            })
      ],
    ).paddingS(context, .04, .005);
  }


  Widget _days() {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current) {return current==EndChangeDaysState();},
        buildWhen: (previous, current) =>current==EndChangeDaysState() ,
        listener: (context, state) {},
        builder: (context,state) {
          var cubit=DowamiClientCubit.get(context);
        return Column(
          children: [
            _title(name: 'days'.tr(context), icon: Icons.calendar_month, context: context),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: daysMap
                  .map((e) => InkWell(
                onTap: (){
                  cubit.onChangeDays(e['id']);
                  },
                borderRadius: BorderRadius.circular(5),
                    child: Text(
                        e['name']!.tr(context),
                        style: bold14(context).copyWith(color: Recolor.whiteColor),
                    ).roundWidget(
                      color: !cubit.selectedDaysIds.contains(e['id'])
                          ? Recolor.redColor.withOpacity(.5)
                          : Recolor.oGreenColor,
                      height: .04.heightX(context),
                      width: .07.widthX(context),
                      radius: 5,
                    ).paddingA(.005.widthX(context))
                  )
              )
                  .toList(),
            ),
          ],
        ).paddingSV(context, .005);
      }
    );
  }


  Widget _timeAndComingAndGoing() {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current) => current==EndChangeTimeState()||current==EndChangeIsGoingAndComingState(),
        buildWhen: (previous, current) =>current==EndChangeTimeState()||current==EndChangeIsGoingAndComingState() ,
        listener: (context, state) {},
        builder: (context,state) {
          var cubit=DowamiClientCubit.get(context);
        return Column(

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                _title(name: 'time'.tr(context), icon: Icons.access_time_outlined , context: context),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'goingAndComing'.tr(context),
                      style: bold16(context),
                    ).paddingB(context, .01),
                    Text(
                      ':',
                      style: bold16(context),
                    ).paddingB(context, .01),
                    Switch(
                      inactiveTrackColor: Recolor.txtGreyColor,

                        value: cubit.isGoingAndComing,
                        onChanged: (value){
                          cubit.onChangeIsGoingAndComing(value);
                    }).paddingB(context, .01),
                  ],
                )

              ],
            ),
         Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: ()async{
                    await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),


                    ).then((goingTime1) {
                      if(goingTime1!=null){

                        cubit.onChangeTime(coming: cubit.comingTime,going:goingTime1);




                      }
                    });


                  },
                  child: _timeWidget(name: 'going'.tr(context),hour: cubit.goingTime.hour.toString(),min: cubit.goingTime.minute.toString(),context: context),
                ),
                if(cubit.isGoingAndComing)  InkWell(
                    onTap: ()async{
                      await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),

                      ).then((comingTime1) {
                        if(comingTime1!=null){
                          cubit.onChangeTime(coming:comingTime1,going:cubit.goingTime  );}
                      });
                    },
                    child: _timeWidget(name: 'coming'.tr(context),hour: cubit.comingTime.hour.toString(),min:cubit. comingTime.minute.toString(),context: context),
                ),
              ],


            )
          ],
        ).paddingSV(context, .01);
      }
    );
  }
  Widget _timeWidget({required String name,required context,required String hour,required String min}){
    return
      Row(
        children: [
          Icon(Icons.access_time_rounded, color: Theme.of(context).primaryColor, size: .04.widthX(context)),
          Text(name,style: bold14(context),).paddingSH(context, .02),
          Text(min).roundWidget(borderWidth: 1,radius: 5,color: Recolor.whiteColor,borderColor: Recolor.txtGreyColor,height: .03.heightX(context),width: .07.widthX(context)),
         const Text(':').paddingSH(context, .01),
          Text(hour).roundWidget(borderWidth: 1, radius: 5, color: Recolor.whiteColor, borderColor: Recolor.txtGreyColor, height: .03.heightX(context),width: .07.widthX(context)),
        ],
      )
      ;
  }


  Widget _passengersCount() {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current) {return current==EndChangePassengerCountState();},
        buildWhen: (previous, current) =>current==EndChangePassengerCountState() ,
        listener: (context, state) {},
        builder: (context,state) {
          var cubit=DowamiClientCubit.get(context);
        return Column(
          children: [
            _title(name: 'passengerCount'.tr(context), icon: Icons.people, context: context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(onPressed: (){
                 if(cubit.passengerCount<4){
                   cubit.onChangePassengerCount(cubit.passengerCount+1);
                 }
                  }, icon: Icon(Icons.add,color:Theme.of(context).canvasColor)),
                Text(cubit.passengerCount.toString(),style: eBold16(context),),

                IconButton(onPressed: (){
                  if(cubit.passengerCount<=1){return;}
                  else{   cubit.onChangePassengerCount(cubit.passengerCount-1);}

                  }, icon: Icon(Icons.remove,color: Theme.of(context).canvasColor,)),


              ],
            ).roundWidget(
                width: .5.widthX(context),
                height: .04.heightX(context),
                borderColor: Recolor.txtGreyColor.withOpacity(.5),
                radius: 10,borderWidth: 1,
                color:Colors.transparent)
          ],
        ).paddingSV(context, .01);
      }
    );
  }


  Widget _carSize() {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
      listenWhen: (previous, current) {return current==EndChangeCarSizeState();},
      buildWhen: (previous, current) =>current==EndChangeCarSizeState() ,
      listener: (context, state) {},
      builder: (context,state) {
        var cubit=DowamiClientCubit.get(context);
        return Column(
          children: [
            _title(context:context,name: 'carType'.tr(context),icon: Icons.car_crash_outlined),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [


                carSizeItem(carSize: 'Sedan',imageUrl: sedanCarUrl,context: context,cubit:cubit ),
                carSizeItem(carSize: 'SUV',imageUrl: suvCarUrl,context: context,cubit:cubit),

              ],
            )


          ],
        ).paddingSV(context, .01);
      },

    );
  }

  Widget carSizeItem({context,required String carSize,required String imageUrl,required DowamiClientCubit cubit}){

   return InkWell(
        onTap: (){ DowamiClientCubit.get(context). onChangeCarSize(carSize);},
        child: SizedBox(

          child: Stack(
            children: [
              Image.asset(
                imageUrl,
                alignment: Alignment.bottomCenter,
                width: 0.2.widthX(context),
                height: 00.1.heightX(context),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(carSize,style: eBold16(context),),
                ],
              ).paddingT(context, .01),
            ],
          ),
        ).roundWidget(color: Recolor.whiteColor,
            borderWidth:cubit.selectedSize==carSize? 2:0,
            radius: 10
            ,
            borderColor: Theme.of(context).canvasColor.withOpacity(cubit.selectedSize==carSize? 1:0),
            width: .2.widthX(context), height: .1.heightX(context))
    );

  }

  Widget _offerPrice(context) {
    return BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current) {return current==EndChangeStopPointsState();},
        buildWhen: (previous, current) =>current==EndChangeStopPointsState() ,
        listener: (context, state) {},
        builder: (context,state) {
          var cubit=DowamiClientCubit.get(context);
        return Column(
          children: [
            _title(context:context,name: 'priceOffer'.tr(context),icon: Icons.monetization_on_outlined),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                 
                  height: .05.heightX(context),
                  child: sharedBorderedInput(
                    context,
                    controller:cubit. priceController,

                    borderWidth: 2,
                    fillColor: Recolor.whiteColor,
                    isPassword: false,
                    radius: 5,
                   // suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
                     keyboardType: TextInputType.number,

                    hintStyle: bold12(context).copyWith(color: Recolor.txtGreyColor),
                    textStyle: bold14(context).copyWith(color: Recolor.txtGreyColor),
                    readOnly: false,
                    hintText: '',
                  ).cardAllSized(context,
                      width: .8, height: .04, cardColor: Colors.transparent, elevation: 0),
                ),
                Text('R.S'.tr(context),style: eBold16(context),).paddingSH(context, .01)
              ],
            )

          ],
        ).paddingSV(context, .01);
      }
    );
  }

  Widget _title({required String name, required IconData icon, required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: .04.widthX(context)),
        Text(
          name,
          style: eBold16(context),
        ).paddingSH(context, .02),
      ],
    ).paddingB(context, .01);
  }

  Widget _saveButton(){

    return
      BlocConsumer<DowamiClientCubit,DowamiClientState>(
          listenWhen: (previous, current) {return current== SuccessMakeJobState();},
          buildWhen: (previous, current) =>current== SuccessMakeJobState() ,
          listener: (context, state) {
            if(state is ErrorMakeJobState){
              showErrorToast(message: state.errorMsg);
              // errors=(state.errorModel.errors!.values).toList() ;
              errors=List<String> .from(state.errorModel.errors!.values.map((e) => e[0])).toList();



            }
          },
          builder: (context,state)  {
           var cubit=DowamiClientCubit.get(context);
          return sharedElevatedButton(
            context: context,
              onPressed: () async{
                if(cubit.startLoc==null||cubit.endLoc==null){
                  showErrorToast(message: 'enter Location');
                }

                if (!dataFormKey.currentState!.validate()){return;}
                DowamiJobModel dowamiJobModel=DowamiJobModel(
                  name:cubit. nameController.text,
                  days: cubit.selectedDaysIds,
                  carType: cubit.selectedSize,
                  requestType: cubit.isGoingAndComing?'1':'0',
                  comingTime: cubit.isGoingAndComing?getStringFormat(context: context,time: cubit.comingTime) :null,
                  goingTime:getStringFormat(context: context,time: cubit.goingTime) ,
                  fromLoc: LatLng(cubit.startLoc!.latitude,cubit.startLoc!.longitude).toStringPoint(),
                  toLoc: LatLng(cubit.endLoc!.latitude,cubit.endLoc!.longitude).toStringPoint(),
                  passengersCount:cubit. passengerCount.toString(),
                  priceOffer:cubit. priceController.text,
                  stopPoints:cubit. stopPointsLocs.map((e) =>LatLng(e.latitude,e.longitude).toStringPoint() ).toList()

                );
            //  await  cubit. makeJobDowami(dowamiJobModel: dowamiJobModel, token: LoginCubit.get(context).token!, lang: MainSettingsCubit.get(context).languageCode);

                cubit.emit(SuccessMakeJobState());

              },
              txt: "Search".tr(context),
              color: Theme.of(context).canvasColor,
              radius: 10,
              textStyle: bold18(context).copyWith(color: Theme.of(context).primaryColor),
              horizontalPadding: .18.widthX(context),
              verticalPadding: .016.heightX(context))
              .paddingSV(context, .03);
        }
      )
      ;
  }

}


