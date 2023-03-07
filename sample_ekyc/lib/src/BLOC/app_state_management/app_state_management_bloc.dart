import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

import 'package:meta/meta.dart';

part 'app_state_management_event.dart';
part 'app_state_management_state.dart';

class AppStateManagementBloc
    extends Bloc<AppStateManagementEvent, AppStateManagementState> {
  AppStateManagementBloc() : super(AppStateManagementInitial()) {
    on<AppStateManagementRunAppEvent>(_onRunApp);
    on<AppStateManagementResumeEvent>(_handleResume);
    on<AppStateManagementTurnOnBackGroundEvent>(_handleBackground);
  }
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> connectivitySubscription;
  bool isNetworkConnected = true;

  void _onRunApp(
      AppStateManagementEvent event, Emitter<AppStateManagementState> emit) {
    _initConnectivity();
    connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    // Future.delayed(DELAY_1_S * 10, () async {
    //   await DeepLinkHelper.initUniUrls();
    // });
  }

  // MARK: PRIVATE METHODS

  Future<void> _initConnectivity() async {
    // Hàm kiểm tra kết nối, có thể có trường hợp ngoại lệ khi check platform nên phải dùng try catch
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        _handleNetworkConnected();
        break;
      case ConnectivityResult.mobile:
        _handleNetworkConnected();
        break;
      default:
        _handleConnectNetworkFail();
        break;
    }
  }

  void _handleNetworkConnected() {
    if (!isNetworkConnected) {}
    isNetworkConnected = true;
  }

  void _handleConnectNetworkFail() {
    if (isNetworkConnected) {
      isNetworkConnected = false;
    }
  }

  void _handleResume(
      AppStateManagementEvent event, Emitter<AppStateManagementState> emit) {}

  void _handleBackground(
      AppStateManagementEvent event, Emitter<AppStateManagementState> emit) {}
}
