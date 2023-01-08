

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

import 'package:dowami/helpers/localization/app_localization.dart';

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
  final TextEditingController captainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {

        if(state is SuccessProfileDataState ){

          RegisterCubit.get(context).token=state.token;
          RegisterCubit.get(context).userId=state.userId;
          debugPrint(RegisterCubit.get(context).userId.toString());
          debugPrint(RegisterCubit.get(context).token.toString());

          if(RegisterCubit.get(context).userType=='client')
          { navigateTo(context,const RegisterFinalScreen()); }
          else{

            RegisterCubit.get(context). getCarsModels();
          }










        }
        if(state is ErrorProfileDataState){
          showErrorToast(message: state.errorMsg);
         // errors=(state.errorModel.errors!.values).toList() ;
          errors=List<String> .from(state.errorModel.errors!.values.map((e) => e[0])).toList();



        }
        if(state is ErrorPermissionsLocationState){
          showErrorToast(message: state.errorMsg);

        }
        if(state is ErrorGetCarsModelsState){
          showErrorToast(message: state.errorMsg);

        }
        if(state is SuccessGetCarsModelsState){
          navigateTo(context, CarRegisterScreen());

        }



      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        print(state);
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
                      _buildFirstNameAndPhotoRow(context,  cubit),
                      _buildFatherAndNickNameRow(context,  ),
                      _buildEmailRow(context, ),
                      _buildNationalNumRow(context ),
                      _buildBirthDateAndGenderRow(context, ),
                      _buildAddressAndLocation(context,cubit),
                      //  isCaptain
                      if (!cubit.isCaptain) _buildIBANCaptain(context,  ),
                      _buildAcceptTermsRow( context,cubit,),
                      _buildErrorsMessages()
                          .cardAll(elevation: 1, radius: 0)
                          .paddingSV(context,0.01),
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
        Text("Few steps left".tr(context), style: taj12MedBlue()),
        Text("Let's get to know you".tr(context), style: taj25BoldBlue()),
        Text("informationProvided".tr(context),
            textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
  }
  Row    _buildFirstNameAndPhotoRow(BuildContext context,RegisterCubit cubit) {
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
                image: DecorationImage(image:   FileImage(cubit.avatarImageFile!),fit: BoxFit.contain,)
            ),
          )

          ,
        )
      ],
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
        labelText: 'National number'.tr(context))
        .paddingB(context, 0.019);
  }
  Column     _buildBirthDateAndGenderRow (BuildContext context,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text("Date of Birth".tr(context), style: taj12RegGreeHint()),
            sharedCardInput(
              context,
              controller: dateController,
              hintText: '?',
              keyboardType: TextInputType.none,
              txtStyle: taj12RegGree().copyWith( fontSize: 8),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 19*365)),
                    firstDate:  DateTime(1950),
                    lastDate:  DateTime.now().subtract(const Duration(days: 19*365)));

                if (pickedDate != null) {
                  print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
                  print(formattedDate);
                  dateController.text = formattedDate;
                  RegisterCubit.get(context).onSelectDate(formattedDate);

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
            Text("Gender".tr(context), style: taj12RegGreeHint()).paddingSH(context, 0.015),
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
        ),

      ],
    );
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
                  keyboardType: TextInputType.none),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: regionController,
                  labelText: 'Region'.tr(context),
                  keyboardType: TextInputType.none),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: sharedUnderLineInput(context,
                  controller: neighborhoodController,
                  labelText: 'Neighborhood'.tr(context),
                  keyboardType: TextInputType.none),
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
                Text('select on the map'.tr(context),
                    style: taj11RegGreeHintUnderLine()),
                Icon(Icons.place_outlined, color: Recolor.hintColor, size: 15),
              ],
            ))
      ],
    );
  }
  Widget _buildIBANCaptain(BuildContext context, ) {
    return sharedUnderLineInput(context,
        controller: captainController,
        labelText: 'IBAN'.tr(context),
        keyboardType: TextInputType.text);
  }
  Widget _buildAcceptTermsRow(BuildContext context,RegisterCubit cubit){
    return
      buildAcceptsTermsRow(cubit.isAcceptTerms, context)
    ;
  }
   List<dynamic> errors=[];
  Widget _buildErrorsMessages(){
    return Column(


      crossAxisAlignment: CrossAxisAlignment.end,
      children:errors.map((e) =>
          Text('$e  * ',style: taj11MedGreeHint().copyWith(color: Colors.red) ,)
      ).toList() ,
    );
  }
  Widget _buildOnSubmitButton(BuildContext context) {
    return sharedElevatedButton(
      onPressed: ()async {
        if(!RegisterCubit.get(context).isAcceptTerms){
          showErrorToast(message:'terms');
          return;

        }

        if (registerDataFormKey.currentState!.validate()) {
          if(RegisterCubit.get(context).avatarImageFile==null){
            showErrorToast(message:' select image');
            return;

          }


          var userModel=UserModel(
             // userId: 4,
              birthDate: dateController.text,
              nickName: surNameController.text,
              fatherName: fNameController.text,
              firstName: nameController.text,
              city: '1'
            //  cityController.text
              ,
              area:'2'
              //regionController.text
              ,
              district:'1'
             //  neighborhoodController.text
               ,
              gender: RegisterCubit.get(context).isMale?'Male':'Female',
              nationalId: nNumController.text,
              iBAN: captainController.text,
              lat: RegisterCubit.get(context).latLng!.latitude.toString(),
              long: RegisterCubit.get(context).latLng!.longitude.toString(),
              userType: RegisterCubit.get(context).userType,
            mobile: RegisterCubit.get(context).phoneCode+RegisterCubit.get(context).phoneNumber


          );

            await RegisterCubit.get(context).sendCompleteProfileData(userModel: userModel);




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













}




























