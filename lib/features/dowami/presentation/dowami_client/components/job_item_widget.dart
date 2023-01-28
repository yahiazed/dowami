import 'package:dowami/constant/enums/days_enums.dart';
import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/loading_widget.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/dowami/data/models/dowami_job_model.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding_platform_interface/src/models/placemark.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

List<LatLng>  stopPointssss=[
  const LatLng(36.01,36.01),
  const LatLng(36.02,36.02),
  const LatLng(36.03,36.03),


];
DowamiJobModel dowamiJobModel=DowamiJobModel(
    name:'الوظيفه',
    days: const['0','1','3'],
    carType: 'Sedan',
    requestType: '1',
    comingTime: '08:00' ,
    goingTime: '09:00' ,
   // LatLng(30.592153682326554, 31.52264703065157)
    fromLoc: const LatLng(30.592153682326554,31.52264703065157).toStringPoint(),
    toLoc: const LatLng(30.592153682366554,31.52264703066157).toStringPoint(),
    passengersCount:'4',
    priceOffer:'100',
    stopPoints:stopPointssss.map((e) =>LatLng(e.latitude,e.longitude).toStringPoint() ).toList(),
    status: 'تلقى العروض'

);
DowamiJobModel dowamiJobModel1=DowamiJobModel(
    name:'مدرسه الاولاد',
    days: const['0','1','3'],
    carType: 'Sedan',
    requestType: '1',
    comingTime: '08:00' ,
    goingTime: '09:00' ,
   // LatLng(30.592153682326554, 31.52264703065157)
    fromLoc: const LatLng(30.592153682326554,31.52264703065157).toStringPoint(),
    toLoc: const LatLng(30.592153682366554,31.52264703066157).toStringPoint(),
    passengersCount:'4',
    priceOffer:'100',
    stopPoints:stopPointssss.map((e) =>LatLng(e.latitude,e.longitude).toStringPoint() ).toList(),
    status: 'تلقى العروض'

);
DowamiJobModel dowamiJobModel2=DowamiJobModel(
    name:'المول',
    days: const['0','1','3'],
    carType: 'Sedan',
    requestType: '1',
    comingTime: '08:00' ,
    goingTime: '09:00' ,
   // LatLng(30.592153682326554, 31.52264703065157)
    fromLoc: const LatLng(30.592153682326554,31.52264703065157).toStringPoint(),
    toLoc: const LatLng(30.592153682366554,31.52264703066157).toStringPoint(),
    passengersCount:'4',
    priceOffer:'100',
    stopPoints:stopPointssss.map((e) =>LatLng(e.latitude,e.longitude).toStringPoint() ).toList(),
    status: 'ملغيه'

);
DowamiJobModel dowamiJobModel3=DowamiJobModel(
    name:'الجيم',
    days: const['0','1','3'],
    carType: 'Sedan',
    requestType: '1',
    comingTime: '08:00' ,
    goingTime: '09:00' ,
   // LatLng(30.592153682326554, 31.52264703065157)
    fromLoc: const LatLng(30.592153682326554,31.52264703065157).toStringPoint(),
    toLoc: const LatLng(30.592153682366554,31.52264703066157).toStringPoint(),
    passengersCount:'4',
    priceOffer:'100',
    stopPoints:stopPointssss.map((e) =>LatLng(e.latitude,e.longitude).toStringPoint() ).toList(),
    status: 'مفعله'

);



List<DowamiJobModel>lista=[
  dowamiJobModel,
  dowamiJobModel1,
  dowamiJobModel2,
  dowamiJobModel3,
];

class ExpansionItem extends StatefulWidget {
  final DowamiJobModel jobModel;
  const ExpansionItem({Key? key, required this.jobModel}) : super(key: key);

  @override
  State<ExpansionItem> createState() => _ExpansionItemState();
}

class _ExpansionItemState extends State<ExpansionItem> {

