import 'package:dowami/constant/extensions/color_extention.dart';
import 'package:dowami/constant/extensions/lat_lng_extension.dart';
import 'package:dowami/constant/shared_colors/shared_colors.dart';
import 'package:dowami/constant/text_style/text_style.dart';
import 'package:dowami/features/bottom_bar/cubit/bottom_bar_cubit.dart';
import 'package:dowami/features/forget_password/cubit/forget_pass_cubit.dart';
import 'package:dowami/features/forget_password/presentation/forget_pass_sent_otp.dart';
import 'package:dowami/features/home/cubit/home_cubit.dart';
import 'package:dowami/features/home/presentation/pages/home_screen.dart';
import 'package:dowami/features/login/cubit/login_cubit.dart';
import 'package:dowami/features/login/presentation/pages/login_screen1.dart';
import 'package:dowami/features/login/presentation/pages/login_screen2.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_cubit.dart';
import 'package:dowami/features/main_settings/cubit/main_settings_state.dart';
import 'package:dowami/features/maps/cubit/map_cubit.dart';
import 'package:dowami/features/register/cubit/register_cubit.dart';
import 'package:dowami/features/register/presentation/pages/steps/captain/car_paper_screen.dart';
import 'package:dowami/features/register/presentation/pages/steps/captain/car_register_screen.dart';
import 'package:dowami/features/register/presentation/pages/steps/fill_data_screen.dart';
import 'package:dowami/features/splash_screen/presentation/pages/splash_screen.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dependency_injection.dart' as di;
import 'features/dowami/cubit/dowami_captain_cubit.dart';
import 'features/dowami/cubit/dowami_client_cubit.dart';

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
          BlocProvider(create: (context) => di.sl<LoginCubit>()),
          BlocProvider(create: (context) => di.sl<DowamiCaptainCubit>()),
          BlocProvider(create: (context) => di.sl<DowamiClientCubit>()),
          BlocProvider(create: (context) => di.sl<MainSettingsCubit>()),
          BlocProvider(create: (context) => di.sl<ResetPassCubit>()),
          BlocProvider(create: (context) => BottomBarCubit()),
          BlocProvider(create: (context) => MapCubit()),
          BlocProvider(create: (context) => HomeCubit()),


        ],
        child: BlocConsumer<MainSettingsCubit,MainSettingsState>(
          buildWhen: (previous, current) =>current is SuccessGetSettingsState||current is EndGetLanguageState||current is EndChangeLanguageState ,
          listenWhen: (previous, current) =>current is SuccessGetSettingsState||current is EndGetLanguageState ||current is EndChangeLanguageState,
          listener: (context, state) {},
          builder: (context,state) {


            var cubit=MainSettingsCubit.get(context);
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primarySwatch: Recolor.kMain,
                  primaryColor:cubit.primaryColor==null? Recolor.amberColor:HexColor.fromHex(cubit.primaryColor!),
                  canvasColor:cubit.secondColor==null? Recolor.mainColor:HexColor.fromHex(cubit.secondColor!),
                  backgroundColor: Recolor.whiteColor,
                  scaffoldBackgroundColor: Recolor.whiteColor,




                  appBarTheme: const AppBarTheme(
                      systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarBrightness: Brightness.light,
                          statusBarIconBrightness: Brightness.dark)),
                  bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor:Recolor.whiteColor ,
                      selectedLabelStyle: reg12(context),
                      unselectedLabelStyle: reg12(context).copyWith(color: Recolor.rowColor))),





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
              /*localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (deviceLocale != null &&
                      deviceLocale.languageCode == locale.languageCode) {
                    return deviceLocale;
                  }
                }

                return supportedLocales.last;
              },*/
                locale: MainSettingsCubit.get(context).language??
                    const Locale('ar') ,

              home:

            //  CarRegisterScreen()
                 const SplashScreen()
              //SelectLog(),
               // ForgetPassSendOtp()


                 // HomeScreen()

             // LoginScreen2(),
             // LogInScreen1()
             // RegisterCarPaperScreen()
              // CarRegisterScreen()
               // RegisterCarPaperScreen()
                //FillUserRegisterDataScreen(),
                  // RegisterCarPaperScreen(),
             // SettingCaptainDowamiScreen()
            );
          }
        ));
  }
}
