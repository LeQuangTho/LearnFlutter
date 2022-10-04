```

```

# next_ble

This is plugin support Bluetooth

## Setup Protoc Plugin

[README.md](protos/README.md)

*Notes:*

if run `protoc --dart_out=../lib/src/generated ./bledata.proto`

```protoc-gen-dart: program not found or is not executable
Please specify a program using absolute path or make sure the program is available in your PATH system variable
--dart_out: protoc-gen-dart: Plugin failed with status code 1.
```

1. run `dart pub global deactivate protoc_plugin`
2. run `dart pub global activate protoc_plugin`
3. run `export PATH="$PATH":"$HOME/.pub-cache/bin"`
4. Ok try again from step 6 in [README.md](protos/README.md)

---

## Add permissions for Bluetooth

We need to add the permission to use Bluetooth and access location:

### **Android**

In the **android/app/src/main/AndroidManifest.xml** let’s add:

```xml
    <!-- required for API 18 - 30 -->
    <uses-permission
        android:name="android.permission.BLUETOOTH"
        android:maxSdkVersion="30" />
    <uses-permission
        android:name="android.permission.BLUETOOTH_ADMIN"
        android:maxSdkVersion="30" />

    <!-- required for API 23 - 30 -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

    <!-- API 31+ -->
    <uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
    <uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
```

### **IOS**

In the **ios/Runner/Info.plist** let’s add:

```dtd
<dict>
    <key>NSBluetoothAlwaysUsageDescription</key>
    <string>Need BLE permission</string>
    <key>NSBluetoothPeripheralUsageDescription</key>
    <string>Need BLE permission</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>Need Location permission</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Need Location permission</string>
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>Need Location permission</string>
```

## Reference

### FlutterBlue API


|             | Android | iOS | Description                                        |
| ------------- | --------- | ----- | ---------------------------------------------------- |
| scan        | ✅      | ✅  | Starts a scan for Bluetooth Low Energy devices.    |
| state       | ✅      | ✅  | Stream of state changes for the Bluetooth Adapter. |
| isAvailable | ✅      | ✅  | Checks whether the device supports Bluetooth.      |
| isOn        | ✅      | ✅  | Checks if Bluetooth functionality is turned on.    |

### BluetoothDevice API

|                  | Android | iOS | Description                                                                                       |
| ------------------ | --------- | ----- | --------------------------------------------------------------------------------------------------- |
| connect          | ✅      | ✅  | Establishes a connection to the device.                                                           |
| disconnect       | ✅      | ✅  | Cancels an active or pending connection to the device.                                            |
| discoverServices | ✅      | ✅  | Discovers services offered by the remote device as well as their characteristics and descriptors. |
| services         | ✅      | ✅  | Gets a list of services. Requires that discoverServices() has completed.                          |
| state            | ✅      | ✅  | Stream of state changes for the Bluetooth Device.                                                 |
| mtu              | ✅      | ✅  | Stream of mtu size changes.                                                                       |
| requestMtu       | ✅      |     | Request to change the MTU for the device.                                                         |
| readRssi         | ✅      | ✅  | Read RSSI from a connected device.                                                                |

### BluetoothCharacteristic API

|                | Android | iOS | Description                                              |
| ---------------- | --------- | ----- | ---------------------------------------------------------- |
| read           | ✅      | ✅  | Retrieves the value of the characteristic.               |
| write          | ✅      | ✅  | Writes the value of the characteristic.                  |
| setNotifyValue | ✅      | ✅  | Sets notifications or indications on the characteristic. |
| value          | ✅      | ✅  | Stream of characteristic's value when changed.           |

### BluetoothDescriptor API

|       | Android | iOS | Description                            |
| ------- | --------- | ----- | ---------------------------------------- |
| read  | ✅      | ✅  | Retrieves the value of the descriptor. |
| write | ✅      | ✅  | Writes the value of the descriptor.    |

### Next BLE API

|                     | Android | iOS | Description                                                                                           |
| ------------------- | ------- | ----- | ------------------------------------------------------------------------------------------------------- |
| openSetting         | ✅      |     | Open the operating system bluetooth settings screen                                                   |
| getName             | ✅      |     | Get name bluetooth your device.                                                                       |
| setName             | ✅      |     | Change name bluetooth your device.                                                                    |
| requestDiscoverable | ✅      |     | Request use on Android with duration,<br />during that time otherdevices can<br /> detect your device |
| startGatt           | ✅      |     | Start Gatt Server                                                                                     |
| stopGatt            | ✅      |     | Stop Gatt Server                                                                                      |
| requestPermission   | ✅      |     |                                                                                       |
