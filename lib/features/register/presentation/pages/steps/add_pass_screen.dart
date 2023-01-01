import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../constant/shared_function/navigator.dart';
import '../../../../../constant/shared_widgets/shard_elevated_button.dart';
import 'fill_data_screen.dart';

class AddPasswordScreen extends StatelessWidget {
  String phoneNumber;

  AddPasswordScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    var passController = TextEditingController();
    var rePassController = TextEditingController();
    return Scaffold(
      appBar: sharedAppBar(context),
      body: Center(
        child: Column(
          children: [
            _buildTopTexts(context),
            _buildInputPassField(context, passController, rePassController),
            _buildButton(context)
          ],
        ),
      ),
    );
  }

  Column _buildInputPassField(
      BuildContext context,
      TextEditingController passController,
      TextEditingController rePassController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        sharedCardInput(context,
                controller: passController,
                isPassword: true,
                hintText: "enterPass".tr(context),
                hintStyle: taj14MedGree(),
                keyboardType: TextInputType.visiblePassword,
                suffix: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Recolor.rowColor,
                    )))
            .roundWidget(
                width: .9.widthX(context), height: 0.070.heightX(context))
            .cardAll(
                elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
            .paddingB(context, 0.02),
        sharedCardInput(context,
                controller: rePassController,
                isPassword: true,
                hintText: "erEnterPass".tr(context),
                hintStyle: taj14MedGree(),
                keyboardType: TextInputType.visiblePassword,
                suffix: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Recolor.rowColor,
                    )))
            .roundWidget(
                width: .9.widthX(context), height: 0.070.heightX(context))
            .cardAll(
                elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
            .paddingB(context, 0.04),
      ],
    );
  }

  Widget _buildTopTexts(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("add password".tr(context), style: taj12MedBlue()),
        Text("our end! Verified".tr(context), style: taj25BoldBlue2()),
        Text("Now enter and confirm the password".tr(context),
            style: taj14MedBlue()),
      ],
    ).paddingSV(context, 0.08);
  }

  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(
      txt: 'next'.tr(context),
      radius: 9,
      verticalPadding: 0.023.heightX(context),
      horizontalPadding: 0.15.widthX(context),
      textStyle: taj16BoldBlue().copyWith(color: Recolor.amberColor),
      onPressed: () {
        navigateTo(
            context, FillUserRegisterDataScreen(phoneNumber: phoneNumber));
      },
    );
  }
}
