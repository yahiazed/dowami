

import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/constant/extensions/round_extension.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:flutter/material.dart';

class ProfileCarWaitingAccept extends StatelessWidget {
  const ProfileCarWaitingAccept({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: sharedAppBar(context: context,onTap: (){navigateRem(context, const HomeScreen());}),
        body:
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Icon(Icons.alarm_on_outlined,color: Theme.of(context).canvasColor,size: .1.widthX(context)).paddingB(context, .03),
              Text('فى انتظار',style: eBold25(context),).paddingB(context,.02),


              Text('الموافقه على بيانات السياره',style: eBold25(context).copyWith(color: Theme.of(context).primaryColor),)

            ],
          ),
        )

    );
  }
}

