part of 'app_state_management_bloc.dart';

@immutable
abstract class AppStateManagementState {}

/// Nơi quản lý toàn bộ trạng thái của App, như kết nối, vòng đời

class AppStateManagementInitial extends AppStateManagementState {}
