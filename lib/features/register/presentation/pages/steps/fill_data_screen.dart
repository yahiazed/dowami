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
import 'package:intl/intl.dart';

import '../../../../../constant/shared_widgets/shared_accept_terms.dart';
import '../../../data/models/user_model.dart';
import 'captain/car_register_screen.dart';
import 'register_final_screen.dart';

class FillUserRegisterDataScreen extends StatelessWidget {
  String phoneNumber;

  var registerDataFormKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var fNameController = TextEditingController();
  var surNameController = TextEditingController();
  var emailController = TextEditingController();
  var nNumController = TextEditingController();
  var cityController = TextEditingController();
  var regionController = TextEditingController();
  var neighborhoodController = TextEditingController();
  var dateController = TextEditingController();
  FillUserRegisterDataScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    bool isAcceptTerms = false;
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {

        if(state is SuccessProfileDataState ){
          print(state.token);
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
                      _buildRow1(context, nameController,cubit),
                      _buildRow2(context, fNameController, surNameController),
                      _buildRow3(context, emailController),
                      _buildRow4(context, nNumController),
                      _buildRow5(context, dateController),
                      _buildRow6(context, cityController, regionController,
                          neighborhoodController),
                      _buildRow7(context),
                      //  isCaptain
                      if (true) _buildRowIbanCaptain(context, nameController),
                      buildAcceptsTermsRow(cubit.isAcceptTerms, context),
                      _buildButton(context)
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

  Widget _buildButton(BuildContext context) {
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

              }catch(e){}




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

  Widget _buildRowIbanCaptain(
      BuildContext context, TextEditingController nameController) {
    return sharedUnderLineInput(context,
        controller: nameController,
        labelText: 'IBAN'.tr(context),
        keyboardType: TextInputType.text);
  }

  TextButton _buildRow7(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Or select on the map'.tr(context),
                style: taj11RegGreeHintUnderLine()),
            Icon(Icons.place_outlined, color: Recolor.hintColor, size: 15),
          ],
        ));
  }

  Row _buildRow6(
      BuildContext context,
      TextEditingController cityController,
      TextEditingController regionController,
      TextEditingController neighborhoodController) {
    return Row(
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
    );
  }

  Row _buildRow5(BuildContext context, TextEditingController dateController) {
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

  Widget _buildRow4(
      BuildContext context, TextEditingController nNumController) {
    return sharedUnderLineInput(context,
            controller: nNumController,
            labelText: 'National number'.tr(context))
        .paddingB(context, 0.019);
  }

  Widget _buildRow3(
      BuildContext context, TextEditingController emailController) {
    return sharedUnderLineInput(context,
        controller: emailController,
        labelText: 'email'.tr(context),
        keyboardType: TextInputType.emailAddress);
  }

  Row _buildRow2(BuildContext context, TextEditingController fNameController,
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

  Row _buildRow1(BuildContext context, TextEditingController nameController,RegisterCubit cubit) {
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
  //   return Row(
  //     children: [
  //       Checkbox(
  //         shape: RoundedRectangleBorder(
  //             side: BorderSide(color: Recolor.mainColor, width: 1),
  //             borderRadius: BorderRadius.circular(5)),
  //         value: isAcceptTerms,
  //         onChanged: (value) {
  //           isAcceptTerms = value!;
  //         },
  //       ),
  //       RichText(
  //           text: TextSpan(children: [
  //         TextSpan(text: "I Accept".tr(context), style: taj12RegBlue()),
  //         TextSpan(
  //             text: "Privacy Policy".tr(context),
  //             style: taj12MedBlue(),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () {
  //                 navigateTo(context, const PrivacyPolicyScreen());
  //               }),
  //         TextSpan(text: "and".tr(context), style: taj11MedBlue()),
  //         TextSpan(
  //             text: "Terms of Service".tr(context),
  //             style: taj12MedBlue(),
  //             recognizer: TapGestureRecognizer()
  //               ..onTap = () => navigateTo(context, const ServiceTerms())),
  //       ]))
  //     ],
  //   );
  // }

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
