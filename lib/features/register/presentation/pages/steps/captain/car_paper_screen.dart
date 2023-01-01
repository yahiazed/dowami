import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/steps/register_final_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constant/shared_function/navigator.dart';
import '../../../../../../constant/shared_widgets/shared_accept_terms.dart';
import '../../../../../../constant/text_style/text_style.dart';
import '../../../../../terms/presentation/pages/privacy_policy_screen.dart';
import '../../../../../terms/presentation/pages/terms_screen.dart';

class RegisterCarPaperScreen extends StatelessWidget {
  final bool isRent;
  const RegisterCarPaperScreen({super.key, required this.isRent});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: sharedAppBar(context),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTopTextColumn(context),
              _buildUploadCarImageInkwell(
                  onTap: () {},
                  context: context,
                  hint: "IdCardCopy",
                  color: Recolor.onlineColor),
              _buildUploadCarImageInkwell(
                  onTap: () {},
                  context: context,
                  hint: "DriverLicense",
                  color: Recolor.amberColor),
              if (!isRent)
                _buildUploadCarImageInkwell(
                    onTap: () {},
                    context: context,
                    hint: "car registration form",
                    color: Recolor.txtRefuseColor),
              if (isRent)
                _buildUploadCarImageInkwell(
                    onTap: () {},
                    context: context,
                    hint: "A copy of the authorization",
                    color: Recolor.txtRefuseColor),
              _buildTotalRowOperationColor(context),
              buildAcceptsTermsRow(
                  RegisterCubit.get(context).isAcceptTerms, context),
              sharedElevatedButton(
                  onPressed: () {
                    navigateTo(context, RegisterFinalScreen());
                  },
                  txt: 'Confirm'.tr(context),
                  textStyle: taj16BoldWhite(),
                  radius: 9,
                  verticalPadding: 0.025.heightX(context),
                  horizontalPadding: 0.2.widthX(context),
                  color: Recolor.amberColor)
            ],
          ),
        );
      },
    );
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
        Text(txt.tr(context), style: taj12RegGree())
      ],
    );
  }

  CircleAvatar _buildDotCircleColor(Color color) {
    return CircleAvatar(radius: 10, backgroundColor: color);
  }

  InkWell _buildUploadCarImageInkwell(
      {required BuildContext context,
      void Function()? onTap,
      required String hint,
      required Color color}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding:
                EdgeInsetsDirectional.only(start: 0.90.widthX(context) * .1),
            child: Text(hint.tr(context), style: taj12RegGree()),
          ),
          Container(
            width: 0.90.widthX(context) * .1,
            height: .08.heightX(context),
            color: color,
          )
        ],
      )
          .roundWidget(
              width: 0.90.widthX(context), height: 0.08.heightX(context))
          .cardAll(cardColor: Recolor.whiteColor, elevation: 9, radius: 9)
          .paddingB(context, 0.02),
    );
  }

  Widget _buildTopTextColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("To Finish".tr(context), style: taj12MedBlue()),
        Text("Attach Paper".tr(context), style: taj25BoldBlue()),
        Text("BeSurePaper".tr(context),
            textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
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
