import 'dart:io';

import 'package:dowami/constant/extensions/file_extention.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
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

  final carDocsFormKey = GlobalKey<FormState>();

 /* List<TextEditingController> dateControllers =
      List.generate(10, (index) => TextEditingController());
  List<TextEditingController> idNumbersControllers =
      List.generate(10, (index) => TextEditingController());*/


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
     /* listenWhen: (previous, current) =>
          current is ErrorSendRequiredDocumentsState ||
          current is SuccessSendRequiredDocumentsState ||
          current is SuccessGetRequiredDocumentsState ||
          current is EndStartingPageState ||
          current is ErrorGetRequiredDocumentsState,
      buildWhen: (previous, current) =>
          current is ErrorSendRequiredDocumentsState ||
          current is SuccessSendRequiredDocumentsState ||
          current is SuccessGetRequiredDocumentsState ||
          current is ErrorGetRequiredDocumentsState,*/
      listener: (context, state) {
        if(state is EndStartingPageState){
          print('getting docs required');
          RegisterCubit.get(context).getRequiredDocs(lang: MainSettingsCubit.get(context).languageCode) ;
        }

        if (state is ErrorGetRequiredDocumentsState) {
          showErrorToast(message: state.errorMsg);
        }


        if (state is ErrorSendRequiredDocumentsState) {
          showErrorToast(message: state.errorMsg);
        }
        if (state is SuccessSendRequiredDocumentsState) {
        //  Future.delayed(Duration(seconds: 5)).then((value) => navigateTo(context, const RegisterFinalScreen()));

        }
        if(state is SuccessSendAllDocState){
          RegisterCubit.get(context).getStatusOfDocs(lang: MainSettingsCubit.get(context).languageCode);
        }

        if(state is SuccessGetAllDocStatusState){
          RegisterCubit.get(context).finishCarPaperPage=true;
        }
      },
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        if (cubit.requiredDocuments.isEmpty) {
          cubit.getRequiredDocs(
              lang: MainSettingsCubit.get(context).languageCode);
        }

        return Scaffold(
          appBar: sharedAppBar(context: context,onTap: (){navigateRem(context, HomeScreen());}),
          body: FutureBuilder<void>(
            future: cubit.onStartPage(state is RegisterInitial),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTopTextColumn(context),
                    Form(
                      key: carDocsFormKey,
                      child: Column(
                          children: cubit.requiredDocuments
                              .map(
                                (e) => _buildDocItem(
                                    index: cubit.requiredDocuments.indexOf(e),
                                    requiredDocModel: e,
                                  statusColor:cubit.docsStatusColors.length!= cubit.requiredDocuments.length
                                      ? Colors.white
                                      : cubit.docsStatusColors.elementAt(cubit.requiredDocuments.indexOf(e))

                                ),
                              )
                              .toList()),
                    ),
                    _buildTotalRowOperationColor(context),
                    _terms(),
                    cubit.loading?const Center(child: CircularProgressIndicator()):  cubit.finishCarPaperPage?_finishButton(context): _confirmButton(context),
                  ],
                ),
              );
            }
          ),

        );
      },
    );
  }

  Widget _finishButton(context){
    return
      sharedElevatedButton(
          onPressed: (){navigateRem(context, const RegisterFinalScreen());},
          txt: 'finish',
          context: context,
        color: Theme.of(context).canvasColor,
        textStyle: bold16(context).copyWith(color: Recolor.whiteColor),

    radius: 9,
    verticalPadding: 0.025.heightX(context),
    horizontalPadding: 0.2.widthX(context),

      )
      ;
  }
  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("To Finish".tr(context), style: med12(context)),
        Text("Attach Paper".tr(context), style: reg25(context)),
        Text("BeSurePaper".tr(context),
            textAlign: TextAlign.center, style: med11(context)),
      ],
    ).paddingS(context, 0.1, 0.06);
  }

  Widget _buildDocItem(
      {required int index, required RequiredDocModel requiredDocModel,required Color statusColor}) {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            current is SuccessPickImageState
                || current is ErrorPickImageState
                || current is EndSelectExpiredDateState
                || current is ErrorPickImageState
        ,
        buildWhen: (previous, current) =>
            current is SuccessPickImageState
                || current is ErrorPickImageState
                || current is ErrorPickImageState,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return Container(
            color: statusColor,
            child: InkWell(
              onTap: () async {
                await cubit.pickDocImageFromGallery(index: index);
              },
              child: Container(
                color: Recolor.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.only(
                            start: 0.90.widthX(context) * .1,
                          ),
                          child:
                              Text(requiredDocModel.name!, style: eBold16(context)),
                        ),
                        Container(
                          width: 0.90.widthX(context) * .2,
                          height: .05.heightX(context),
                          decoration: cubit.docImagesFiles[index] == null ||
                                  cubit.docImagesFiles[index] == File('') ||
                                  cubit.docImagesFiles[index]!.path.isEmpty
                              ? const BoxDecoration()
                              : BoxDecoration(
                                  image: DecorationImage(
                                  image: FileImage(cubit.docImagesFiles[index]!),
                                  fit: BoxFit.contain,
                                )),
                          child: cubit.docImagesFiles[index] == null ||
                                  cubit.docImagesFiles[index] == File('') ||
                                  cubit.docImagesFiles[index]!.path.isEmpty
                              ? Icon(
                                  Icons.camera_alt_outlined,
                                  color: Recolor.txtGreyColor,
                                )
                              : const SizedBox(),
                        ),

                      ],
                    ).paddingSV(context, .01),
                   if(cubit.docImagesFiles[index]!.path.isNotEmpty&&(getFileSize(cubit.docImagesFiles[index]!)>1023.0)) _errorMess(context)
                   /* Column(children: [
                      if (requiredDocModel.hasExpiredDate == '1')
                        sharedCardInput(
                          context,
                          controller:cubit. dateControllers[index],
                          hintText: 'expired date',
                          keyboardType: TextInputType.none,
                          txtStyle:
                              reg12(context).copyWith(color: Recolor.rowColor),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'enter expired date ';
                            }
                            return null;
                          },
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
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16

                              cubit. dateControllers[index].text = formattedDate;
                              cubit.onSelectExpiredDate(formattedDate);
                            } else {
                              debugPrint('null in date');
                            }
                          },
                        )
                            .paddingSH(context, 0.02)
                            .roundWidget(
                                color: Recolor.whiteColor,
                                borderColor: Recolor.txtGreyColor,
                                borderWidth: 1,
                                radius: 5)
                            .paddingS(context, .01, .01),
                      if (requiredDocModel.hasIdNumber == '1')
                        sharedUnderLineInput(context,
                                controller:cubit. idNumbersControllers[index],
                                labelText: 'car id number',
                                labelStyle: reg12(context).copyWith(
                                    color: Recolor.rowColor), validator: (v) {
                          if (v!.isEmpty) {
                            return 'enter car id number ';
                          }
                          return null;
                        })
                            .paddingSH(context, 0.02)
                            .roundWidget(
                                color: Recolor.whiteColor,
                                borderColor: Recolor.txtGreyColor,
                                borderWidth: 1,
                                radius: 5)
                            .paddingS(context, .01, .01),
                    ]).paddingB(context, .02),*/
                  ],
                )

                    ,
              ),
            ).paddingL(context, 0.075),
          ).cardAll(cardColor: Recolor.whiteColor, elevation: 9, radius: 9).paddingSH(context, .05).paddingB(context, .05) ;
        });
  }

  Widget _confirmButton(context) {
    return sharedElevatedButton(
        context: context,
        onPressed: () async {
          await onConfirmButtonFunc(context: context, cubit: RegisterCubit.get(context));

        },
        txt: 'Confirm'.tr(context),
        textStyle: eBold16(context).copyWith(color: Recolor.whiteColor),
        radius: 9,
        verticalPadding: 0.025.heightX(context),
        horizontalPadding: 0.2.widthX(context),
        color: Theme.of(context).primaryColor);
  }

