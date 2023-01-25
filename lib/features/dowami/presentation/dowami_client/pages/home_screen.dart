
import 'package:dowami/features/dowami/cubit/dowami_client_cubit.dart';
import 'package:dowami/features/dowami/cubit/dowami_client_state.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DowamiClientHome extends StatelessWidget {
   const DowamiClientHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<DowamiClientCubit,DowamiClientState>(
        listenWhen: (previous, current)=> current== EndChangePagePreviewState(),
        buildWhen: (previous, current) =>current== EndChangePagePreviewState() ,
        listener: (context, state) {},
        builder: (context,state) {
        return   Scaffold(

            body:DowamiClientCubit.get(context).pagePreview


          );

      }
    );


  }





}
