import CoreBluetooth

final class PeripheralDelegate: NSObject, CBPeripheralDelegate {
    
    typealias ServicesDiscoveryHandler = (CBPeripheral, Error?) -> Void
    typealias CharacteristicsDiscoverHandler = (CBService, Error?) -> Void
    typealias CharacteristicNotificationStateUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueUpdateHandler = (CBCharacteristic, Error?) -> Void
    typealias CharacteristicValueWriteHandler = (CBCharacteristic, Error?) -> Void

    private let onServicesDiscovery: ServicesDiscoveryHandler
    private let onCharacteristicsDiscovery: CharacteristicsDiscoverHandler
    private let onCharacteristicNotificationStateUpdate: CharacteristicNotificationStateUpdateHandler
    private let onCharacteristicValueUpdate: CharacteristicValueUpdateHandler
    private let onCharacteristicValueWrite: CharacteristicValueWriteHandler

    private var _peripheralDelegate: CBPeripheralManager?
    
    init(
        onServicesDiscovery: @escaping ServicesDiscoveryHandler,
        onCharacteristicsDiscovery: @escaping CharacteristicsDiscoverHandler,
        onCharacteristicNotificationStateUpdate: @escaping CharacteristicNotificationStateUpdateHandler,
        onCharacteristicValueUpdate: @escaping CharacteristicValueUpdateHandler,
        onCharacteristicValueWrite: @escaping CharacteristicValueWriteHandler
    ) {
        self.onServicesDiscovery = onServicesDiscovery
        self.onCharacteristicsDiscovery = onCharacteristicsDiscovery
        self.onCharacteristicNotificationStateUpdate = onCharacteristicNotificationStateUpdate
        self.onCharacteristicValueUpdate = onCharacteristicValueUpdate
        self.onCharacteristicValueWrite = onCharacteristicValueWrite
        
        super.init()
//        self.initializeDelegate()
    }
    
//    func initializeDelegate() {
//        _peripheralDelegate = CBPeripheralManager(delegate: self, queue:nil)
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        onServicesDiscovery(peripheral, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        onCharacteristicsDiscovery(service, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicNotificationStateUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicValueUpdate(characteristic, error)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        onCharacteristicValueWrite(characteristic, error)
    }
    
    func startAdverting(state: CBManagerState) {
//        switch state {
//           case .poweredOff:
//               print("Is Powered Off.")
//           case .poweredOn:
//               print("Is Powered On.")
////            if ((_peripheralDelegate?.isAdvertising) != nil) {
////                _peripheralDelegate?.startAdvertising([
////                       CBAdvertisementDataLocalNameKey: "VIet String"
////                   ])
////               }
//           case .unsupported:
//               print("Is Unsupported.")
//           case .unauthorized:
//               print("Is Unauthorized.")
//           case .unknown:
//               print("Unknown")
//           case .resetting:
//               print("Resetting")
//           @unknown default:
//               print("Error")
//        }
//        if ((_peripheralDelegate?.isAdvertising) != nil) {
//            _peripheralDelegate?.startAdvertising([
//                   CBAdvertisementDataLocalNameKey: "VIet String"
//               ])
//           }
    }
}
