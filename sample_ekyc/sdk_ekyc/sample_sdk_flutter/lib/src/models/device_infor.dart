class DeviceInfor {
  // android
  String? fingerPrint;
  String? hardware;
  String? device;
  String? type;
  String? model;
  String? id;
  // ios
  String? name;
  String? iosModel;
  String? systemName;
  String? localizedModel;
  String? identifierForVendor;
  String? isPhysicalDevice;

  DeviceInfor(
      {newFingerPrint,
      newHardware,
      newDevice,
      newType,
      newModel,
      newId,
      newName,
      newIosModel,
      newSystemName,
      newLocalizedModel,
      newIdentifierForVendor,
      newIsPhysicalDevice}) {
    fingerPrint = newFingerPrint;
    hardware = newHardware;
    type = newType;
    model = newModel;
    device = newDevice;
    id = newId;
    name = newName;
    iosModel = newIosModel;
    systemName = newSystemName;
    localizedModel = newLocalizedModel;
    identifierForVendor = newIdentifierForVendor;
    isPhysicalDevice = newIsPhysicalDevice;
  }

  Map<String, String> toMap() {
    Map<String, String> map = Map();
    if (fingerPrint != null) map['fingerPrint'] = fingerPrint!;
    if (hardware != null) map['hardware'] = hardware!;
    if (type != null) map['type'] = type!;
    if (model != null) map['model'] = model!;
    if (device != null) map['device'] = device!;
    if (id != null) map['id'] = id!;

    // String? name;
    // String? iosModel;
    // String? systemName;
    // String? localizedModel;
    // String? identifierForVendor;
    // String? isPhysicalDevice;

    if (name != null) map['name'] = name!;
    if (systemName != null) map['systemName'] = systemName!;
    if (iosModel != null) map['iosModel'] = iosModel!;
    if (localizedModel != null) map['localizedModel'] = localizedModel!;
    if (identifierForVendor != null)
      map['identifierForVendor'] = identifierForVendor!;
    if (isPhysicalDevice != null) map['isPhysicalDevice'] = isPhysicalDevice!;
    return map;
  }
}
