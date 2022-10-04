import Flutter
import UIKit
import CoreBluetooth

public class SwiftNextBlePlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate, CBPeripheralManagerDelegate  {
   private var centralManager: CBCentralManager!
   private var peripheralManager: CBPeripheralManager!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "next_ble_method", binaryMessenger: registrar.messenger())
        let instance: SwiftNextBlePlugin = SwiftNextBlePlugin()
        FlutterEventChannel(name: "next_ble_status", binaryMessenger: registrar.messenger()).setStreamHandler(instance.statusStreamHandler)
        FlutterEventChannel(name: "next_ble_scan", binaryMessenger: registrar.messenger()).setStreamHandler(instance.scanStreamHandler)

        FlutterEventChannel(name: "next_ble_connected_device", binaryMessenger: registrar.messenger()).setStreamHandler(instance.connectedDeviceStreamHandler)
        FlutterEventChannel(name: "next_ble_char_update", binaryMessenger: registrar.messenger()).setStreamHandler(instance.characteristicValueUpdateStreamHandler)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == CBManagerState.poweredOn) {
            peripheral.startAdvertising([CBAdvertisementDataLocalNameKey: UIDevice.current.name])
        } else if (peripheral.state == CBManagerState.poweredOff) {

        }
    }
     public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralManagerDidUpdateState")
        switch central.state {
        case .poweredOff:
            print("Is Powered Off.")
        case .poweredOn:
            print("Is Powered On.")
            if (!peripheralManager.isAdvertising) {
                peripheralManager.startAdvertising([
                    CBAdvertisementDataLocalNameKey: UIDevice.current.name
                ])
            }
        case .unsupported:
            print("Is Unsupported.")
        case .unauthorized:
            print("Is Unauthorized.")
        case .unknown:
            print("Unknown")
        case .resetting:
            print("Resetting")
        @unknown default:
            print("Error")
        }
    }

    public override init() {
        super.init()
        print("init")
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

   private let controller = Controller()
    
    var statusStreamHandler: StreamHandler<Controller> {
         return StreamHandler(
             name: "status stream handler",
             context: context,
             onListen: { context, sink in
                 context.stateSink = sink
                 return nil
             },
             onCancel: {context in
                 context.stateSink = nil
                 return nil
             }
         )
     }

     var scanStreamHandler: StreamHandler<Controller> {
         return StreamHandler(
             name: "scan stream handler",
             context: context,
             onListen: { context, sink in
                 return context.startScanning(sink: sink)
             },
             onCancel: { context in
                 return context.stopScanning()
             }
         )
     }

     var connectedDeviceStreamHandler: StreamHandler<Controller> {
         return StreamHandler(
             name: "connected device stream handler",
             context: context,
             onListen: { context, sink in
                 context.connectedDeviceSink = sink
                 return nil
             },
             onCancel: { context in
                 context.connectedDeviceSink = nil
                 return nil
             }
         )
     }

     var characteristicValueUpdateStreamHandler: StreamHandler<Controller> {
         return StreamHandler(
             name: "characteristic value update stream handler",
             context: context,
             onListen: { context, sink in
                 context.characteristicValueUpdateSink = sink
                 context.messageQueue.forEach { msg in
                     sink.add(.success(msg))
                 }
                 context.messageQueue.removeAll()
                 return nil
             },
             onCancel: { context in
                 context.messageQueue.removeAll()
                 context.characteristicValueUpdateSink = nil
                 return nil
             }
         )
     }

     private let context = Controller()
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
              print(peripheral)
    }

     private let methodHandler = MethodHandler<Controller>([
         AnyPlatformMethod(NullaryPlatformMethod(name: "initialize") { name, context, completion in
             context.initialize(name: name, completion: completion)
         }),
         AnyPlatformMethod(NullaryPlatformMethod(name: "disposeClient") { name, context, completion in
             context.deinitialize(name: name, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "scanForDevices") { (name, context, args: ScanForDevicesRequest, completion) in
             context.scanForDevices(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "connectToDevice") { (name, context, args: ConnectToDeviceRequest, completion) in
             context.connectToDevice(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "disconnectFromDevice") { (name, context, args: ConnectToDeviceRequest, completion) in
             context.disconnectFromDevice(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "clearGattCache") { (name, context, args: ClearGattCacheRequest, completion) in
             let result = ClearGattCacheInfo.with {
                 $0.failure = GenericFailure.with {
                     $0.code = Int32(ClearGattCacheFailure.operationNotSupported.rawValue)
                     $0.message = "Operation is not supported on iOS"
                 }
             }
             completion(.success(result))
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "requestConnectionPriority") { (name, context, args: ChangeConnectionPriorityRequest, completion) in
             let result = ChangeConnectionPriorityInfo.with {
                 $0.failure = GenericFailure.with {
                     $0.code = Int32(RequestConnectionPriorityFailure.operationNotSupported.rawValue)
                     $0.message = "Operation is not supported on iOS"
                 }
             }
             completion(.success(result))
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "discoverServices") { (name, context, args: DiscoverServicesRequest, completion) in
             context.discoverServices(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "readNotifications") { (name, context, args: NotifyCharacteristicRequest, completion) in
             context.enableCharacteristicNotifications(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "stopNotifications") { (name, context, args: NotifyNoMoreCharacteristicRequest, completion) in
             context.disableCharacteristicNotifications(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "readCharacteristic") { (name, context, args: ReadCharacteristicRequest, completion) in
             context.readCharacteristic(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "writeCharacteristicWithResponse") { (name, context, args: WriteCharacteristicRequest, completion) in
             context.writeCharacteristicWithResponse(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "writeCharacteristicWithoutResponse") { (name, context, args: WriteCharacteristicRequest, completion) in
             context.writeCharacteristicWithoutResponse(name: name, args: args, completion: completion)
         }),
         AnyPlatformMethod(UnaryPlatformMethod(name: "negotiateMtuSize") { (name, context, args: NegotiateMtuRequest, completion) in
             context.reportMaximumWriteValueLength(name: name, args: args, completion: completion)
         }),
     ])

     public func handle(_ call: FlutterMethodCall, result completion: @escaping FlutterResult) {
         if(call.method == "getPlatformVersion") {
             completion("iOS " + UIDevice.current.systemVersion)
         } else {
             methodHandler.handle(in: context, call, completion: completion)
         }
     }
    
    
}
