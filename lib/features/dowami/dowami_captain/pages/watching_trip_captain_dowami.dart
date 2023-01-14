import 'package:dowami/features/dowami/dowami_captain/cubit/dowami_captain_cubit.dart';
import 'package:dowami/features/dowami/dowami_captain/cubit/dowami_captain_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchingTripCaptainDowami extends StatelessWidget {

  const WatchingTripCaptainDowami({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<DowamiCaptainCubit,DowamiCaptainState>(
        listener: (context,state){},
        builder: (context,state) {
          return Scaffold();
        }
    );
  }
}
