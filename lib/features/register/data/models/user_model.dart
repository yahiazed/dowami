import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class UserModel extends Equatable{

 final String? firstName;
 final String? fatherName;
 final String? nickName;
 final String? nationalId;
 final  String? birthDate;
 final String? city;
 final String? area;
 final String? district;
 final String? gender;
 final String? userType;
 final String? iBAN;
 final String? avatar;

 final int? id;
 final String? lat;
 final String? long;
 final String? mobile;
 final String? publish;

  const UserModel(
      {this.firstName,
      this.fatherName,
      this.nickName,
      this.nationalId,
      this.birthDate,
      this.city,
      this.area,
      this.district,
      this.gender,
      this.id,
      this.userType,
      this.iBAN,
      this.lat,
      this.long,
      this.mobile,
      this.avatar,
      this.publish,

      });

 Map<String, dynamic> toMap({required UserModel userModel}){

   return
     {
       'first_name':userModel.firstName,
       'father_name':userModel.fatherName,
       'nick_name':userModel.nickName,
       'national_id':userModel.nationalId,
       'birth_date':userModel.birthDate,
       'city':userModel.city,
       'area':userModel.area,
       'district':userModel.district,
       'gender':userModel.gender,
       'id':userModel.id,
       'type':userModel.userType,
       'iban':userModel.iBAN,
       'lat':userModel.lat,
       'long':userModel.long,
       'mobile':userModel.mobile,
       'avatar':userModel.avatar,
       'publish':userModel.publish,




     };
 }

 factory UserModel.fromMap(Map<String, dynamic> map){
   return
     UserModel(
       firstName :map['first_name'],
       fatherName :map['father_name'],
       nickName :map['nick_name'],
       nationalId :map['national_id'],
       birthDate:map['birth_date'],
       city :map['city'],
       area:map['area'],
       district :map['district'],
       gender :map['gender'],
       id :map['id'],
       userType :map['type'],
       iBAN :map['iban'],
       lat :map['lat'],
       long :map['long'],
       mobile:map['mobile'],
       avatar:map['avatar'],
       publish:map['publish'],


     )

     ;
 }


 String toJson(UserModel userModel) => json.encode(toMap(userModel:userModel));

 factory UserModel.fromJson(String source) => UserModel.fromMap( json.decode(source));






  @override
  List<Object?> get props => [firstName,fatherName,nickName,nationalId,birthDate,city,area,district,gender,id];
}