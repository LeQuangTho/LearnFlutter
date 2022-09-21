package com.example.bluetooth_cte

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.app.ActivityCompat.startActivityForResult
import androidx.core.content.ContextCompat.startActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Field
import java.lang.reflect.Method
import java.net.NetworkInterface
import java.util.*


class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(BluetoothCTEPlugin())
    }
}

class BluetoothCTEPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware,
    EventChannel.StreamHandler {
    private val TAG = "BluetoothCTEPlugin"
    private lateinit var channel: MethodChannel
    private var PLUGIN_NAME: String = "bluetooth_cte_plugin"
    private lateinit var activity: Activity
    private lateinit var activityContext: Context
    private var messenger: BinaryMessenger? = null

    // Permissions and request constants
    private val REQUEST_COARSE_LOCATION_PERMISSIONS = 1451
    private val REQUEST_ENABLE_BLUETOOTH = 1337
    private val REQUEST_DISCOVERABLE_BLUETOOTH = 2137

    // General Bluetooth
    private var bluetoothAdapter: BluetoothAdapter? = null


    private var discoverySink: EventSink? = null
    private val discoveryReceiver: BroadcastReceiver? = null

    override fun onListen(o: Any?, eventSink: EventSink) {
        discoverySink = eventSink
    }

    override fun onCancel(o: Any?) {
        Log.d(TAG, "Canceling discovery (stream closed)")
        try {
            activityContext.unregisterReceiver(discoveryReceiver)
        } catch (ex: IllegalArgumentException) {
            // Ignore `Receiver not registered` exception
        }
        if (ActivityCompat.checkSelfPermission(
                activityContext,
                Manifest.permission.BLUETOOTH_SCAN
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return
        }
        bluetoothAdapter!!.cancelDiscovery()
        if (discoverySink != null) {
            discoverySink!!.endOfStream()
            discoverySink = null
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.v("BluetoothCTEPlugin", "Attached to engine")
        messenger = binding.binaryMessenger
        channel = MethodChannel(binding.binaryMessenger, PLUGIN_NAME)// Discovery

        val discoveryChannel = EventChannel(messenger, "$PLUGIN_NAME/discovery")

        discoveryChannel.setStreamHandler(this)

        channel.setMethodCallHandler(this)// Discovery

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (ActivityCompat.checkSelfPermission(
                activityContext,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            result.success(null)
        }
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "openSetting" -> {
                openSetting()
                result.success(null)
            }
            "getName" -> result.success(bluetoothAdapter?.name)
            "getAddress" -> result.success(getAddress())
            "getConnectedDevices" -> result.success(getConnectedDevices())
            "requestDiscoverable" -> requestDiscoverable(call, result)
            "startDiscovery" -> {
                Log.d(TAG, "Starting discovery");
                val intent = IntentFilter()
                intent.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED);
                intent.addAction(BluetoothDevice.ACTION_FOUND);
                activityContext.registerReceiver(discoveryReceiver, intent);

                bluetoothAdapter!!.startDiscovery()

                result.success(null)
            }
            "getBondedDevices" -> {
                val list: MutableList<Map<String, Any>> = ArrayList()
                for (device in bluetoothAdapter!!.bondedDevices) {
                    val entry: MutableMap<String, Any> = HashMap()
                    entry["address"] = device.address
                    entry["name"] = device.name
                    entry["type"] = device.type
                    entry["isConnected"] = checkIsDeviceConnected(device)
                    entry["bondState"] = BluetoothDevice.BOND_BONDED
                    list.add(entry)
                }

                result.success(list)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun getConnectedDevices(): Any? {
        return null
    }

    private fun requestDiscoverable(call: MethodCall, result: MethodChannel.Result) {
        val requestCode = 1
        val discoverableIntent: Intent =
            Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE).apply {
                putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 300)
            }
        startActivityForResult(activity, discoverableIntent, requestCode, null)

        val intent = Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE)

        if (call.hasArgument("duration")) {
            try {
                val duration = call.argument<Int>("duration")
                intent.putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, duration)
            } catch (ex: ClassCastException) {
                result.error(
                    "invalid_argument",
                    "'duration' argument is required to be integer",
                    null
                )
            }
        }
    }

    private fun openSetting() {
        startActivity(
            activity,
            Intent(Settings.ACTION_BLUETOOTH_SETTINGS),
            null
        )
    }

    private fun getAddress(): String {

        var address = ""
        if (ActivityCompat.checkSelfPermission(
                activityContext,
                Manifest.permission.BLUETOOTH_CONNECT
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            return address
        }
        address = bluetoothAdapter!!.address

        if (address == "02:00:00:00:00:00") {
            Log.w(TAG, "Local Bluetooth MAC address is hidden by system, trying other options...")
            do {
                Log.d(TAG, "Trying to obtain address using Settings Secure bank")
                try {
                    // Requires `LOCAL_MAC_ADDRESS` which could be unavailible for third party applications...
                    val value =
                        Settings.Secure.getString(
                            activityContext.contentResolver,
                            "bluetooth_address"
                        )
                            ?: throw NullPointerException("null returned, might be no permissions problem")
                    address = value
                    break
                } catch (ex: Exception) {
                    // Ignoring failure (since it isn't critical API for most applications)
                    Log.d(TAG, "Obtaining address using Settings Secure bank failed")
                    //result.error("hidden_address", "obtaining address using Settings Secure bank failed", exceptionToString(ex));
                }
                Log.d(
                    TAG,
                    "Trying to obtain address using reflection against internal Android code"
                )
                try {
                    // This will most likely work, but well, it is unsafe
                    val mServiceField: Field =
                        bluetoothAdapter!!.javaClass.getDeclaredField("mService")
                    mServiceField.isAccessible = true
                    val bluetoothManagerService = mServiceField[bluetoothAdapter]
                    if (bluetoothManagerService == null) {
                        if (!bluetoothAdapter!!.isEnabled) {
                            Log.d(TAG, "Probably failed just because adapter is disabled!")
                        }
                        throw NullPointerException()
                    }
                    val getAddressMethod: Method =
                        bluetoothManagerService.javaClass.getMethod("getAddress")
                    val value = getAddressMethod.invoke(bluetoothManagerService) as String
                    address = value
                    Log.d(TAG, "Probably succed: $address ✨ :F")
                    break
                } catch (ex: Exception) {
                    // Ignoring failure (since it isn't critical API for most applications)
                    Log.d(
                        TAG,
                        "Obtaining address using reflection against internal Android code failed"
                    )
                    //result.error("hidden_address", "obtaining address using reflection agains internal Android code failed", exceptionToString(ex));
                }
                Log.d(
                    TAG,
                    "Trying to look up address by network interfaces - might be invalid on some devices"
                )
                try {
                    // This method might return invalid MAC address (since Bluetooth might use other address than WiFi).
                    // @TODO . further testing: 1) check is while open connection, 2) check other devices
                    val interfaces: Enumeration<NetworkInterface> =
                        NetworkInterface.getNetworkInterfaces()
                    var value: String? = null
                    while (interfaces.hasMoreElements()) {
                        val networkInterface: NetworkInterface = interfaces.nextElement()
                        val name: String = networkInterface.name
                        if (!name.equals("wlan0", ignoreCase = true)) {
                            continue
                        }
                        val addressBytes: ByteArray = networkInterface.hardwareAddress
                        val addressBuilder = StringBuilder(18)
                        for (b in addressBytes) {
                            addressBuilder.append(String.format("%02X:", b))
                        }
                        addressBuilder.setLength(17)
                        value = addressBuilder.toString()
                        //     Log.v(TAG, "-> '" + name + "' : " + value);
                        // }
                        // else {
                        //    Log.v(TAG, "-> '" + name + "' : <no hardware address>");
                    }
                    if (value == null) {
                        throw NullPointerException()
                    }
                    address = value
                } catch (ex: Exception) {
                    // Ignoring failure (since it isn't critical API for most applications)
                    Log.w(TAG, "Looking for address by network interfaces failed")
                    //result.error("hidden_address", "looking for address by network interfaces failed", exceptionToString(ex));
                }
            } while (false)
        }
        return address
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        val bluetoothManager: BluetoothManager =
            activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

        this.bluetoothAdapter = bluetoothManager.adapter
        this.activityContext = binding.activity.baseContext
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }     /// Helper function to check is device connected

    private fun checkIsDeviceConnected(device: BluetoothDevice): Boolean {
        return try {
            val method: Method = device.javaClass.getMethod("isConnected")
            method.invoke(device) as Boolean
        } catch (ex: java.lang.Exception) {
            false
        }
    }
}
