import 'package:dowami/features/register/data/repositories/repository.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => RegisterCubit(repo: sl()));
  sl.registerLazySingleton<RegisterRepo>(() => RegisterRepoImpel(dio: sl()));
  sl.registerLazySingleton<DioHelper>(() => DioHelperImpl());
}
