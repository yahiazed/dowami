import 'package:dowami/constant/shared_widgets/shared_appbar.dart';
import 'package:flutter/material.dart';

class DowamiClient extends StatelessWidget {
  const DowamiClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('dowami client')),
    );
  }

}
