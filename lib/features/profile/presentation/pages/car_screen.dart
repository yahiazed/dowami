import 'package:cached_network_image/cached_network_image.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/loading_widget.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/register/data/models/captain_vehicle_model.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constant/text_style/text_style.dart';

class ProfileCarScreen extends StatelessWidget {
  ProfileCarScreen({super.key});
  var manufactureController = TextEditingController();
  var vehicleNameController = TextEditingController();
  var yearOfReleaseController = TextEditingController();
  var plateNumber1Controller = TextEditingController();
  var plateNumber2Controller = TextEditingController();
  var carRegisterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      /* listenWhen: (previous, current) =>
      current is SuccessSendCaptainVehicleDataState
          || current is ErrorSendCaptainVehicleDataState
          || current is EndStartingPageState
          ||current is SuccessGetCarsModelsState,
      buildWhen: (previous, current) =>
      current is SuccessSendCaptainVehicleDataState
          ||current is ErrorSendCaptainVehicleDataState
          ||current is EndStartingPageState
          ||current is SuccessGetCarsModelsState,*/

      listener: (context, state) {
        if(state is EndStartingPageState){
          print('getting CarsModels');
          RegisterCubit.get(context).getCarsModels(lang: MainSettingsCubit.get(context).languageCode) ;


        }

        if(state is SuccessSendCaptainVehicleDataState){
          RegisterCubit.get(context).getRequiredDocs( lang: MainSettingsCubit.get(context).languageCode);
          navigateTo(context, const HomeScreen());

        }
        if(state is ErrorSendCaptainVehicleDataState){
          showErrorToast(message:state.errorMsg );

        }
        if(state is ErrorGetCarsModelsState){
          showErrorToast(message: state.errorMsg);

        }

      },
      builder: (context, state) {


        if( RegisterCubit.get(context).carsModels.isEmpty){
          print('here');
          RegisterCubit.get(context).getCarsModels(lang: MainSettingsCubit.get(context).languageCode) ;

        }

        return Scaffold(
            appBar: sharedAppBar(context: context,onTap: (){navigateRem(context, const HomeScreen());}),
            body://state is SuccessGetCarsModelsState ?
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTopTextColumn(context),
                  Form(
                    key: carRegisterFormKey,
                    child: Column(
                      children: [
                        // _buildManufactureCompany(),
                        _buildManufactureCompany2().paddingB(context, .01),
                        // _buildVehicleName(),
                        _buildVehicleName2( ).paddingB(context, .01),



                        _buildCarYear(context).paddingB(context, .01),






                        SizedBox(height: .01.heightX(context),),



                        _buildPlateNumber(context),
                        _buildRowRentRadio( ),
                        _buildButtonAttach3CarPhoto( ),
                        RegisterCubit.get(context).loading?const Center(child: CircularProgressIndicator()): _buildButtonNext(context),
                      ],
                    ).paddingSH(context, 0.03),
                  )
                ],
              ),
            )
          //: loadingWidget(context),
        );


      },
    );
  }




  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("To Finish".tr(context), style:med12(context)),
        Text("Enter car".tr(context), style: reg25(context)),
        Text("desc Car".tr(context),
            textAlign: TextAlign.center, style: med11(context)),
      ],
    ).paddingS(context, 0.1, 0.06);
  }


  Widget _buildButtonNext(BuildContext context) {
    return sharedElevatedButton(
        context: context,
        onPressed: () async{

          var  cubit=RegisterCubit.get(context);
          if(cubit.carImagesPicked.isEmpty||cubit.carImagesPicked.length<3){
            showErrorToast(message:'select3Images'.tr(context) );
            return;}

          if(cubit.selectedCarDataModel==null||cubit.selectedCarModel==null){
            showErrorToast(message:'selectCar'.tr(context) );
            return;
          }

          if (carRegisterFormKey.currentState!.validate()) {

            cubit.loading=true;
            var vehicleCaptain=CaptainVehicleModel(
                boardNumber: plateNumber1Controller.text+plateNumber1Controller.text,
                captainId: LoginCubit.get(context).userId!.toString(),
                carDataId: cubit.selectedCarDataModel!.carId!,
                ownershipType: cubit.isRent?'0':'1',
                carYear: yearOfReleaseController.text


            );
            print(vehicleCaptain);


            await cubit.sendCaptainVehicleData(captainVehicleModel: vehicleCaptain,lang: MainSettingsCubit.get(context).languageCode);
            cubit.loading=false;



          }
        },
        txt: 'next'.tr(context),
        horizontalPadding: 0.18.widthX(context),
        verticalPadding: 0.025.heightX(context),
        radius: 9,
        textStyle: bold16(context).copyWith( color: Theme.of(context).primaryColor,));
  }

  Widget _buildButtonAttach3CarPhoto( ) {
    return   BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is SuccessPickImageState ||current is ErrorPickImageState ,
        buildWhen: (previous, current) =>current is SuccessPickImageState||current is ErrorPickImageState ,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Column(
            children: [
              TextButton(
                  onPressed: ()async {

                    await cubit.pickImageFromGallery(photoType: '');
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color:  Recolor.hintColor,
                        size: .05.widthX(context),
                      ),
                      Text('  ${"Attach at least 3 photos, one of the inside".tr(context)}',
                          style:reg16(context).copyWith(color: Recolor.hintColor))
                    ],
                  )).paddingSV(context, 0.03),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: cubit.carImagesFiles.map((e) =>
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
    );
  }

  Widget _buildRowRentRadio( ) {
    return   BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is EndChangeRadioRentState  ,
        buildWhen: (previous, current) =>current is EndChangeRadioRentState ,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Property Type'.tr(context), style: reg12(context).copyWith(color: Recolor.rowColor)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRadio(cubit, false,context),
                  Text("ownership".tr(context), style: reg12(context).copyWith(color: Recolor.rowColor)),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildRadio(cubit, true,context),
                  Text("rent".tr(context), style:reg12(context).copyWith(color: Recolor.rowColor)),
                ],
              ),
            ],
          ).paddingT(context, 0.025);
        }
    );
  }

  Radio<bool> _buildRadio(RegisterCubit cubit, bool value,context) {
    return Radio(
        fillColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
        value: value,
        groupValue: cubit.isRent,
        onChanged: (value) => cubit.onChangedRadioRent(value));
  }









  Widget _buildCarYear(context){
    return   sharedUnderLineInput(context,
        controller: yearOfReleaseController,
        /* inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],*/
        labelText: 'year of release'.tr(context),
        labelStyle: reg16(context).copyWith(color: Recolor.hintColor),
        textAlign: TextAlign.left,
        readOnly: true,
        onTap: (){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Select Year"),
                content: Container( // Need to use container to add size constraint.
                  width: 300,
                  height: 300,
                  child: YearPicker(
                    firstDate: DateTime(2000,1),
                    lastDate: DateTime(DateTime.now().year,2),
                    initialDate: DateTime.now(),
                    // save the selected date to _selectedDate DateTime variable.
                    // It's used to set the previous selected date when
                    // re-showing the dialog.
                    selectedDate:DateTime.now() ,
                    onChanged: (DateTime dateTime) {
                      yearOfReleaseController.text=dateTime.year.toString();
                      Navigator.pop(context);


                    },
                  ),
                ),
              );
            },
          );

        });
  }
  Widget _buildManufactureCompany2(){
    return    BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is EndSelectCarModelState  ,
        buildWhen: (previous, current) =>current is EndSelectCarModelState ,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=RegisterCubit.get(context);
          return sharedUnderLineInput(context,
              controller: manufactureController,
              /* inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],*/
              labelText: 'Manufacture'.tr(context),
              labelStyle: reg16(context).copyWith(color: Recolor.hintColor),
              textAlign: TextAlign.left,

              readOnly: true,
              onTap: ()async{
                await showDialog(context: context, builder: (context) =>
                    Dialog(
                      child: SizedBox(
                          child: ListView.builder(
                            itemCount:cubit.carsModels.length ,
                            physics:BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>  ListTile(
                              title:  Text(cubit.carsModels[index].name!),
                              trailing:CachedNetworkImage(
                                imageUrl:cubit.carsModels[index].carLogo??
                                    "https://img.lovepik.com/element/40143/4180.png_300.png",
                                // progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                height: 50,width: 50,
                              ) ,
                              onTap:(){
                                cubit.onSelectCarModel(cubit.carsModels[index]);
                                manufactureController.text=cubit.carsModels[index].name!;
                                Navigator.pop(context);
                              } ,
                            ),
                          )
                      ),
                    ),).then((value) {
                  if(cubit.selectedCarModel!=null){
                    cubit.getCarsDataModels(id:cubit.selectedCarModel!.id!,lang: MainSettingsCubit.get(context).languageCode );


                  }});
              });
        }
    );
  }

  Widget _buildVehicleName2( ){

    return    BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is EndSelectCarDataModelState ||current is EndSelectCarModelState ,
        buildWhen: (previous, current) =>current is EndSelectCarDataModelState ||current is EndSelectCarModelState,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return sharedUnderLineInput(context,
              controller: vehicleNameController,
              /* inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],*/
              labelText: 'Vehicle name'.tr(context),
              labelStyle: reg16(context).copyWith(color: Recolor.hintColor),
              textAlign: TextAlign.left,
              readOnly: true,
              onTap: ()async {
                if (cubit.carsDataModels.isNotEmpty) {
                  await showDialog(
                      context: context,
                      builder: (context) => Dialog(
                          child: ListView.builder(
                            itemCount: cubit.carsDataModels.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => ListTile(
                              title: Text(cubit.carsDataModels[index].model!),
                              trailing: Text(cubit.carsDataModels[index].category!),

                              onTap: () {
                                cubit.onSelectDataCarModel(
                                    cubit.carsDataModels[index]);
                                vehicleNameController.text='${cubit.carsDataModels[index].category!}       ${cubit.carsDataModels[index].model!}';
                                Navigator.pop(context);
                              },
                            ),
                          )));
                }

              });
        }
    );

  }


  Widget _buildPlateNumber(context){
    return

      Row(

        children: [
          sharedUnderLineInput(context,
            controller: plateNumber1Controller,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4)
            ],
            labelText: 'PlateNumberNumbers'.tr(context),
            labelStyle:  reg14(context).copyWith(color: Recolor.hintColor),
            textAlign: TextAlign.left,
          ).paddingSH(context, .03).expandedWidget(flex: 1),

          sharedUnderLineInput(context,
            controller: plateNumber2Controller,
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              // FilteringTextInputFormatter(RegExp("^[u0621-u064A040]+"), allow: true),


              LengthLimitingTextInputFormatter(3)
            ],
            labelText: 'PlateNumberCharacters'.tr(context),
            labelStyle:  reg14(context).copyWith(color: Recolor.hintColor),
            textAlign: TextAlign.left,


          ).paddingSH(context, .03).expandedWidget(flex: 1),





        ],
      )
    ;
  }


}


