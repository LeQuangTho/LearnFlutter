part of 'user_remote_bloc.dart';

abstract class UserRemoteEvent {}

class UserRemoteGetUserDataEvent extends UserRemoteEvent {}

class UserRemoteGetPDFEvent extends UserRemoteEvent {
  final String PDFLink;
  UserRemoteGetPDFEvent({
    required this.PDFLink,
  });
}

class UserRemoteGetPDFeFormEvent extends UserRemoteEvent {
  final String PDFLink;
  UserRemoteGetPDFeFormEvent({
    required this.PDFLink,
  });
}

class UserRemoteGetPDFeFormCTSEvent extends UserRemoteEvent {
  final String PDFLink;
  UserRemoteGetPDFeFormCTSEvent({
    required this.PDFLink,
  });
}

class UserRemoteCleanDataEvent extends UserRemoteEvent {}

class UserRemoteGetListDeviceEvent extends UserRemoteEvent {}

class UserRemoteGetListNotificationEvent extends UserRemoteEvent {}

class UserRemoteGetCancelDeviceEvent extends UserRemoteEvent {
  final String deviceId;
  UserRemoteGetCancelDeviceEvent({required this.deviceId});
}

class UserRemoteReadNotificationEvent extends UserRemoteEvent {
  final String notificationId;
  UserRemoteReadNotificationEvent({required this.notificationId});
}

class UserRemoteGetDetailContractsEvent extends UserRemoteEvent {
  final String idDocument;
  UserRemoteGetDetailContractsEvent({required this.idDocument});
}

class UserRemoteGetListContractsEvent extends UserRemoteEvent {
  final int type;
  final int pageSize;
  final int pageNumber;
  UserRemoteGetListContractsEvent(
      {required this.type, required this.pageSize, required this.pageNumber});
}

class UserRemoteGetListStatusContractEvent extends UserRemoteEvent {
  UserRemoteGetListStatusContractEvent();
}

class UserRemoteGetListDigitalCertificateEvent extends UserRemoteEvent {
  final bool? status;
  UserRemoteGetListDigitalCertificateEvent({this.status});
}

class UserRemoteGetEContractDetailsEvent extends UserRemoteEvent {
  final String eContractDocumentCode;
  UserRemoteGetEContractDetailsEvent({
    required this.eContractDocumentCode,
  });
}

class UserRemoteSaveBase64Event extends UserRemoteEvent {
  final String signatureBase64;
  UserRemoteSaveBase64Event(
    this.signatureBase64,
  );
}

class UserRemoteRequestSigningEvent extends UserRemoteEvent {}

class UserRemoteSigningEFormEvent extends UserRemoteEvent {
  UserRemoteSigningEFormEvent();
}

class UserRemoteConfirmSigningEvent extends UserRemoteEvent {
  bool signType;
  String idCts;
  UserRemoteConfirmSigningEvent(this.signType, this.idCts);
}

class UserRemoteRefuseSignEvent extends UserRemoteEvent {
  final String documentId;
  final String rejectReason;
  UserRemoteRefuseSignEvent({
    required this.documentId,
    required this.rejectReason,
  });
}

class UserRemoteUpdateProfileEvent extends UserRemoteEvent {
  final UserResponseDataEntry userInfo;
  UserRemoteUpdateProfileEvent({
    required this.userInfo,
  });
}

class UserRemoteGetDetailCTSEvent extends UserRemoteEvent {
  final String? idCTS;
  UserRemoteGetDetailCTSEvent({required this.idCTS});
}

class UserRemoteCheckSignatureEvent extends UserRemoteEvent {
  final String? idDoc;
  UserRemoteCheckSignatureEvent({required this.idDoc});
}
