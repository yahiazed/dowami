import 'dart:convert';

import 'package:equatable/equatable.dart';


abstract class Address{}


class City extends  Equatable   with  Address{
  final int? id;
  final String? name;

  const City({
    this.id,
    this.name,
  });

  factory City.fromMap({required Map<String,dynamic>map}){
    return City(
      id:map['id'] ,
      name:map['name']
    );
  }
  toMap(){
    return
      {
        'id':id,
        'name':name
      }
      ;

  }

  String toJson() => json.encode(toMap());

  factory City.fromJson(String source) => City.fromMap(map:  json.decode(source));


  @override
  List<Object?> get props => [name];
}

class Area extends Equatable  with  Address{
  final int? id;
  final String? name;

  const Area({
    this.id,
    this.name,
  });

  factory Area.fromMap({required Map<String,dynamic>map}){
    return Area(
        id:map['id'] ,
        name:map['name']
    );
  }
  toMap(){
    return
      {
        'id':id,
        'name':name
      }
    ;

  }

  String toJson() => json.encode(toMap());

  factory Area.fromJson(String source) => Area.fromMap(map:  json.decode(source));


  @override
  List<Object?> get props => [name];
}
class District extends Equatable with  Address {
  final int? id;
  final String? name;

  const District({
    this.id,
    this.name,
  });

  factory District.fromMap({required Map<String,dynamic>map}){
    return District(
        id:map['id'] ,
        name:map['name']
    );
  }
  toMap(){
    return
      {
        'id':id,
        'name':name
      }
    ;

  }

  String toJson() => json.encode(toMap());

  factory District.fromJson(String source) => District.fromMap(map:  json.decode(source));


  @override
  List<Object?> get props => [name];
}

