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

 final int? userId;

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
      this.userId,

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
       'user_id':userModel.userId,




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
       userId :map['user_id'],


     )

     ;
 }








  @override
  List<Object?> get props => [firstName,fatherName,nickName,nationalId,birthDate,city,area,district,gender,userId];
}