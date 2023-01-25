

import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/maps/helper/permission.dart';
import 'package:dowami/features/maps/map_widget/location_dialog.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/select_register_screen.dart';

import 'package:dowami/helpers/localization/app_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
 import '../../../../../constant/shared_widgets/shared_accept_terms.dart';
import '../../../data/models/user_model.dart';
import 'captain/car_register_screen.dart';
import 'register_final_screen.dart';

class FillUserRegisterDataScreen extends StatelessWidget {



  FillUserRegisterDataScreen({super.key,});

 final GlobalKey<FormState> registerDataFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController surNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nNumController = TextEditingController();

  final TextEditingController dateController = TextEditingController();
  final TextEditingController captainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listenWhen: (previous, current) =>current is !StartTimeDownState||current is !EndTimeDownState||current is !TimeOutSendSmsCodeState ,
      buildWhen: (previous, current) =>current is !StartTimeDownState||current is !EndTimeDownState||current is !TimeOutSendSmsCodeState ,
 /*     listenWhen: (previous, current) =>
      current is SuccessProfileDataState
          || current is ErrorProfileDataState
          ||current is ErrorGetCarsModelsState
          ||current is SuccessGetCarsModelsState
          ||current is SuccessGetCitiesState
          ||current is EndStartingPageState
          ||current is SuccessCodeState
      ,


      buildWhen: (previous, current) =>
      current is SuccessProfileDataState
          ||current is ErrorProfileDataState
          ||current is SuccessGetCitiesState
          ||current is EndStartingPageState
          ||current is SuccessCodeState

      ,*/
      listener: (context, state) async{


        if(state is SuccessProfileDataState ){
         var registerCubit= RegisterCubit.get(context);
         var loginCubit=LoginCubit.get(context);

         registerCubit.token=state.token;
         registerCubit.userId=state.userId;

         loginCubit.phoneCode = registerCubit.phoneCode;
         loginCubit.phoneNumber = registerCubit.phoneNumber;
         loginCubit.password = registerCubit.userPassword;
         await loginCubit.login( lang: MainSettingsCubit.get(context).languageCode,);
         if(loginCubit.state is ErrorLoginState){navigateRem(context,const SelectLog());}
        print('saving');
        await loginCubit.saveDataToPrefs();
         print(' loginCubit state is ${loginCubit.state}');

         if(!registerCubit.isCaptain)
         {
           if(loginCubit.state is SuccessSaveDataState){

             navigateRem(context,const RegisterFinalScreen());}

           print('client loginCubit state is ${loginCubit.state}');
         }
         else{
           if(loginCubit.state is SuccessSaveDataState){

             navigateRem(context, CarRegisterScreen());}

           print('captain loginCubit state is ${loginCubit.state}');



         }


        }
        if(state is ErrorProfileDataState){
          showErrorToast(message: state.errorMsg);

          errors=List<String> .from(state.errorModel.errors!.values.map((e) => e[0])).toList();



        }







      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);