Widget _errorMess(context){
    return
      Text("BeSurePaper".tr(context),style: reg12(context).copyWith(color: Recolor.redColor),)
      ;
}
  onConfirmButtonFunc({required RegisterCubit cubit, required BuildContext context}) async {




    if (!cubit.isAcceptTerms) {
      showErrorToast(message: 'terms');
      return;
    }
    if (!carDocsFormKey.currentState!.validate()) {return;}
    List<RequiredDocModel> requiredDocsList = cubit.requiredDocuments;
    cubit.loading=true;
    for(var file in  cubit.docImagesFiles){
      if(getFileSize(file!)>1023.0){ cubit.loading=false;return;}
    }

    print( RegisterCubit.get(context).userId.toString());

    for (var requiredDoc in requiredDocsList) {
      int index = requiredDocsList.indexOf(requiredDoc);
      if (cubit.docImagesPicked[index] == null ||
          cubit.docImagesPicked[index] == XFile('') ||
          cubit.docImagesPicked[index]!.path.isEmpty) {
        showErrorToast(message: 'selectAllImages'.tr(context));
        cubit.loading=false;
        return;
      }

      var userDocModel = UserDocModel(
          userId: RegisterCubit.get(context).userId.toString(),
          docId: requiredDoc.id.toString(),

      );

      XFile? picked = cubit.docImagesPicked[index];
       await cubit.sendDocuments(
          userDocModel: userDocModel,
          xFile: picked!,
          lang: MainSettingsCubit.get(context).languageCode);
       if(cubit.state is ErrorSendRequiredDocumentsState ){
         cubit.loading=false;
         return;
       }


    }

    cubit.loading=false;
    if(cubit.state is SuccessSendRequiredDocumentsState ){
      cubit.loading=true;
      cubit.successGetSendALLDocs();
      cubit.loading=false;
    }



  }




  Widget _terms() {
    return BlocConsumer<RegisterCubit, RegisterState>(
        listenWhen: (previous, current) =>
            current is EndChangeAcceptTermsState,
        buildWhen: (previous, current) => current is EndChangeAcceptTermsState,
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = RegisterCubit.get(context);
          return buildAcceptsTermsRow(cubit.isAcceptTerms, context);
        });
  }



  Widget _buildTotalRowOperationColor(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildRowOperationColor(
            context: context, txt: "confirmed", color: Recolor.onlineColor),
        _buildRowOperationColor(
            context: context, txt: "waiting", color: Recolor.amberColor),
        _buildRowOperationColor(
            context: context, txt: "refused", color: Recolor.txtRefuseColor),
      ],
    ).paddingT(context, 0.02);
  }

  Row _buildRowOperationColor(
      {required BuildContext context,
        required String txt,
        required Color color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDotCircleColor(color),
        const SizedBox(width: 5),
        Text(txt.tr(context), style: reg12(context).copyWith(color: Recolor.txtGreyColor))
      ],
    );
  }

  CircleAvatar _buildDotCircleColor(Color color) {
    return CircleAvatar(radius: 10, backgroundColor: color);
  }
}
