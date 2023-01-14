import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/login/data/cubit/login_cubit.dart';
import 'package:dowami/features/login/data/repositories/repository.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/register/data/repositories/register_repository.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:get_it/get_it.dart';

import 'features/dowami/dowami_captain/cubit/dowami_captain_cubit.dart';
import 'features/dowami/dowami_captain/repositories/dowami_captain_repository.dart';
import 'features/dowami/dowami_client/cubit/dowami_client_cubit.dart';
import 'features/dowami/dowami_client/repositories/dowami_client_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RegisterCubit(repo: sl()));
  sl.registerFactory(() => LoginCubit(repo: sl()));
  sl.registerFactory(() => DowamiClientCubit(repo: sl()));
  sl.registerFactory(() => DowamiCaptainCubit(repo: sl()));
  sl.registerFactory(() => BottomBarCubit());
  sl.registerFactory(() => MapCubit());
  sl.registerLazySingleton<RegisterRepo>(() => RegisterRepoImpel(dio: sl()));
  sl.registerLazySingleton<LoginRepo>(() => LoginRepoImpel(dio: sl()));
  sl.registerLazySingleton<DioHelper>(() => DioHelperImpl());
  sl.registerLazySingleton<DowamiCaptainRepo>(() => DowamiCaptainRepoImpel(dio: sl()));
  sl.registerLazySingleton<DowamiClientRepo>(() => DowamiClientRepoImpel(dio: sl()));
}
