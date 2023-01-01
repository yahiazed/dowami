import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../constant/shared_widgets/shard_elevated_button.dart';
import '../../../../constant/shared_widgets/shared_card_input.dart';
import '../../../../constant/shared_widgets/shared_flag_item.dart';
import '../../../register/presentation/pages/select_user_kind.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();
  String phoneCode = '+966';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Recolor.whiteColor,
      body: Center(
        child: Form(
          key: loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'welcome back'.tr(context),
                style: taj25BoldBlue(),
              ).paddingB(context, 0.03),
              sharedCardInput(context,
                      controller: phoneController,
                      hintText: 'enterPhone'.tr(context),
                      suffix: buildFlag(cCode: phoneCode))
                  .roundWidget(
                      width: .9.widthX(context), height: 0.070.heightX(context))
                  .cardAll(
                      elevation: 6,
                      radius: 7,
                      shadowColor: const Color(0xffF6F6F6))
                  .paddingB(context, 0.02),
              sharedCardInput(context,
                      controller: passController,
                      isPassword: true,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: 'enterPass'.tr(context))
                  .roundWidget(
                      width: .9.widthX(context), height: 0.070.heightX(context))
                  .cardAll(elevation: 6, radius: 7)
                  .paddingB(context, 0.02),
              sharedElevatedButton(
                      onPressed: () {
                        if (loginFormKey.currentState!.validate()) {
                          print('validate');
                        }
                        ;
                        //  navigateRep(context, LogInScreen());
                      },
                      txt: "goon".tr(context),
                      color: Recolor.amberColor,
                      radius: 6,
                      textStyle: taj19BoldWhite(),
                      horizontalPadding: .2.widthX(context),
                      verticalPadding: .02.heightX(context))
                  .paddingT(context, 0.025)
                  .sizeDown(context, 0.01),
              TextButton(
                  onPressed: () {
                    navigateTo(context, SelectAccountKind());
                  },
                  child: Text(
                    'OrCreateNew'.tr(context),
                    style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: Recolor.mainColor,
                        decoration: TextDecoration.underline),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // CountryPickerDropdown buildFlag() {
  //   return CountryPickerDropdown(
  //     initialValue: 'SA',
  //     icon: Icon(Icons.keyboard_arrow_down_rounded),
  //     itemBuilder: _buildDropdownItem,
  //     itemFilter: (c) =>
  //         ['SA', 'AE', 'EG', 'OM', 'KW', 'QA'].contains(c.isoCode),
  //     priorityList: [
  //       CountryPickerUtils.getCountryByIsoCode('SA'),
  //       CountryPickerUtils.getCountryByIsoCode('AE'),
  //     ],
  //     sortComparator: (Country a, Country b) => a.isoCode.compareTo(b.isoCode),
  //     onValuePicked: (Country country) {
  //       print("${country.name}");
  //     },
  //   );
  // }

  // Widget _buildDropdownItem(Country country) => Container(
  //       child: Row(
  //         children: <Widget>[
  //           CountryPickerUtils.getDefaultFlagImage(country),
  //           Text("+${country.phoneCode}"),
  //         ],
  //       ),
  //     );
}
