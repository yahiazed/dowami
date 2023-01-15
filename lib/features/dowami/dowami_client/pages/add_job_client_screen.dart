import 'package:dowami/constant/enums/days_enums.dart';
import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/dowami_client/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/dowami_client/cubit/dowami_client_state.dart';
import 'package:dowami/features/maps/map_widget/location_dialog.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddJobClient extends StatelessWidget {
  AddJobClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DowamiClientCubit, DowamiClientState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = DowamiClientCubit.get(context);

          return Scaffold(
            body: preview(context, cubit),

          );
        });
  }

  Widget preview(context, DowamiClientCubit cubit) {
    return makeJobPreview(context, cubit);
  }

  successPreview() {}

  makeJobPreview(context, cubit) {
    print('lol');
    return SingleChildScrollView(
      child: Column(
        children: [
          _tripName(context),
          _startPoint(context),
          _endPoint(context),
          _stopPoints(context),
          _days(context),
          _timeAndComingAndGoing(context),
          _passengersCount(context),
          _carType(context),
          _offerPrice(context)
        ],
      ),
    ).paddingS(context, .05, .02);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController fromLocController = TextEditingController();
  TextEditingController toLocController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  List<TextEditingController> stopPointsControllers = [];
  List<LatLng> stopPointsLocs = [];

  LatLng? startLoc;
  LatLng? endLoc;

  Widget getLocButton({required BuildContext context, required TextEditingController controller, required String hint, required Function(LatLng l) func}) {
    return sharedBorderedInput(context,
        controller: controller,
        hintText: hint,
        borderWidth: 2,
        fillColor: Recolor.whiteColor,
        isPassword: false,
        radius: 5,
        suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
        keyboardType: TextInputType.none,
        hintStyle: bold12Blue().copyWith(color: Recolor.txtGreyColor),
        textStyle: bold14Blue().copyWith(color: Recolor.txtGreyColor),
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
        width: 1, height: .04, cardColor: Colors.transparent, elevation: 0);
  }

  Widget _tripName(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اسم الرحله',
          style: eBold16Blue(),
        ).paddingB(context, .01),
        sharedBorderedInput(
          context,
          controller: nameController,
          hintText: nameController.text,
          borderWidth: 2,
          fillColor: Recolor.whiteColor,
          isPassword: false,
          radius: 5,
          suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
          // keyboardType: TextInputType.none,
          hintStyle: bold12Blue().copyWith(color: Recolor.txtGreyColor),
          textStyle: bold14Blue().copyWith(color: Recolor.txtGreyColor),
          readOnly: false,
        ).cardAllSized(context,
            width: 1, height: .04, cardColor: Colors.transparent, elevation: 0)
      ],
    ).paddingSV(context, .01);
  }

  Widget _startPoint(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(
            name: 'نقطه الإنطلاق',
            icon: Icons.location_on_outlined,
            context: context),
        getLocButton(
            context: context,
            controller: fromLocController,
            hint: '',
            func: (l) {
              endLoc = l;
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
            name: 'نقطه الوصول',
            icon: Icons.location_on_outlined,
            context: context),
        getLocButton(
            context: context,
            controller: toLocController,
            hint: '',
            func: (l) {
              endLoc = l;
            }),
      ],
    ).paddingSV(context, .01);
  }

  Widget _stopPoints(context,) {
    return Column(
      children: [
        InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _title(
                  name: 'نقطه توقف',
                  icon: Icons.location_on_outlined,
                  context: context),
              Icon(
                Icons.add_circle_outline_rounded,
                color: Recolor.mainColor,
              ).paddingB(context, .01)
            ],
          ),
          onTap: () {
            stopPointsControllers.add(TextEditingController());
            stopPointsLocs.add(const LatLng(0, 0));
            DowamiClientCubit.get(context).onChangeThing();
          },
        ),
        Column(
          children: stopPointsControllers
              .map((controller) =>
                  /*getLocButton(context: context, controller:controller ,
         hint: 'نقطه توقف ${(stopPointsControllers.indexOf(controller)+1)}',
         func: (l){stopPointsLocs[stopPointsControllers.indexOf(controller)]=l;})*/
                  _stopPointWidget(
                      index: stopPointsControllers.indexOf(controller),
                      controller: controller,
                      context: context))
              .toList(),
        )
      ],
    ).paddingSV(context, .01);
  }

  Widget _stopPointWidget({context, required int index, required TextEditingController controller}) {
    return Column(
      children: [
        _title(
            name: ' توقف ${index + 1}',
            icon: Icons.warning_amber,
            context: context),
        getLocButton(
            context: context,
            controller: controller,
            hint: '',
            func: (l) {
              stopPointsLocs[index] = l;
            })
      ],
    ).paddingS(context, .04, .005);
  }

  List<String>selectedDaysIds=[];
  Widget _days(context) {
    return Column(
      children: [
        _title(name: 'الأيام', icon: Icons.calendar_month, context: context),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: daysMap
              .map((e) => InkWell(
            onTap: (){
              if(selectedDaysIds.contains(e['id'])) {selectedDaysIds.remove(e['id']);}
              else{selectedDaysIds.add(e['id']!);}
              DowamiClientCubit.get(context).onChangeThing();

            },
            borderRadius: BorderRadius.circular(5),
                child: Material(
                  borderRadius: BorderRadius.circular(5),


            color: !selectedDaysIds.contains(e['id'])
                  ? Recolor.redColor.withOpacity(.5)
                  : Recolor.oGreenColor,
            child: Text(
                e['name']!.tr(context),
                style: bold14Blue().copyWith(color: Recolor.whiteColor),
            ).paddingA(8),
          ).paddingA(4),
              ))
              .toList(),
        ),
      ],
    ).paddingSV(context, .005);
  }

  bool isGoingAndComing=false;
  TimeOfDay  goingTime=TimeOfDay.now();
  TimeOfDay  comingTime=TimeOfDay.now();
  int passengerCount=0;
  Widget _timeAndComingAndGoing(context) {
    return Column(

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            _title(name: 'التوقيت', icon: Icons.access_time_outlined , context: context),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'ذهاب وعوده',
                  style: bold16Blue(),
                ).paddingB(context, .01),
                Text(
                  ':',
                  style: bold16Blue(),
                ).paddingB(context, .01),
                Switch(
                  inactiveTrackColor: Recolor.txtGreyColor,

                    value: isGoingAndComing,
                    onChanged: (v){
                  isGoingAndComing=v;
                  DowamiClientCubit.get(context).onChangeThing();
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

                ).then((time1) {
                  if(time1!=null){
                    goingTime=time1;
                    DowamiClientCubit.get(context).onChangeThing();}
                });


              },
              child: _timeWidget(name: 'الذهاب',hour: goingTime.hour.toString(),min: goingTime.minute.toString(),context: context),
            ),
            if(isGoingAndComing)  InkWell(
                onTap: ()async{
                  await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),

                  ).then((time1) {
                    if(time1!=null){
                      comingTime=time1;
                      DowamiClientCubit.get(context).onChangeThing();}
                  });
                },
                child: _timeWidget(name: 'العوده',hour: comingTime.hour.toString(),min: comingTime.minute.toString(),context: context),
            ),
          ],


        )
      ],
    ).paddingSV(context, .01);
  }
  Widget _timeWidget({required String name,required context,required String hour,required String min}){
    return
      Row(
        children: [
          Icon(Icons.access_time_rounded, color: Recolor.amberColor, size: .04.widthX(context)),
          Text(name,style: bold14Blue(),).paddingSH(context, .02),
          Text(min).roundWidget(borderWidth: 1,radius: 5,color: Recolor.whiteColor,borderColor: Recolor.txtGreyColor,height: .03.heightX(context),width: .07.widthX(context)),
         const Text(':').paddingSH(context, .01),
          Text(hour).roundWidget(borderWidth: 1, radius: 5, color: Recolor.whiteColor, borderColor: Recolor.txtGreyColor, height: .03.heightX(context),width: .07.widthX(context)),
        ],
      )
      ;
  }

  Widget _passengersCount(context) {
    return Column(
      children: [
        _title(name: 'عدد الركاب', icon: Icons.people, context: context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(onPressed: (){passengerCount++;DowamiClientCubit.get(context).onChangeThing();}, icon: Icon(Icons.add,color: Recolor.mainColor)),
            Text(passengerCount.toString(),style: eBold16Blue(),),
            IconButton(onPressed: (){
              if(passengerCount<=0){return;}
              else{  passengerCount--;DowamiClientCubit.get(context).onChangeThing();}

              }, icon: Icon(Icons.remove,color: Recolor.mainColor,)),


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

  List<String>carSizes=['small','medium','large'];
  String selectedSize='small';
  Widget _carType(context) {
    return Column(
      children: [
        _title(context:context,name: 'نوع السياره',icon: Icons.car_crash_outlined),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                selectedSize='small';
                DowamiClientCubit.get(context).onChangeThing();
              },
                child: Text('صغيره').roundWidget(color: Recolor.whiteColor,
                    borderWidth: selectedSize=='small'? 2:0,
                    radius: 10,
                    borderColor: Recolor.mainColor.withOpacity(selectedSize=='small'? 1:0),
                    width: .2.widthX(context), height: .1.heightX(context))
            ),
            InkWell(
                onTap: (){selectedSize='medium'; DowamiClientCubit.get(context).onChangeThing();},
                child: Text('متوسطه').roundWidget(color: Recolor.whiteColor,
                    borderWidth: selectedSize=='medium'? 2:0,
                    radius: 10,
                    borderColor: Recolor.mainColor.withOpacity(selectedSize=='medium'? 1:0),
                    width: .2.widthX(context), height: .1.heightX(context))
            ),
            InkWell(
                onTap: (){selectedSize='large'; DowamiClientCubit.get(context).onChangeThing();},
                child: Text('كبيره').roundWidget(color: Recolor.whiteColor,
                    borderWidth:selectedSize=='large'? 2:0,
                    radius: 10
                    ,
                    borderColor: Recolor.mainColor.withOpacity(selectedSize=='large'? 1:0),
                    width: .2.widthX(context), height: .1.heightX(context))
            ),
          ],
        )


      ],
    ).paddingSV(context, .01);
  }

  Widget _offerPrice(context) {
    return Column(
      children: [
        _title(context:context,name: 'عرض السعر',icon: Icons.monetization_on_outlined),
        Row(
          children: [
            sharedBorderedInput(
              context,
              controller: priceController,

              borderWidth: 2,
              fillColor: Recolor.whiteColor,
              isPassword: false,
              radius: 5,
             // suffix: Icon(Icons.location_on_outlined, color: Recolor.txtColor),
              // keyboardType: TextInputType.none,
              hintStyle: bold12Blue().copyWith(color: Recolor.txtGreyColor),
              textStyle: bold14Blue().copyWith(color: Recolor.txtGreyColor),
              readOnly: false,
              hintText: '',
            ).cardAllSized(context,
                width: .7, height: .04, cardColor: Colors.transparent, elevation: 0),
            Text('ر.س',style: eBold16Blue(),).paddingSH(context, .01)
          ],
        )

      ],
    ).paddingSV(context, .01);
  }

  Widget _title(
      {required String name,
      required IconData icon,
      required BuildContext context}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Recolor.amberColor, size: .04.widthX(context)),
        Text(
          name,
          style: eBold16Blue(),
        ).paddingSH(context, .02),
      ],
    ).paddingB(context, .01);
  }
}
