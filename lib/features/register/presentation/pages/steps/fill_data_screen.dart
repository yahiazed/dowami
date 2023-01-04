

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/features/terms/presentation/pages/privacy_policy_screen.dart';
import 'package:dowami/features/terms/presentation/pages/terms_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../../constant/shared_widgets/shared_accept_terms.dart';
import '../../../data/models/user_model.dart';
import 'captain/car_register_screen.dart';
import 'get_location_dialog.dart';
import 'register_final_screen.dart';

class FillUserRegisterDataScreen extends StatelessWidget {



  FillUserRegisterDataScreen({super.key,});

 final GlobalKey<FormState> registerDataFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController fNameController = TextEditingController();

  final TextEditingController surNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController nNumController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final TextEditingController regionController = TextEditingController();

  final TextEditingController neighborhoodController = TextEditingController();

  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isAcceptTerms = false;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {

        if(state is SuccessProfileDataState ){
          print('success state');
          print(state.token);
          RegisterCubit.get(context).token=state.token;
          navigateTo(context,const RegisterFinalScreen());
        }
        if(state is ErrorProfileDataState){
          showErrorToast(message: state.errorMsg);

        }


      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);


        return Scaffold(
          appBar: sharedAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopTextColumn(context),
                Form(
                  key: registerDataFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFirstNameAndPhotoRow(context, nameController,cubit),
                      _buildFatherAndNickNameRow(context, fNameController, surNameController),
                      _buildEmailRow(context, emailController),
                      _buildNationalNumRow(context, nNumController),
                      _buildBirthDateAndGenderRow(context, dateController),
                      _buildAddressAndLocation(context,cubit),

                      //  isCaptain
                      if (!cubit.isCaptain) _buildIBANCaptain(context, nameController),

                      buildAcceptsTermsRow(cubit.isAcceptTerms, context),
                      _buildOnSubmitButton(context)
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

  Widget _buildOnSubmitButton(BuildContext context) {
    return sharedElevatedButton(
      onPressed: ()async {
        if (registerDataFormKey.currentState!.validate()) {
          switch (RegisterCubit.get(context).userType) {
            case 'captain':
              navigateTo(context, CarRegisterScreen());
              break;
            case 'client':
              var userModel=UserModel(
                userId: RegisterCubit.get(context).userId,
                birthDate: dateController.text,
                nickName: surNameController.text,
                fatherName: fNameController.text,
                firstName: nameController.text,
                 city: cityController.text,
                area: regionController.text,
                district: neighborhoodController.text,
                gender: RegisterCubit.get(context).isMale?'Male':'Female',
                nationalId: nNumController.text,
               // avatar:  RegisterCubit.get(context).picked

              );

              try{
                await RegisterCubit.get(context).sendCompleteProfileData(userModel: userModel);

              }catch(e){print('error');}




              print('Client+++');
              break;
          }
        }
      },
      txt: 'Confirm'.tr(context),
      textStyle: taj19BoldWhite(),
      radius: 9,
      color: Recolor.amberColor,
      horizontalPadding: 0.25.widthX(context),
      verticalPadding: 0.025.heightX(context),
    );
  }

  Widget _buildIBANCaptain(
      BuildContext context, TextEditingController nameController) {
    return sharedUnderLineInput(context,
        controller: nameController,
        labelText: 'IBAN'.tr(context),
        keyboardType: TextInputType.text);
  }



  Column _buildAddressAndLocation( BuildContext context,RegisterCubit cubit){

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: cityController,
                  labelText: 'City'.tr(context),
                  keyboardType: TextInputType.text),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: regionController,
                  labelText: 'Region'.tr(context),
                  keyboardType: TextInputType.text),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: neighborhoodController,
                  labelText: 'Neighborhood'.tr(context),
                  keyboardType: TextInputType.text),
            ),
          ],
        ),
        TextButton(
            onPressed: () async{


              await cubit.getPermissions(context) ;

              await Geolocator.getCurrentPosition().then((value) =>  cubit.latLng=LatLng(value.latitude,value.longitude) );

              await  showDialog(context: context, builder: (context) =>Dialog(
                child: GetLocationDialog(),
              ) ,).then((value) {
                if( RegisterCubit.get(context).city.isNotEmpty){cityController.text=RegisterCubit.get(context).city;}
                if( RegisterCubit.get(context).area.isNotEmpty){regionController.text=RegisterCubit.get(context).area;}
                if( RegisterCubit.get(context).district.isNotEmpty){neighborhoodController.text=RegisterCubit.get(context).district;}
              } );





            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Or select on the map'.tr(context),
                    style: taj11RegGreeHintUnderLine()),
                Icon(Icons.place_outlined, color: Recolor.hintColor, size: 15),
              ],
            ))
      ],
    );
  }



  Row _buildBirthDateAndGenderRow (BuildContext context, TextEditingController dateController) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Date of Birth".tr(context), style: taj12RegGreeHint()),
        sharedCardInput(
          context,
          controller: dateController,
          hintText: '?',
          keyboardType: TextInputType.none,
          txtStyle: taj12RegGree(),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16

              dateController.text =
                  formattedDate; //set output date to TextField value.
              RegisterCubit.get(context).birthDate =
                  formattedDate; //set output date to TextField value.
            } else {debugPrint('null in date');}
          },
        )
            .roundWidget(
                width: 0.3.widthX(context),
                height: 0.035.heightX(context),
                radius: 9)
            .cardAll(elevation: 7, radius: 10)
            .paddingSH(context, 0.02),

        Text("Gender".tr(context), style: taj12RegGreeHint())
            .paddingSH(context, 0.015),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('male'.tr(context), style: taj12RegGree()),
            Radio(
              fillColor: MaterialStatePropertyAll(Recolor.amberColor),
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
            Text('female'.tr(context), style: taj12RegGree()),
            Radio(
              fillColor: MaterialStatePropertyAll(Recolor.amberColor),
              value: false,
              groupValue: RegisterCubit.get(context).isMale,
              onChanged: (value) =>
                  RegisterCubit.get(context).onChangedGenderRadio(value),
            )
          ],
        )
      ],
    );
  }

  Widget _buildNationalNumRow(
      BuildContext context, TextEditingController nNumController) {
    return sharedUnderLineInput(context,
            controller: nNumController,
            labelText: 'National number'.tr(context))
        .paddingB(context, 0.019);
  }

  Widget _buildEmailRow(
      BuildContext context, TextEditingController emailController) {
    return sharedUnderLineInput(context,
        controller: emailController,
        labelText: 'email'.tr(context),
        keyboardType: TextInputType.emailAddress);
  }

  Row _buildFatherAndNickNameRow(BuildContext context, TextEditingController fNameController,
      TextEditingController surNameController) {
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

  Row _buildFirstNameAndPhotoRow(BuildContext context, TextEditingController nameController,RegisterCubit cubit) {
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
            await cubit.pickImageFromGallery();

          },
          child:  cubit.imageFile==null ? Container(
            width: 0.35.widthX(context),
            height: 0.1.heightX(context),
            decoration: BoxDecoration(
                border: Border.all(color: Recolor.mainColor, width: 2),
                color: Recolor.underLineColor,
                shape: BoxShape.circle,
            ),
              child: Icon(
              Icons.camera_alt_outlined,
              color: Recolor.mainColor,)
          )


          :
          Container(
            width: 0.35.widthX(context),
            height: 0.1.heightX(context),
            decoration: BoxDecoration(
                border: Border.all(color: Recolor.mainColor, width: 2),
                color: Recolor.underLineColor,
                shape: BoxShape.circle,
                image: DecorationImage(image:   FileImage(cubit.imageFile!),fit: BoxFit.contain,)
            ),
          )

          ,
        )
      ],
    );
  }

  // Row _buildAcceptsTermsRow(bool isAcceptTerms, BuildContext context) {
  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Few steps left".tr(context), style: taj12MedBlue()),
        Text("Let's get to know you".tr(context), style: taj25BoldBlue()),
        Text("informationProvided".tr(context),
            textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
  }
}




























