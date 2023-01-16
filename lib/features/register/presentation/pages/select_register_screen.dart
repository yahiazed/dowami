import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/register/presentation/pages/select_user_kind.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../constant/strings/strings.dart';
import '../../../../constant/text_style/text_style.dart';
import '../../../login/presentation/pages/login_screen1.dart';

class SelectLog extends StatelessWidget {
  const SelectLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(logo).sizeDown(context, 0.06),
            Text('Welcome'.tr(context), style: taj14Blue()).paddingB(context, 0.03),
            Text('BeReady'.tr(context), style: taj19BoldBlue()).paddingB(context, 0.03),
            sharedElevatedButton(
                    onPressed: () {
                      navigateTo(context, LogInScreen1());
                    },
                    txt: "I Have an Account".tr(context),
                    color: Recolor.amberColor,
                    radius: 6,
                    textStyle: taj19BoldWhite(),
                    horizontalPadding: .1.widthX(context),
                    verticalPadding: .02.heightX(context))
                // .roundWidget(
                //     width: .50.widthX(context), height: .07.heightX(context))
                .paddingB(context, .03),
            sharedElevatedButton(
                onPressed: () {
                  navigateTo(context, const SelectAccountKind());
                },
                txt: "Create Account".tr(context),
                radius: 6,
                textStyle: taj19BoldWhite(),
                horizontalPadding: .1.widthX(context),
                verticalPadding: .02.heightX(context)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await LoginCubit.get(context). getDataFromPrefs();

        },
      ),
    );
  }
}