        print(state);
        return Scaffold(
          appBar: sharedAppBar(context: context,onTap: (){Navigator.pop(context);}),
          body:  SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopTextColumn(context),
                Form(
                  key: registerDataFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFirstNameAndPhotoRow(),
                      _buildFatherAndNickNameRow(context,  ),
                      _buildEmailRow(context, ),
                      _buildNationalNumRow(context ),
                      _buildBirthDateAndGenderRow(  ),
                      _buildAddressAndLocation(),
                      //  isCaptain
                      if (cubit.isCaptain) _buildIBANCaptain(context,  ),
                      _buildAcceptTermsRow( ),
                      _buildErrorsMessages(context)
                          .cardAll(elevation: 1, radius: 0)
                          .paddingSV(context,0.01),
                      cubit.loading?Center(child: CircularProgressIndicator()): _buildOnSubmitButton(context)
                    ],
                  ).paddingSH(context, 0.04),
                ),
              ],
            ),
          ),

        );
      },
    );
  }


  ///-(1)  title texts           [_buildTopTextColumn]
  ///-(2)  first name & avatar   [_buildFirstNameAndPhotoRow]
  ///-(3)  father & nick         [_buildFatherAndNickNameRow]
  ///-(4)  email                 [_buildEmailRow]
  ///-(5)  national number       [_buildNationalNumRow]
  ///-(6)  Birth Date & gender   [_buildBirthDateAndGenderRow]
  ///-(7)  address & location    [_buildAddressAndLocation]
  ///-(8)  IBAN Number (captain) [_buildIBANCaptain]
  ///-(9)  Accept terms          [_buildAcceptTermsRow]
  ///-(10)  errors          [_buildErrorsMessages]
  ///-(11)  on submit             [_buildOnSubmitButton]


  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Few steps left".tr(context), style: med12(context)),
        Text("Let's get to know you".tr(context), style: reg25(context)),
        Text("informationProvided".tr(context),
            textAlign: TextAlign.center, style: med11(context)),
      ],
    ).paddingS(context, 0.1, 0.06);
  }

  Widget    _buildFirstNameAndPhotoRow() {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is ErrorPickImageState ||current is SuccessPickImageState ,
        buildWhen: (previous, current) =>current is ErrorPickImageState ||current is SuccessPickImageState,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=RegisterCubit.get(context);
        return Row(
          children: [
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: nameController,
                  labelText: 'name'.tr(context),
                  keyboardType: TextInputType.text),
            ),
            InkWell(
              onTap: ()async{
                await cubit.pickImageFromGallery(photoType: 'avatar');

              },
              child:  cubit.avatarImageFile ==null ? Container(
                  width: 0.35.widthX(context),
                  height: 0.1.heightX(context),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).canvasColor, width: 2),
                    color: Recolor.underLineColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Theme.of(context).canvasColor,)
              )


                  :
              Container(
                width: 0.35.widthX(context),
                height: 0.1.heightX(context),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).canvasColor, width: 2),
                    color: Recolor.underLineColor,
                    shape: BoxShape.circle,
                    image: DecorationImage(image:   FileImage(cubit.avatarImageFile!),fit: BoxFit.contain,)
                ),
              )

              ,
            )
          ],
        );
      }
    );
  }
  Row     _buildFatherAndNickNameRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: sharedUnderLineInput(context,
              controller: fNameController,
              labelText: 'fName'.tr(context),
              keyboardType: TextInputType.text),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: sharedUnderLineInput(context,
              controller: surNameController,
              labelText: 'Surname'.tr(context),
              keyboardType: TextInputType.text),
        ),
      ],
    );
  }
  Widget _buildEmailRow(BuildContext context) {
    return sharedUnderLineInput(context,
        controller: emailController,
        labelText: 'email'.tr(context),
        keyboardType: TextInputType.emailAddress);
  }
  Widget _buildNationalNumRow(BuildContext context) {
    return sharedUnderLineInput(context,
        controller: nNumController,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        labelText: 'National number'.tr(context))
        .paddingB(context, 0.019);
  }


  Widget _buildBirthDateAndGenderRow () {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is EndSelectDateState ||current is EndChangeGenderRadioState ,
        buildWhen: (previous, current) =>current is EndSelectDateState ||current is EndChangeGenderRadioState,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=RegisterCubit.get(context);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text("Date of Birth".tr(context), style: reg12(context).copyWith(color: Recolor.hintColor)),
                sharedCardInput(
                  context,
                  controller: dateController,
                  hintText: '?',
                  keyboardType: TextInputType.none,
                  txtStyle: reg12(context).copyWith(color: Recolor.rowColor,fontSize: 8),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(const Duration(days: 19*365)),
                        firstDate:  DateTime(1950),
                        lastDate:  DateTime.now().subtract(const Duration(days: 19*365)));

                    if (pickedDate != null) {
                      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
                      dateController.text = formattedDate;
                      cubit.onSelectDate(formattedDate);

                    } else {debugPrint('null in date');}
                  },
                )
                    .roundWidget(
                    width: 0.20.widthX(context),
                    height: 0.045.heightX(context),
                    radius: 9)
                    .cardAll(elevation: 7, radius: 10)
                    .paddingSH(context, 0.01),

              ],
            ),

            Row(
              children: [
                Text("Gender".tr(context), style: reg12(context).copyWith(color: Recolor.hintColor)).paddingSH(context, 0.015),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('male'.tr(context), style: reg12(context).copyWith(color: Recolor.rowColor)),
                    Radio(
                      fillColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                      value: true,
                      groupValue: RegisterCubit.get(context).isMale,
                      onChanged: (value) =>
                          RegisterCubit.get(context).onChangedGenderRadio(value),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('female'.tr(context), style: reg12(context).copyWith(color: Recolor.rowColor)),
                    Radio(
                      fillColor: MaterialStatePropertyAll(Theme.of(context).primaryColor),
                      value: false,
                      groupValue: RegisterCubit.get(context).isMale,
                      onChanged: (value) =>
                          RegisterCubit.get(context).onChangedGenderRadio(value),
                    )
                  ],
                )
              ],
            ),

          ],
        );
      }
    );
  }
  Widget _buildAddressAndLocation(  ){

    return BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
        current is SuccessGetCitiesState  ||
        current is SuccessGetAreasState  ||
        current is SuccessGetDistrictsState  ||
        current is EndSelectCityState  ||
        current is EndSelectAreaState  ||
        current is EndSelectDistrictState

        ,
        buildWhen: (previous, current) =>
        current is SuccessGetCitiesState||
        current is SuccessGetAreasState||
        current is SuccessGetDistrictsState||
        current is EndSelectCityState||
        current is EndSelectAreaState||
        current is EndSelectDistrictState
        ,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit=RegisterCubit.get(context);
          if(RegisterCubit.get(context).cities.isEmpty){
            RegisterCubit.get(context).getCities(lang:MainSettingsCubit.get(context).languageCode );
            return const Center(child: CircularProgressIndicator());

          }
          else{
            return Row(
              children: [

                Expanded(
                  child: sharedCardInput(context,
                    controller: cubit.cityController,
                    hintText:  'City'.tr(context),
                    keyboardType: TextInputType.none,
                    txtStyle: bold16(context),
                    readOnly: true,
                    onTap: ()async{
                      await showDialog(context: context, builder: (context) =>

                      SelectAddressDialog(list:     cubit.cities,dialogType: DialogType.city,));
                    },


                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: sharedCardInput(context,
                    controller: cubit.areaController,
                    hintText:  'Region'.tr(context),
                    keyboardType: TextInputType.none,
                    txtStyle: bold16(context),
                    readOnly: true,

                    onTap: ()async{
                      await showDialog(context: context, builder: (context) =>
                          SelectAddressDialog(list:     cubit.areas,dialogType: DialogType.area,));
                    },


                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: sharedCardInput(context,
                    controller:cubit. districtController,
                    hintText:  'Neighborhood'.tr(context),
                    keyboardType: TextInputType.none,
                    txtStyle: bold16(context),

                    readOnly: true,
                    onTap: ()async{
                      await showDialog(context: context, builder: (context) =>
                          SelectAddressDialog(list:     cubit.districts,dialogType: DialogType.district,));
                    },


                  ),
                ),

              ],
            );
          }

      }
    );
  }
  Widget _buildIBANCaptain(BuildContext context, ) {
    return sharedUnderLineInput(context,
        controller: captainController,
        labelText: 'IBAN'.tr(context),
        keyboardType: TextInputType.text);
  }
  Widget _buildAcceptTermsRow( ){
    return   BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>current is EndChangeAcceptTermsState  ,
        buildWhen: (previous, current) =>current is EndChangeAcceptTermsState ,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
        return buildAcceptsTermsRow(cubit.isAcceptTerms, context);
      }
    );}


   List<dynamic> errors=[];
  Widget _buildErrorsMessages(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children:errors.map((e) =>
          Text('$e  * ',style: med11(context).copyWith(color: Colors.red) ,)
      ).toList() ,);
  }


  Widget _buildOnSubmitButton(BuildContext context) {
    return sharedElevatedButton(
      context: context,
      onPressed: ()async {

        var cubit=RegisterCubit.get(context);
        if(!cubit.isAcceptTerms){
          showErrorToast(message:'terms'.tr(context));
          return;}

        if (registerDataFormKey.currentState!.validate()) {
         /* if(cubit.avatarImageFile==null){
            showErrorToast(message:'select image');
            return;}*/

          cubit.loading=true;
          var userModel=UserModel(
             // userId: 4,
              birthDate: dateController.text,
              nickName: surNameController.text,
              fatherName: fNameController.text,
              firstName: nameController.text,
              city:cubit.city!.id.toString(),
              area:cubit.area!.id.toString(),
              district:cubit.district!.id.toString(),
              gender: cubit.isMale?'Male':'Female',
              nationalId: nNumController.text,
              iBAN:cubit.isCaptain? captainController.text:null,
              email:emailController.text,

              userType: cubit.userType,
            mobile: cubit.phoneCode+
                cubit.phoneNumber,
            password: cubit.userPassword,




          );
          print(userModel);
          print(userModel.toMap(userModel: userModel));

            await cubit.sendCompleteProfileData(userModel: userModel, lang: MainSettingsCubit.get(context).languageCode);

          cubit.loading=false;


        }
      },
      txt: 'Confirm'.tr(context),
      textStyle: eBold19(context).copyWith(color: Recolor.whiteColor),
      radius: 9,
      color: Theme.of(context).primaryColor,
      horizontalPadding: 0.25.widthX(context),
      verticalPadding: 0.025.heightX(context),
    );
  }












}



















