package com.example.next_ble.copy

import android.annotation.SuppressLint
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
import android.os.Bundle
import android.os.ParcelUuid
import android.text.format.DateFormat
import android.util.Log
import android.view.WindowManager
import com.example.next_ble.TimeProfile
import com.example.next_ble.tag
import io.flutter.embedding.android.FlutterActivity
import java.util.*

var REQUEST_ENABLE_BT: Int = 1412

class MainActivity : FlutterActivity() {
    @SuppressLint("MissingPermission")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Devices with a display should not go to sleep
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)

        bluetoothManager = getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter
        // We can't continue without proper Bluetooth support
        if (!checkBluetoothSupport(bluetoothAdapter)) {
            finish()
        }

        // Register for system Bluetooth events
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        registerReceiver(bluetoothReceiver, filter)
        if (!bluetoothAdapter.isEnabled) {
            Log.d(tag, "Bluetooth is currently disabled...enabling")
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
        } else {
            Log.d(tag, "Bluetooth enabled...starting services")
            startServer()
        }
    }/* Local UI */

    /* Bluetooth API */
    private lateinit var bluetoothManager: BluetoothManager
    private var bluetoothGattServer: BluetoothGattServer? = null

    /* Collection of notification subscribers */
    private val registeredDevices = mutableSetOf<BluetoothDevice>()

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
            updateLocalUi(now)
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

    override fun onStart() {
        super.onStart()
        // Register for system clock events
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_TIME_TICK)
            addAction(Intent.ACTION_TIME_CHANGED)
            addAction(Intent.ACTION_TIMEZONE_CHANGED)
        }

        registerReceiver(timeReceiver, filter)
    }

    override fun onStop() {
        super.onStop()
        unregisterReceiver(timeReceiver)
    }

    override fun onDestroy() {
        super.onDestroy()
        val bluetoothAdapter = bluetoothManager.adapter
        if (bluetoothAdapter.isEnabled) {
            stopServer()
            stopAdvertising()
        }

        unregisterReceiver(bluetoothReceiver)
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

        if (!packageManager.hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
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
            bluetoothManager.adapter.bluetoothLeAdvertiser

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
        bluetoothGattServer = bluetoothManager.openGattServer(this, gattServerCallback)

        bluetoothGattServer?.addService(TimeProfile.createTimeService())
            ?: Log.w(tag, "Unable to create GATT server")

        // Initialize the local UI
        updateLocalUi(System.currentTimeMillis())
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

    /**
     * Update graphical UI on devices that support it with the current time.
     */
    private fun updateLocalUi(timestamp: Long) {
        val date = Date(timestamp)
        DateFormat.getMediumDateFormat(this).format(date)
        DateFormat.getTimeFormat(this).format(date)
        // localTimeView.text = "$displayDate\n$displayTime"
    }
}


