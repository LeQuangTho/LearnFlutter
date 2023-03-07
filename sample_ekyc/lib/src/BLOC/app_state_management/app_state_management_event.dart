part of 'app_state_management_bloc.dart';

@immutable
abstract class AppStateManagementEvent {}

/// Danh sách các sự kiện ảnh hưởng đến vòng đời của App

class AppStateManagementResumeEvent extends AppStateManagementEvent {}

class AppStateManagementRunAppEvent extends AppStateManagementEvent {}

class AppStateManagementTurnOnBackGroundEvent extends AppStateManagementEvent {}
