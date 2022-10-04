package com.example.next_ble

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.*
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.ParcelUuid
import android.provider.Settings
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

const val tag = "BluetoothCTEPlugin"

// Permissions and request constants
private const val REQUEST_COARSE_LOCATION_PERMISSIONS = 1451

class ExtensionBLEPlugin(context: Context, activity: Activity) {

    private var bluetoothAdapter: BluetoothAdapter? = null
    private var context: Context
    private var activity: Activity

    /* Bluetooth API */
    private lateinit var bluetoothManager: BluetoothManager
    private var bluetoothGattServer: BluetoothGattServer? = null

    /* Collection of notification subscribers */
    private val registeredDevices = mutableSetOf<BluetoothDevice>()

    init {
        this.context = context
        this.activity = activity
        this.bluetoothManager =
            activity.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

        this.bluetoothAdapter = bluetoothManager.adapter
    }

    fun getName(result: MethodChannel.Result) {
        ensurePermissions(object : EnsurePermissionsCallback {
            @SuppressLint("MissingPermission")
            override fun onResult(granted: Boolean) {
                if (granted) {
                    result.success(bluetoothAdapter!!.name)
                }
            }
        })
    }

    @SuppressLint("MissingPermission")
    fun setName(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("name")) {
            result.error("invalid_argument", "argument 'name' not found", null)
        }

