import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/constant/shared_widgets/toast.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/steps/add_pass_screen.dart';
import 'package:dowami/features/register/presentation/pages/steps/fill_data_screen.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constant/shared_function/navigator.dart';
import '../../../../../constant/text_style/text_style.dart';

class RegisterVerifyCodeScreen extends StatelessWidget {
 // String phoneNumber;
  var digitController1 = TextEditingController();
  var digitController2 = TextEditingController();
  var digitController3 = TextEditingController();
  var digitController4 = TextEditingController();
  var digitController5 = TextEditingController();
  var digitController6 = TextEditingController();
  final nod1 = FocusNode();
  final nod2 = FocusNode();
  final nod3 = FocusNode();
  final nod4 = FocusNode();
  final nod5 = FocusNode();
  final nod6 = FocusNode();
  RegisterVerifyCodeScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is SuccessCodeState) {
          navigateRep(context, AddPasswordScreen());}
        if (state is ErrorCodeState) {
          showErrorToast(message:state.errorMsg);
        }
        if (state is ErrorResendOtpState) {
          showErrorToast(message: state.errorMsg);

        }
        if (state is SuccessResendOtpState) {
          RegisterCubit.get(context).smsCode = state.smsCode;
          print('smscode======================${state.smsCode}');

        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: sharedAppBar(context: context,onTap: (){Navigator.pop(context);}),
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _build4LineText(context,RegisterCubit.get(context)),
                Directionality(
                  textDirection: Localizations.localeOf(context).languageCode=='en' ? TextDirection.rtl :TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPinCodeItem(context, digitController1, nod1),
                      _buildPinCodeItem(context, digitController2, nod2),
                      _buildPinCodeItem(context, digitController3, nod3),
                      _buildPinCodeItem(context, digitController4, nod4),
                      _buildPinCodeItem(context, digitController5, nod5),
                      _buildPinCodeItem(context, digitController6, nod6),
                    ],
                  ).paddingB(context, 0.05),
                ),
                _buildResendTextButton(context, state),
                _buildCodeSms(context),
                _buildButton(context)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCodeSms(context){
    return Text(RegisterCubit.get(context).smsCode.toString()
    ).paddingSV(context, 0.01);

  }

  Widget _buildResendTextButton(context, state) {
    var cubit = RegisterCubit.get(context);
    return InkWell(
      onTap: state is TimeOutSendSmsCodeState
          ? () {
              cubit.resendOtp(phoneNum: cubit.phoneCode + cubit.phoneNumber, lang: MainSettingsCubit.get(context).languageCode);
            }
          : null,
      child: Center(
        child: RichText(
            text: TextSpan(children: [
          TextSpan(text: '?????? ?????????? ??????????',
              style: reg14(context).copyWith(decoration:state is TimeOutSendSmsCodeState?TextDecoration.underline:TextDecoration.none )
          ),
              state is TimeOutSendSmsCodeState
              ?const TextSpan():
              TextSpan(
            text: '${RegisterCubit.get(context).second} ??????????',
            style: reg14(context).copyWith(color: Theme.of(context).primaryColor,
                decoration: state is TimeOutSendSmsCodeState
                    ? TextDecoration.underline
                    : null),
          ),
        ])).paddingB(context, 0.05),
      ),
    );
  }

  Column _build4LineText(BuildContext context,RegisterCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Check Your Phone Number".tr(context), style: med12(context)),
        Text("Enter Verification Code".tr(context), style: eBold25(context)),
        Text('Enter the quad code sent to the number'.tr(context),
            style: reg14(context)),
        Text(cubit.phoneNumber, style: reg14(context)),
        _buildButtonEditPhoneNumber(context),
      ],
    );
  }

  TextButton _buildButtonEditPhoneNumber(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text('Is the number correct?'.tr(context),
              style:reg14(context).copyWith(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).primaryColor))
          .paddingB(context, 0.1),
    );
  }

  Widget _buildPinCodeItem(BuildContext context,
      TextEditingController digitController, FocusNode nod) {
    return Center(
      child: sharedCardInput(context,
              controller: digitController,
              hintText: '*',
              txtStyle: reg18Pop(),
              textAlign: TextAlign.center,
              focusNode: nod,
              hintStyle: reg18Pop(),
              onChanged: (p0) {
                if (p0.length == 1) {
                  FocusScope.of(context).previousFocus();
                } else if (nod == nod6) {
                  FocusScope.of(context).unfocus();
                } else {
                  FocusScope.of(context).nextFocus();
                }
              },
              inputFormatters: [LengthLimitingTextInputFormatter(1)],
              textInputAction:
                  nod == nod6 ? TextInputAction.previous : TextInputAction.done,
              validator: (p0) {
                if (p0!.isEmpty) {
                  return 'Empty';
                } else {
                  int.tryParse(p0);
                }
              },
              keyboardType: TextInputType.number)
          .roundWidget(
              width: 0.15.widthX(context), height: 0.07.heightX(context))
          .cardAll(elevation: 6, radius: 6),
    );
  }

  Widget _buildButton(BuildContext context) {
    return sharedElevatedButton(
      context: context,
      txt: 'next'.tr(context),
      radius: 9,
      verticalPadding: 0.023.heightX(context),
      horizontalPadding: 0.15.widthX(context),
      textStyle:  bold16(context).copyWith(color: Theme.of(context).primaryColor),
      onPressed: () {
        String code = digitController6.text +
            digitController5.text +
            digitController4.text +
            digitController3.text +
            digitController2.text +
            digitController1.text;
        int cod = int.parse(code);
        RegisterCubit.get(context).verifyCode(code:cod, lang: MainSettingsCubit.get(context).languageCode);
      },
    );
  }
}
