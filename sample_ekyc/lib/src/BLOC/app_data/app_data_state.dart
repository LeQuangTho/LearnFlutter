part of 'app_data_bloc.dart';

@immutable
abstract class AppDataState {}

/// Quản lý data và context của App

class AppDataInitial extends AppDataState {}

class AppDataSetupInprogress extends AppDataState {}

class AppDataSetupSuccess extends AppDataState {}

class AppDataSetupFail extends AppDataState {}

class FirstLoadedSuccess extends AppDataState {}
