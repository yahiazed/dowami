import 'dart:convert';

import 'package:equatable/equatable.dart';

class MainSettingsModel extends Equatable {
  final String? name;
  final String? mobile;
  final String? email;
  final String? currency;
  final String? primaryColor;
  final String? secondColor;
  final String? logo;
  final String? splashScreen;

  const MainSettingsModel(
      {this.name,
      this.mobile,
      this.email,
      this.currency,
      this.primaryColor,
      this.secondColor,
      this.logo,
      this.splashScreen,
      });


  factory MainSettingsModel.fromMap({required Map<String,dynamic>map}){
    return MainSettingsModel(
      name:map['name'],
      mobile:map['mobile'],
      email:map['email'],
      currency:map['currency'],
      primaryColor:map['primary_color'],
      secondColor:map['secondary_color'],
      logo:map['logo'],
      splashScreen:map['splash_screen'],



    );
  }

  Map<String,dynamic>toMap(){

    return {
      'name':name,
      'mobile':mobile,
      'email':email,
      'currency':currency,
      'primary_color':primaryColor,
      'secondary_color':secondColor,
      'logo':logo,
      'splash_screen':splashScreen,


    };
  }

  String toJson(MainSettingsModel mainSettingsModel) => json.encode(toMap());

  factory MainSettingsModel.fromJson(String source) => MainSettingsModel.fromMap(map: json.decode(source));

  @override
  List<Object?> get props => [name,];
}
