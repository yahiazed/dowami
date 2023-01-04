import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/home/presentation/cubit/home_cubit.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:dowami/features/register/presentation/cubit/register_cubit.dart';
import 'package:dowami/features/terms/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dependency_injection.dart' as di;
import 'features/register/data/repositories/repository.dart';
import 'features/register/presentation/pages/steps/fill_data_screen.dart';
import 'features/register/presentation/pages/steps/get_location_dialog.dart';
import 'helpers/localization/app_localization.dart';
import 'features/register/presentation/pages/select_register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => di.sl<RegisterCubit>()),
          BlocProvider(create: (context) => HomeCubit()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Recolor.kMain,
              appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarBrightness: Brightness.light,
                      statusBarIconBrightness: Brightness.dark)),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  selectedLabelStyle: taj12RegBlue(),
                  unselectedLabelStyle: taj12RegGree())),
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (deviceLocale != null &&
                  deviceLocale.languageCode == locale.languageCode) {
                return deviceLocale;
              }
            }

            return supportedLocales.first;
          },

          home:
              //HomeScreen()
              SelectLog(),

            //FillUserRegisterDataScreen(phoneNumber: '',),
        ));
  }
}
