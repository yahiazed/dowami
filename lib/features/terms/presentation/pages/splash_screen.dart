import 'dart:async';

import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/shared_function/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../../register/presentation/pages/select_register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      navigateTo(context, SelectLog());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Recolor.amberColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            //color: Colors.white,
            child: Center(
              child: SvgPicture.asset(
                'assets/svg/Group9786.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
