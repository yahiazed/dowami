import 'package:equatable/equatable.dart';

abstract class BottomBarState extends Equatable{
  const BottomBarState();

  @override
  List<Object> get props => [];

}

class BottomBarInitial extends BottomBarState{}

class StartChangeBottomNavIndexState extends BottomBarState {}

class EndChangeBottomNavIndexState extends BottomBarState {}


