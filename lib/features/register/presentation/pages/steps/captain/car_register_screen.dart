import 'package:cached_network_image/cached_network_image.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constant/text_style/text_style.dart';
import 'car_paper_screen.dart';

class CarRegisterScreen extends StatelessWidget {
  CarRegisterScreen({super.key});
  var manufactureController = TextEditingController();
  var vehicleNameController = TextEditingController();
  var yearOfReleaseController = TextEditingController();
  var plateNumberController = TextEditingController();
  var carRegisterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        //if(state is RegisterState){ RegisterCubit.get(context).getCarsModels();}

        if(state is SuccessGetCarsModelsState){
          print(state.cars);
        }


        if(state is SuccessSendCaptainVehicleDataState){
          RegisterCubit.get(context).getRequiredDocs();
                 navigateTo(context, RegisterCarPaperScreen());

        }
        if(state is ErrorSendCaptainVehicleDataState){
        showErrorToast(message:state.errorMsg );

        }


      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        if(cubit.carsModels.isEmpty){ RegisterCubit.get(context).getCarsModels();}
        print(state);

        return Scaffold(
          appBar: sharedAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopTextColumn(context),
                Form(
                  key: carRegisterFormKey,
                  child: Column(
                    children: [
                      _buildManufactureCompany(context,RegisterCubit.get(context)),
                      _buildVehicleName(context,RegisterCubit.get(context)),


                      sharedUnderLineInput(context,
                          controller: plateNumberController,
                          labelText: 'Plate Number'.tr(context)),
                      _buildRowRentRadio(context, cubit),
                      _buildButtonAttach3CarPhoto(context),
                      _buildButtonNext(context),
                    ],
                  ).paddingSH(context, 0.03),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("To Finish".tr(context), style:med12(context)),
        Text("Enter car".tr(context), style: taj25BoldBlue()),
        Text("desc Car".tr(context),
            textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
  }


  Widget _buildButtonNext(BuildContext context) {
    return sharedElevatedButton(
        context: context,
        onPressed: () async{

         var  cubit=RegisterCubit.get(context);
         if(cubit.carImagesPicked.isEmpty||cubit.carImagesPicked.length<3){
           showErrorToast(message:'select 3 images ' );
           return;}

         if(cubit.selectedCarDataModel==null||cubit.selectedCarModel==null){
           showErrorToast(message:'select car' );
           return;
         }

          if (carRegisterFormKey.currentState!.validate()) {
            var vehicleCaptain=CaptainVehicleModel(
              boardNumber: plateNumberController.text,
              captainId: cubit.userId!.toString(),
              carDataId: cubit.selectedCarDataModel!.carId!,
              ownershipType: cubit.isRent?'0':'1'

            );
           await cubit.sendCaptainVehicleData(captainVehicleModel: vehicleCaptain);




          }
        },
        txt: 'next'.tr(context),
        horizontalPadding: 0.18.widthX(context),
        verticalPadding: 0.025.heightX(context),
        radius: 9,
        textStyle: bold16(context).copyWith( color: Theme.of(context).primaryColor,));
  }

  Widget _buildButtonAttach3CarPhoto(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: ()async {

             await BlocProvider.of<RegisterCubit>(context,listen: false).pickImageFromGallery(photoType: '');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Theme.of(context).canvasColor,
                ),
                Text("Attach at least 3 photos, one of the inside".tr(context),
                    style: taj11MedBlue())
              ],
            )).paddingSV(context, 0.03),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: BlocProvider.of<RegisterCubit>(context,listen: false).carImagesFiles.map((e) =>
                Container(
                  width: 0.90.widthX(context) * .15,
                  height: .05.heightX(context),
                  decoration: BoxDecoration(
                    color: Recolor.txtGreyColor.withOpacity(.2),
                    image: DecorationImage(
                      image: FileImage(e),
                      fit: BoxFit.fill
                    )
                  ),
                ).paddingSH(context,.01)


            ).toList(),
          ),
        )
      ],
    ).paddingB(context, 0.05);
  }

  Widget _buildRowRentRadio(BuildContext context, RegisterCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Property Type'.tr(context), style: taj12RegGree()),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadio(cubit, false,context),
            Text("ownership".tr(context), style: taj12RegGree()),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadio(cubit, true,context),
            Text("rent".tr(context), style: taj12RegGree()),
          ],
        ),
      ],
    ).paddingT(context, 0.025);
  }

  Radio<bool> _buildRadio(RegisterCubit cubit, bool value,context) {
    return Radio(
        fillColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
        value: value,
        groupValue: cubit.isRent,
        onChanged: (value) => cubit.onChangedRadioRent(value));
  }



  Widget _buildManufactureCompany(BuildContext context,RegisterCubit cubit){

    return
      ListTile(
        onTap: ()async{
          await showDialog(context: context, builder: (context) =>
              Dialog(
                child: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      children:RegisterCubit.get(context).carsModels.map((e) =>
                          InkWell(
                              onTap: (){
                                RegisterCubit.get(context).onSelectCarModel(e);
                                Navigator.pop(context);
                              },

                              child: ListTile(
                                title:  Text(e.name!),
                                trailing:CachedNetworkImage(
                                  imageUrl://e.carLogo??
                                      "https://cdn-icons-png.flaticon.com/512/595/595067.png",
                                 // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  height: 20,
                                ) ,


                              ))).toList() ,
                    ),
                  ),
                ),
              ),).then((value) {
            if(RegisterCubit.get(context).selectedCarModel!=null){
              RegisterCubit.get(context).getCarsDataModels(id:RegisterCubit.get(context).selectedCarModel!.id! );
            }});
        },
        title: Text(cubit.selectedCarModel==null?'Manufacture'.tr(context):cubit.selectedCarModel!.name!) ,
        trailing:cubit.selectedCarModel==null?const SizedBox():CachedNetworkImage(
          imageUrl://cubit.selectedCarModel!.carLogo??
              "https://cdn-icons-png.flaticon.com/512/595/595067.png",
         // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress,color: Colors.red),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          height: 25,
        )  ,
      )
      ;

  }


  Widget _buildVehicleName(BuildContext context,RegisterCubit cubit){

    return
      InkWell(

        onTap: ()async{
          print('s');
          await showDialog(context: context, builder: (context) =>
            Dialog(
              child: SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children:RegisterCubit.get(context).carsDataModels.map((e) =>
                        ListTile(
                          title:  Text(e.model!),
                          trailing:Text(e.year!) ,
                          subtitle: Text(e.category!),
                          onTap: (){
                            RegisterCubit.get(context).onSelectDataCarModel(e);
                            Navigator.pop(context);
                          },


                        )).toList() ,
                  ),
                ),
              ),
            ),).then((value) {
              if(RegisterCubit.get(context).selectedCarDataModel!=null){

                RegisterCubit.get(context).getCarsDataModels(id:RegisterCubit.get(context).selectedCarModel!.id! );
              }

          });
        },
        child:// Text(RegisterCubit.get(context,).selectedCarDataModel==null?'Vehicle name'.tr(context):RegisterCubit.get(context,).selectedCarDataModel!.model!).paddingS(context, .05, .05),
          ListTile(
            title:  Text(cubit.selectedCarDataModel==null?'Vehicle name'.tr(context):cubit.selectedCarDataModel!.model!),
            trailing:Text(cubit.selectedCarDataModel==null?'':cubit.selectedCarDataModel!.year!) ,
            subtitle: Text(cubit.selectedCarDataModel==null?'':cubit.selectedCarDataModel!.category!),
            onTap: ()async{
              await showDialog(context: context, builder: (context) =>
                  Dialog(
                    child: SizedBox(
                      child: SingleChildScrollView(
                        child: Column(
                          children:RegisterCubit.get(context).carsDataModels.map((e) =>
                              ListTile(
                                title:  Text(e.model!),
                                trailing:Text(e.year!) ,
                                subtitle: Text(e.category!),
                                onTap: (){
                                  RegisterCubit.get(context).onSelectDataCarModel(e);
                                  Navigator.pop(context);
                                },


                              )).toList() ,
                        ),
                      ),
                    ),
                  ),).then((value) {
              if(RegisterCubit.get(context).selectedCarDataModel!=null){

              RegisterCubit.get(context).getCarsDataModels(id:RegisterCubit.get(context).selectedCarModel!.id! );
              }

              });
            },


          )

      )
      ;

  }



}
