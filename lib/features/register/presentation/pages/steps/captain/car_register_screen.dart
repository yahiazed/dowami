import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shard_elevated_button.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/shared_widgets/shared_card_input.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../constant/text_style/text_style.dart';
import 'car_paper_screen.dart';

class CarRegisterScreen extends StatelessWidget {
  CarRegisterScreen({super.key});
  var manufactureController = TextEditingController();
  var vehicleNameController = TextEditingController();
  var yearOfReleaseController = TextEditingController();
  var plateNumberController = TextEditingController();
  var carRegisterFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = RegisterCubit.get(context);
        return Scaffold(
          appBar: sharedAppBar(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTopTextColumn(context),
                Form(
                  key: carRegisterFormKey,
                  child: Column(
                    children: [
                      sharedUnderLineInput(context,
                          controller: manufactureController,
                          labelText: 'Manufacture'.tr(context)),
                      sharedUnderLineInput(context,
                          controller: vehicleNameController,
                          labelText: 'Vehicle name'.tr(context)),
                      sharedUnderLineInput(context,
                          controller: yearOfReleaseController,
                          labelText: 'year of release'.tr(context)),
                      sharedUnderLineInput(context,
                          controller: plateNumberController,
                          labelText: 'Plate Number'.tr(context)),
                      _buildRowRentRadio(context, cubit),
                      _buildButtonAttach3CarPhoto(context),
                      _buildButtonNext(context),
                    ],
                  ).paddingSH(context, 0.03),
                )
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
        Text("Enter car".tr(context), style: taj25BoldBlue()),
        Text("desc Car".tr(context),
            textAlign: TextAlign.center, style: taj11MedBlue()),
      ],
    ).paddingS(context, 0.1, 0.06);
  }


  Widget _buildButtonNext(BuildContext context) {
    return sharedElevatedButton(
        onPressed: () {
          if (carRegisterFormKey.currentState!.validate()) {
            switch (RegisterCubit.get(context).isRent) {
              case true:
                navigateTo(context,const RegisterCarPaperScreen());
                break;
              case false:
                navigateTo(context,const RegisterCarPaperScreen());
                break;
            }
          }
        },
        txt: 'next'.tr(context),
        horizontalPadding: 0.18.widthX(context),
        verticalPadding: 0.025.heightX(context),
        radius: 9,
        textStyle: taj16BoldAmber());
  }

  Widget _buildButtonAttach3CarPhoto(BuildContext context) {
    return Column(
      children: [
        TextButton(
            onPressed: ()async {

             await BlocProvider.of<RegisterCubit>(context,listen: false).pickImageFromGallery(photoType: '');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: Recolor.mainColor,
                ),
                Text("Attach at least 3 photos, one of the inside".tr(context),
                    style: taj11MedBlue())
              ],
            )).paddingSV(context, 0.03),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: BlocProvider.of<RegisterCubit>(context,listen: false).carImagesFiles.map((e) =>
                Container(
                  width: 0.90.widthX(context) * .15,
                  height: .05.heightX(context),
                  decoration: BoxDecoration(
                    color: Recolor.txtGreyColor.withOpacity(.2),
                    image: DecorationImage(
                      image: FileImage(e),
                      fit: BoxFit.fill
                    )
                  ),
                ).paddingSH(context,.01)


            ).toList(),
          ),
        )
      ],
    ).paddingB(context, 0.05);
  }

  Widget _buildRowRentRadio(BuildContext context, RegisterCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Property Type'.tr(context), style: taj12RegGree()),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadio(cubit, false),
            Text("ownership".tr(context), style: taj12RegGree()),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRadio(cubit, true),
            Text("rent".tr(context), style: taj12RegGree()),
          ],
        ),
      ],
    ).paddingT(context, 0.025);
  }

  Radio<bool> _buildRadio(RegisterCubit cubit, bool value) {
    return Radio(
        fillColor: MaterialStatePropertyAll(Recolor.amberColor),
        value: value,
        groupValue: cubit.isRent,
        onChanged: (value) => cubit.onChangedRadioRent(value));
  }


}