  bool isOpened=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocAddress();
  }
  @override
  Widget build(BuildContext context) {
    return  ExpansionTile(



      leading: SizedBox(
          width: .25.widthX(context) ,
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [TextButton(onPressed: (){}, child: Text(widget.jobModel.name!,style: isOpened?eBold16(context):bold14(context))),],)),



      title:isOpened?const SizedBox():offerStatus(status: widget.jobModel.status!),



      trailing:  showHideDetails(),








      backgroundColor: Theme.of(context).canvasColor.withOpacity(.04),
      collapsedBackgroundColor:  Theme.of(context).canvasColor.withOpacity(.04),











      onExpansionChanged: (v){setState(() {isOpened=v;});},


      children: [
        details()
      ],

    ).roundWidget(radius: 10).paddingB(context,0.015)
    ;
  }


  String showDetailsText='showDetails';
  IconData showDetailsIcon=Icons.add_circle_outline_rounded;
  String hideDetailsText='hideDetails';
  IconData hideDetailsIcon=Icons.info_outline;
  IconData d=Icons.add;
  Widget showHideDetails(){
    return
      SizedBox(
        width: .2.widthX(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text((isOpened?hideDetailsText:showDetailsText).tr(context),style: bold9(context).copyWith(color: Recolor.hintColor,decoration: TextDecoration.underline,height: 2,fontSize: .022.widthX(context)),),
            Icon(isOpened?hideDetailsIcon:showDetailsIcon,size: 20,color: Recolor.hintColor,)//.paddingSH(context, .005)
          ],
        )
      ).paddingL(context, 0.01)
      ;
  }

  String fromLoc='';
  String toLoc='';
Future<String> getAddressFunc({required String stringLoc})async{
  LatLng latLng=getLatLng(string: stringLoc);
  Placemark placeMark=await latLng.getPlaceMark();
  var city=placeMark.administrativeArea!;
  var area=placeMark.subAdministrativeArea!;
 var district=placeMark.locality!;

 return '$city, $area, $district';

}

getLocAddress()async{
  var fromLoc1=await getAddressFunc(stringLoc: widget.jobModel.fromLoc!);
  var toLoc1=await getAddressFunc(stringLoc: widget.jobModel.toLoc!);
  setState(() {
    fromLoc=fromLoc1;
    toLoc=toLoc1;
  });

}







  Widget offerStatus({required String status}){
    return
      SizedBox(
        width: .15.widthX(context) ,
        child:status=='active'?
            Center(child: Text(status,style: bold12(context).copyWith(color:Recolor.txtEffectiveColor)))


            : Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              child: Text('3',style: TextStyle(color: Colors.white,fontSize:.012.heightX(context) ),),
              backgroundColor: Colors.red,
              radius: .008.heightX(context),
            ).paddingB(context, 0.005),
            Center(child: Text(status,style: reg12(context).copyWith(color: Recolor.redColor),))
          ],
        ),
      )
      ;
  }

  Widget details(){
    return
      Column(
        children: [

          _buildPoint(location: fromLoc,name: 'startPoint'.tr(context)),
          _buildPoint(location: toLoc,name: 'endPoint'.tr(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              detailsWithIcons(icon: Icons.access_time, value: '5 km'),
              Column(
                children: [
                  Icon(Icons.calendar_month,color: Theme.of(context).primaryColor,size: 0.04.widthX(context),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: daysMap
                        .map((e) => Text(
                      e['name']!.tr(context),
                      style: bold9(context).copyWith(color: Recolor.whiteColor,fontSize: 8),
                    ).roundWidget(
                      color:widget.jobModel.days!.contains(e['id'])
                          ? Recolor.redColor.withOpacity(.5)
                          : Recolor.oGreenColor,
                      height: .02.heightX(context),
                      width: .04.widthX(context),
                      radius: 5,
                    ).paddingA(.005.widthX(context))
                    )
                        .toList(),
                  ),
                ],
              ).paddingS(context, .01, .0).roundWidget(radius: 5,color: Recolor.whiteColor).paddingSH(context, .01),
              detailsWithIcons(icon: Icons.people_alt_outlined, value: widget.jobModel.passengersCount!),
              detailsWithIcons(icon: Icons.access_time, value: widget.jobModel.goingTime!),
              detailsWithIcons(icon: Icons.access_time, value: widget.jobModel.comingTime!),

            ],
          ),



        ],
      ).paddingSH(context, .04).paddingB(context, .018)
      ;
  }

  Widget _buildPoint({required String location,required String name}){

    return
      Column(
        children: [
          Row(
            children: [
              Icon(Icons.location_on_outlined,color: Theme.of(context).primaryColor,size: 20,),
              Text(name,style: med12(context).copyWith(color: Recolor.txtGreyColor),)
            ],
          ).paddingB(context, .005),
          location.isEmpty?loadingWidget(context): Text(location,style: bold16(context),)
        ],
      ).paddingB(context, .01)

      ;

  }

  Widget detailsWithIcons({required String value,required IconData icon}){
  return
  Column(
    
    children: [
      Icon(icon,color: Theme.of(context).primaryColor,size: 0.04.widthX(context),).paddingS(context, .015,0.008)
      ,
      Text(value,style: bold12(context).copyWith(color: Recolor.txtGreyColor),)
    ],
  ).paddingS(context, .01, .0).roundWidget(radius: 5,color: Recolor.whiteColor).paddingSH(context, .01)

    ;
  }



}