        try {
            val name: String? = call.argument("name")
            result.success(bluetoothAdapter!!.setName(name))
        } catch (ex: java.lang.ClassCastException) {
            result.error("invalid_argument", "'name' argument is required to be string", null)
        }

    }

    fun startDiscovery(result: MethodChannel.Result) {
        Log.d(tag, "Starting discovery")

        val intent = IntentFilter()

        intent.addAction(BluetoothAdapter.ACTION_DISCOVERY_FINISHED)
        intent.addAction(BluetoothDevice.ACTION_FOUND)

        ensurePermissions(object : EnsurePermissionsCallback {
            @SuppressLint("MissingPermission")
            override fun onResult(granted: Boolean) {
                if (granted) {
                    bluetoothAdapter!!.startDiscovery()
                    Log.d(tag, "Starting discovery")
                    result.success(null)
                }
            }
        })
    }

    fun requestDiscoverable(call: MethodCall, result: MethodChannel.Result) {
        if (!call.hasArgument("duration")) {
            result.error("invalid_argument", "argument 'duration' not found", null)
        }

        val duration = call.argument<Int>("duration")

        val requestCode = 1
        val discoverableIntent: Intent =
            Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE).apply {
                putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, duration)
            }

        ActivityCompat.startActivityForResult(activity, discoverableIntent, requestCode, null)
    }

    fun openSetting() {
        ContextCompat.startActivity(
            activity,
            Intent(Settings.ACTION_BLUETOOTH_SETTINGS),
            null
        )
    }

    private interface EnsurePermissionsCallback {
        fun onResult(granted: Boolean)
    }

    private var pendingPermissionsEnsureCallbacks: EnsurePermissionsCallback? = null

    private fun ensurePermissions(callbacks: EnsurePermissionsCallback) {
        if (ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_COARSE_LOCATION
            )
            != PackageManager.PERMISSION_GRANTED
            || ContextCompat.checkSelfPermission(
                activity,
                Manifest.permission.ACCESS_FINE_LOCATION
            )
            != PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                activity,
                arrayOf(
                    Manifest.permission.ACCESS_COARSE_LOCATION,
                    Manifest.permission.ACCESS_FINE_LOCATION
                ),
                REQUEST_COARSE_LOCATION_PERMISSIONS
            )
            pendingPermissionsEnsureCallbacks = callbacks
        } else {
            callbacks.onResult(true)
        }
    }

    @SuppressLint("MissingPermission")
    fun startGatt() {
        if (!checkBluetoothSupport(bluetoothAdapter)) {
            activity.finish()
        }

        // Register for system Bluetooth events
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        activity.registerReceiver(bluetoothReceiver, filter)

        if (!bluetoothAdapter!!.isEnabled) {
            Log.d(tag, "Bluetooth is currently disabled...enabling")
            bluetoothAdapter!!.enable()
        } else {
            Log.d(tag, "Bluetooth enabled...starting services")
            val requestCode = 1
            val discoverableIntent: Intent =
                Intent(BluetoothAdapter.ACTION_REQUEST_DISCOVERABLE).apply {
                    putExtra(BluetoothAdapter.EXTRA_DISCOVERABLE_DURATION, 120)
                }
            activity.startActivityForResult(discoverableIntent, requestCode)
            startAdvertising()
            startServer()
        }

        val filter1 = IntentFilter().apply {
            addAction(Intent.ACTION_TIME_TICK)
            addAction(Intent.ACTION_TIME_CHANGED)
            addAction(Intent.ACTION_TIMEZONE_CHANGED)
        }
        activity.registerReceiver(timeReceiver, filter1)
    }

    fun destroyGatt() {
        try {
            activity.unregisterReceiver(timeReceiver)
            activity.unregisterReceiver(bluetoothReceiver)
        } catch (e: Exception) {

        }
        val bluetoothAdapter = bluetoothManager.adapter
        if (bluetoothAdapter.isEnabled) {
            stopServer()
            stopAdvertising()
        }
    }

    /**
     * Listens for system time changes and triggers a notification to
     * Bluetooth subscribers.
     */
    private val timeReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val adjustReason = when (intent.action) {
                Intent.ACTION_TIME_CHANGED -> TimeProfile.ADJUST_MANUAL
                Intent.ACTION_TIMEZONE_CHANGED -> TimeProfile.ADJUST_TIMEZONE
                Intent.ACTION_TIME_TICK -> TimeProfile.ADJUST_NONE
                else -> TimeProfile.ADJUST_NONE
            }
            val now = System.currentTimeMillis()
            notifyRegisteredDevices(now, adjustReason)
        }
    }

    /**
     * Listens for Bluetooth adapter events to enable/disable
     * advertising and server functionality.
     */
    private val bluetoothReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {

            when (intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)) {
                BluetoothAdapter.STATE_ON -> {
                    startAdvertising()
                    startServer()
                }
                BluetoothAdapter.STATE_OFF -> {
                    stopServer()
                    stopAdvertising()
                }
            }
        }
    }

    /**
     * Callback to receive information about the advertisement process.
     */
    private val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            Log.i(tag, "LE Advertise Started.")
        }

        override fun onStartFailure(errorCode: Int) {
            Log.w(tag, "LE Advertise Failed: $errorCode")
        }
    }

    /**
     * Callback to handle incoming requests to the GATT server.
     * All read/write requests for characteristics and descriptors are handled here.
     */
    private val gattServerCallback = object : BluetoothGattServerCallback() {
        override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                Log.i(tag, "BluetoothDevice CONNECTED: $device")
            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                Log.i(tag, "BluetoothDevice DISCONNECTED: $device")
                //Remove device from any active subscriptions
                registeredDevices.remove(device)
            }
        }

        @SuppressLint("MissingPermission")
        override fun onCharacteristicReadRequest(
            device: BluetoothDevice, requestId: Int, offset: Int,
            characteristic: BluetoothGattCharacteristic
        ) {
            val now = System.currentTimeMillis()
            when {
                TimeProfile.CURRENT_TIME == characteristic.uuid -> {
                    Log.i(tag, "Read CurrentTime")
                    bluetoothGattServer?.sendResponse(
                        device,
                        requestId,
                        BluetoothGatt.GATT_SUCCESS,
                        0,
                        TimeProfile.getExactTime(now, TimeProfile.ADJUST_NONE)
                    )
                }
                TimeProfile.LOCAL_TIME_INFO == characteristic.uuid -> {
                    Log.i(tag, "Read LocalTimeInfo")
                    bluetoothGattServer?.sendResponse(
                        device,
                        requestId,
                        BluetoothGatt.GATT_SUCCESS,
                        0,
                        TimeProfile.getLocalTimeInfo(now)
                    )
                }
                else -> {
                    // Invalid characteristic
                    Log.w(tag, "Invalid Characteristic Read: " + characteristic.uuid)
                    bluetoothGattServer?.sendResponse(
                        device,
                        requestId,
                        BluetoothGatt.GATT_FAILURE,
                        0,
                        null
                    )
                }
            }
        }

        @SuppressLint("MissingPermission")
        override fun onDescriptorReadRequest(
            device: BluetoothDevice, requestId: Int, offset: Int,
            descriptor: BluetoothGattDescriptor
        ) {
            if (TimeProfile.CLIENT_CONFIG == descriptor.uuid) {
                Log.d(tag, "Config descriptor read")
                val returnValue = if (registeredDevices.contains(device)) {
                    BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
                } else {
                    BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE
                }
                bluetoothGattServer?.sendResponse(
                    device,
                    requestId,
                    BluetoothGatt.GATT_SUCCESS,
                    0,
                    returnValue
                )
            } else {
                Log.w(tag, "Unknown descriptor read request")
                bluetoothGattServer?.sendResponse(
                    device,
                    requestId,
                    BluetoothGatt.GATT_FAILURE,
                    0, null
                )
            }
        }

        @SuppressLint("MissingPermission")
        override fun onDescriptorWriteRequest(
            device: BluetoothDevice, requestId: Int,
            descriptor: BluetoothGattDescriptor,
            preparedWrite: Boolean, responseNeeded: Boolean,
            offset: Int, value: ByteArray
        ) {
            if (TimeProfile.CLIENT_CONFIG == descriptor.uuid) {
                if (Arrays.equals(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE, value)) {
                    Log.d(tag, "Subscribe device to notifications: $device")
                    registeredDevices.add(device)
                } else if (Arrays.equals(
                        BluetoothGattDescriptor.DISABLE_NOTIFICATION_VALUE,
                        value
                    )
                ) {
                    Log.d(tag, "Unsubscribe device from notifications: $device")
                    registeredDevices.remove(device)
                }

                if (responseNeeded) {
                    bluetoothGattServer?.sendResponse(
                        device,
                        requestId,
                        BluetoothGatt.GATT_SUCCESS,
                        0, null
                    )
                }
            } else {
                Log.w(tag, "Unknown descriptor write request")
                if (responseNeeded) {
                    bluetoothGattServer?.sendResponse(
                        device,
                        requestId,
                        BluetoothGatt.GATT_FAILURE,
                        0, null
                    )
                }
            }
        }
    }

    /**
     * Verify the level of Bluetooth support provided by the hardware.
     * @param bluetoothAdapter System [BluetoothAdapter].
     * @return true if Bluetooth is properly supported, false otherwise.
     */
    private fun checkBluetoothSupport(bluetoothAdapter: BluetoothAdapter?): Boolean {

        if (bluetoothAdapter == null) {
            Log.w(tag, "Bluetooth is not supported")
            return false
        }

        if (!activity.packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Log.w(tag, "Bluetooth LE is not supported")
            return false
        }

        return true
    }

    /**
     * Begin advertising over Bluetooth that this device is connectable
     * and supports the Current Time Service.
     */
    @SuppressLint("MissingPermission")
    private fun startAdvertising() {
        val bluetoothLeAdvertiser: BluetoothLeAdvertiser? =
            bluetoothAdapter?.bluetoothLeAdvertiser

        bluetoothLeAdvertiser?.let {
            val settings = AdvertiseSettings.Builder()
                .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
                .setConnectable(true)
                .setTimeout(0)
                .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM)
                .build()

            val data = AdvertiseData.Builder()
                .setIncludeDeviceName(true)
                .setIncludeTxPowerLevel(false)
                .addServiceUuid(ParcelUuid(TimeProfile.TIME_SERVICE))
                .build()

            it.startAdvertising(settings, data, advertiseCallback)
        } ?: Log.w(tag, "Failed to create advertiser")
    }

    /**
     * Stop Bluetooth advertisements.
     */
    @SuppressLint("MissingPermission")
    private fun stopAdvertising() {
        val bluetoothLeAdvertiser: BluetoothLeAdvertiser? =
            bluetoothManager.adapter.bluetoothLeAdvertiser
        bluetoothLeAdvertiser?.stopAdvertising(advertiseCallback) ?: Log.w(
            tag,
            "Failed to create advertiser"
        )
    }

    /**
     * Initialize the GATT server instance with the services/characteristics
     * from the Time Profile.
     */
    @SuppressLint("MissingPermission")
    private fun startServer() {
        bluetoothGattServer = bluetoothManager.openGattServer(context, gattServerCallback)

        bluetoothGattServer?.addService(TimeProfile.createTimeService())
            ?: Log.w(tag, "Unable to create GATT server")
    }

    /**
     * Shut down the GATT server.
     */
    @SuppressLint("MissingPermission")
    private fun stopServer() {
        bluetoothGattServer?.close()
    }

    /**
     * Send a time service notification to any devices that are subscribed
     * to the characteristic.
     */
    @SuppressLint("MissingPermission")
    private fun notifyRegisteredDevices(timestamp: Long, adjustReason: Byte) {
        if (registeredDevices.isEmpty()) {
            Log.i(tag, "No subscribers registered")
            return
        }
        val exactTime = TimeProfile.getExactTime(timestamp, adjustReason)

        Log.i(tag, "Sending update to ${registeredDevices.size} subscribers")
        for (device in registeredDevices) {
            val timeCharacteristic = bluetoothGattServer
                ?.getService(TimeProfile.TIME_SERVICE)
                ?.getCharacteristic(TimeProfile.CURRENT_TIME)
            timeCharacteristic?.value = exactTime
            bluetoothGattServer?.notifyCharacteristicChanged(device, timeCharacteristic, false)
        }
    }
}