enum DialogType {city,area,district}

class SelectAddressDialog extends StatelessWidget {
  final DialogType dialogType;
  final List list;
  const SelectAddressDialog({Key? key,required this.dialogType,required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Dialog(
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(10)),
      child:ListView.builder(
        itemCount:list.length ,
        physics:BouncingScrollPhysics() ,
        

        itemBuilder: (context, index) => Row(
        children: [
          sharedElevatedButton(
              txt:list[index].name! ,
              context: context,
              radius:10 ,
              textStyle:  bold16(context).copyWith(color: Recolor.whiteColor),
              //child:Text(e.name!,style: bold16(context),).roundWidget() ,
              onPressed:()async{
                String lang= MainSettingsCubit.get(context).languageCode;
                Navigator.pop(context);

                switch(dialogType){

                  case DialogType.city:
                    RegisterCubit.get(context).onSelectCity(city: list[index],   lang: lang);
                    break;
                  case DialogType.area:
                    RegisterCubit.get(context).onSelectArea(area: list[index],   lang: lang);
                    break;
                  case DialogType.district:
                    RegisterCubit.get(context).onSelectDistrict(district: list[index],   );
                    break;
                }





              } ,
              color: Theme.of(context).canvasColor


          ).expandedWidget(flex: 1),
        ],
      ).paddingSH(context, .1) ,).roundWidget(height: .4.heightX(context),radius: 10).paddingSV(context, .05)



    );
  }
}







