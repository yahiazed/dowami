import 'package:dowami/constant/extensions/media_extension.dart';
import 'package:dowami/helpers/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../../constant/text_style/text_style.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Privacy Policy'.tr(context),
          style: eBold19(context),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'back'.tr(context),
                    style: reg14(context).copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  )
                ],
              ))
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future:
                Future.delayed(const Duration(milliseconds: 150)).then((value) {
              return rootBundle.loadString('assets/privacy_policy.md');
            }),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 0.85.heightX(context),
                  child: Markdown(
                    data: snapshot.data!,
                  ),
                );
              }
              return const Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
