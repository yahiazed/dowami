import 'dart:io';

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/register/data/models/required_doc_model.dart';
import 'package:dowami/features/register/data/models/user_doc_model.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/steps/register_final_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../../../constant/shared_function/navigator.dart';
import '../../../../../../constant/shared_widgets/shared_accept_terms.dart';
import '../../../../../../constant/text_style/text_style.dart';

class RegisterCarPaperScreen extends StatelessWidget {

    RegisterCarPaperScreen({super.key});
  var carDocsFormKey = GlobalKey<FormState>();


  List<TextEditingController>dateControllers=List.generate(10, (index) => TextEditingController());
  List<TextEditingController>idNumbersControllers=List.generate(10, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if(state is ErrorSendRequiredDocumentsState){
          showErrorToast(message: state.errorMsg);
        }

      },
      builder: (context, state) {
        var cubit=RegisterCubit.get(context);
        if(cubit.requiredDocuments.isEmpty){cubit.getRequiredDocs();}

        return Scaffold(
          appBar: sharedAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopTextColumn(context),
                Form(key: carDocsFormKey,
                  child: Column(
                    children: cubit.requiredDocuments.map((e) =>
                        _buildDocItem(context: context,cubit: cubit,index: cubit.requiredDocuments.indexOf(e),requiredDocModel: e),
                    ).toList()


                    ,
                  ),
                ),



               // cubit.isRent?
               // _buildAuthLicenseInkwell(context: context,cubit:cubit)
               // : _buildCarLicenseInkwell(context: context,cubit:cubit),


                buildAcceptsTermsRow(
                    RegisterCubit.get(context).isAcceptTerms, context),
                sharedElevatedButton(
                    onPressed: () async{
                      await onConfirmButton(context: context,cubit: RegisterCubit.get(context));
                    },
                    txt: 'Confirm'.tr(context),
                    textStyle: taj16BoldWhite(),
                    radius: 9,
                    verticalPadding: 0.025.heightX(context),
                    horizontalPadding: 0.2.widthX(context),
                    color: Recolor.amberColor)
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
        Text("To Finish".tr(context), style: taj12MedBlue()),
        Text("Attach Paper".tr(context), style: taj25BoldBlue()),
        Text("BeSurePaper".tr(context), textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
  }


    InkWell _buildDocItem({required BuildContext context,required RegisterCubit cubit,required int index,required RequiredDocModel requiredDocModel}) {
      return InkWell(
        onTap: ()async{
          await cubit.pickDocImageFromGallery(index: index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                  EdgeInsetsDirectional.only(start: 0.90.widthX(context) * .1,),
                  child: Text(requiredDocModel.name!, style: taj17ExtraBoldBlue()),
                ),
                Container(
                  width: 0.90.widthX(context) * .2,
                  height: .05.heightX(context),

                  decoration:
                  cubit.docImagesFiles[index]==null||cubit.docImagesFiles[index]==File('')||cubit.docImagesFiles[index]!.path.isEmpty
                      ? const BoxDecoration()
                      :BoxDecoration(
                      image:  DecorationImage(image:   FileImage(cubit.docImagesFiles[index]!),fit: BoxFit.contain,)
                  ),
                  child:  cubit.docImagesFiles[index]==null||cubit.docImagesFiles[index]==File('')||cubit.docImagesFiles[index]!.path.isEmpty
                      ?Icon(Icons.camera_alt_outlined,color: Recolor.txtGreyColor,)
                  :const SizedBox(),
                ),

              ],
            ).paddingSV(context, .01
            ),

              Column(
                children:
                [
                 if(requiredDocModel.hasExpiredDate=='1') sharedCardInput(context,
                      controller: dateControllers[index],
                    hintText: 'expired date',
                    keyboardType: TextInputType.none,
                   txtStyle:taj12RegGree() ,

                   validator: (v){if(v!.isEmpty){return 'enter expired date ';}return null;},
                      onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(Duration(days: 15)),
                        firstDate: DateTime.now().add(Duration(days: 15)),
                         lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                      DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate); //formatted date output using intl package =>  2021-03-16

                      dateControllers[index].text = formattedDate;
                      cubit.onSelectExpiredDate(formattedDate);

                    } else {debugPrint('null in date');}
                  },
                 ).paddingSH(context, 0.02).roundWidget(
                     color: Recolor.whiteColor,
                     borderColor: Recolor.txtGreyColor,
                     borderWidth: 1,
                     radius: 5
                 ).paddingS(context, .01, .01),







                  if(requiredDocModel.hasIdNumber=='1') sharedUnderLineInput(context,
                      controller: idNumbersControllers[index],
                      labelText: 'car id number',

                      labelStyle:taj12RegGree() ,
                      validator: (v){if(v!.isEmpty){return 'enter car id number ';}return null;}
                  ).paddingSH(context, 0.02).roundWidget(
                    color: Recolor.whiteColor,
                    borderColor: Recolor.txtGreyColor,
                    borderWidth: 1,
                    radius: 5
                  ).paddingS(context, .01, .01),


                ]

            ).paddingB(context, .02),


          ],
        )
            .roundWidget(
            width: 0.90.widthX(context), //height: 0.08.heightX(context)
        )
            .cardAll(cardColor: Recolor.whiteColor, elevation: 9, radius: 9)
            .paddingB(context, 0.02),
      );
    }
    onConfirmButton({required RegisterCubit cubit ,required BuildContext context})async{

      if(!RegisterCubit.get(context).isAcceptTerms){
        showErrorToast(message:'terms');
        return;

      }
      if (  !carDocsFormKey.currentState!.validate()){print('here');return ;}
        var requiredDocsList=cubit.requiredDocuments;

print(requiredDocsList);


  for(var requiredDoc in requiredDocsList){

    int index=requiredDocsList.indexOf(requiredDoc);
    if( cubit.docImagesPicked[index]==null||cubit.docImagesPicked[index]==XFile('')||
        cubit.docImagesPicked[index]!.path.isEmpty){
      showErrorToast(message: 'select all images');return;}

    var userDocModel=UserDocModel(
        userId: '4',
        docId: requiredDoc.id.toString(),
        expiredDate: dateControllers[index].text,
        idNumber:  idNumbersControllers[index].text
    );
    XFile? picked=cubit.docImagesPicked[index];
    await  cubit.sendDocuments(userDocModel: userDocModel, xFile: picked!);

  }




 navigateTo(context, RegisterFinalScreen());



    }







  Widget _buildTotalRowOperationColor(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRowOperationColorItem(
            context: context, txt: "confirmed", color: Recolor.onlineColor),
        _buildRowOperationColorItem(
            context: context, txt: "waiting", color: Recolor.amberColor),
        _buildRowOperationColorItem(
            context: context, txt: "refused", color: Recolor.txtRefuseColor),
      ],
    ).paddingT(context, 0.02);
  }

  Row _buildRowOperationColorItem({required BuildContext context, required String txt, required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDotCircleColor(color),
        const SizedBox(width: 5),
        Text(txt.tr(context), style: taj12RegGree())
      ],
    );
  }

  CircleAvatar _buildDotCircleColor(Color color) {
    return CircleAvatar(radius: 10, backgroundColor: color);
  }





  // Widget _buildAcceptsTermsRow(bool isAcceptTerms, BuildContext context) {
  //   return Row(
  //     // crossAxisAlignment: CrossAxisAlignment.center,
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Checkbox(
  //         shape: RoundedRectangleBorder(
  //             side: BorderSide(color: Recolor.mainColor, width: 1),
  //             borderRadius: BorderRadius.circular(5)),
  //         value: isAcceptTerms,
  //         onChanged: (value) {
  //           RegisterCubit.get(context).onChangedAcceptTerms(value);
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
  //   ).paddingSV(context, 0.02);
  // }
}
