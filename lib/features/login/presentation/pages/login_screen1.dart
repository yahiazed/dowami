
import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/login/presentation/pages/login_screen2.dart';
import 'package:dowami/features/register/presentation/pages/select_register_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../../constant/shared_widgets/shard_elevated_button.dart';
import '../../../../constant/shared_widgets/shared_card_input.dart';
import '../../../../constant/shared_widgets/shared_flag_item.dart';
import '../../../register/presentation/pages/select_user_kind.dart';

class LogInScreen1 extends StatelessWidget {
  LogInScreen1({super.key});
  var phoneController = TextEditingController();
  var passController = TextEditingController();
  var loginFormKey = GlobalKey<FormState>();
  String phoneCode = '+966';

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is ErrorSendOtpLoginState) {
            showErrorToast(message: state.errorMsg);

          }
          if (state is SuccessSendOtpLoginState) {
            LoginCubit.get(context).smsCode = state.smsCode;
            print('smscode======================${state.smsCode}');
            navigateTo(context, LoginScreen2());
          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
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
                  _buildPhoneInput(context),


                  _buildButton( context),

                  TextButton(
                      onPressed: () {
                        navigateTo(context, SelectLog());
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
    );
  }
  Widget _buildPhoneInput(BuildContext context) {
    return sharedCardInput(context,
        controller: phoneController,
        hintText: 'enterPhone'.tr(context),
        suffix: buildFlag(
          cCode: phoneCode,
          onTap: (p0) {
            phoneCode = p0.phoneCode;
          },
        ))
        .roundWidget(width: .9.widthX(context), height: 0.070.heightX(context))
        .cardAll(elevation: 12, radius: 7, shadowColor: const Color(0xffF6F6F6))
    // .paddingSH(context, 0.05)
        .paddingB(context, 0.04);
  }
  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(

      onPressed: () {
        if (!loginFormKey.currentState!.validate()) {showErrorToast(message: 'enter phone');}

        LoginCubit.get(context).phoneCode = phoneCode;
        LoginCubit.get(context).phoneNumber = phoneController.text;
        LoginCubit.get(context).sendOtp(phoneNum: //phoneCode +
            phoneController.text);

      },
        txt: "goon".tr(context),
        color: Recolor.amberColor,
        radius: 6,
        textStyle: taj19BoldWhite(),
        horizontalPadding: .2.widthX(context),
        verticalPadding: .02.heightX(context))
        .paddingT(context, 0.025)
        .sizeDown(context, 0.01)
    ;
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
