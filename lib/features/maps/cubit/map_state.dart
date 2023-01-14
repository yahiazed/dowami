import 'package:equatable/equatable.dart';

abstract class MapState extends Equatable{
  const MapState();
  @override
  List<Object> get props => [];


}

class MapInitial extends MapState {}

 class StartChange extends MapState{}
 class EndChange extends MapState{}
