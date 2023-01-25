import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/forget_password/cubit/forget_pass_cubit.dart';
import 'package:dowami/features/forget_password/repositories/forget_pass_repository.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/login/data/repositories/login_repository.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/main_settings/data/main_settings_repository/main_settings_repository.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/profile/cubit/profile_cubit.dart';
import 'package:dowami/features/profile/data/repositories/profile_repository.dart';
import 'package:dowami/features/register/data/repositories/register_repository.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:get_it/get_it.dart';

import 'features/dowami/cubit/dowami_captain_cubit.dart';
import 'features/dowami/data/repositories/dowami_captain_repository.dart';
import 'features/dowami/cubit/dowami_client_cubit.dart';
import 'features/dowami/data/repositories/dowami_client_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RegisterCubit(repo: sl()));
  sl.registerFactory(() => LoginCubit(repo: sl()));
  sl.registerFactory(() => DowamiClientCubit(repo: sl()));
  sl.registerFactory(() => DowamiCaptainCubit(repo: sl()));
  sl.registerFactory(() => MainSettingsCubit(repo: sl()));
  sl.registerFactory(() => BottomBarCubit());
  sl.registerFactory(() => MapCubit());
  sl.registerFactory(() => ResetPassCubit(repo: sl()));
  sl.registerFactory(() => ProfileCubit(repo: sl()));





  sl.registerLazySingleton<RegisterRepo>(() => RegisterRepoImpel(dio: sl()));
  sl.registerLazySingleton<LoginRepo>(() => LoginRepoImpel(dio: sl()));
  sl.registerLazySingleton<DioHelper>(() => DioHelperImpl());
  sl.registerLazySingleton<DowamiCaptainRepo>(() => DowamiCaptainRepoImpel(dio: sl()));
  sl.registerLazySingleton<DowamiClientRepo>(() => DowamiClientRepoImpel(dio: sl()));
  sl.registerLazySingleton<MainSettingsRepo>(() => MainSettingsRepoImpel(dio: sl()));
  sl.registerLazySingleton<ForgetPassRepo>(() => ForgetPassRepoImpel(dio: sl()));
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepoImpel(dio: sl()));
}
