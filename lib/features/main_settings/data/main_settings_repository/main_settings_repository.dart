

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:dowami/constant/strings/strings.dart';
import 'package:dowami/core/error_model.dart';
import 'package:dowami/core/errors/exceptions.dart';
import 'package:dowami/core/errors/failure.dart';
import 'package:dowami/features/main_settings/data/models/main_settings_model.dart';
import 'package:dowami/helpers/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class MainSettingsRepo {
  Future<Either<Failure, MainSettingsModel>> getMainSettings({required String lang});
  Future<String> getLanguageFromPrefs();
  Future<void> saveLanguageToPrefs({required String value});

}

class MainSettingsRepoImpel implements MainSettingsRepo {
  final DioHelper dio;


  MainSettingsRepoImpel({required this.dio,});

  @override
  Future<Either<Failure, MainSettingsModel>> getMainSettings({required String lang}) async {
    try {
      Response res = await dio.getData(url: mainSettingsUrl,lang: lang);
      debugPrint('1${res.data}');
      return Right(MainSettingsModel.fromMap(map: res.data['data']));
    }on DioError catch (e) {
      debugPrint(e.response.toString());
      return left(implementDioError(e));

    }
  }



  @override
  saveLanguageToPrefs({required String value})async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }


  @override
  Future<String> getLanguageFromPrefs()async{

    final prefs = await SharedPreferences.getInstance();
    var languagePref=prefs.getString('language');
    print('$languagePref=languagePref');
    if(languagePref==null){
      return  'ar';
    }
    else{
      return languagePref;
    }
  }


}








