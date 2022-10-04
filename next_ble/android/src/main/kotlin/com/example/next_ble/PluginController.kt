package com.example.next_ble

import android.app.Activity
import android.content.Context
import android.util.Log
import com.example.next_ble.ble.RequestConnectionPriorityFailed
import com.example.next_ble.channelhandlers.CharNotificationHandler
import com.example.next_ble.channelhandlers.DeviceConnectionHandler
import com.example.next_ble.channelhandlers.ScanDevicesHandler
import com.example.next_ble.converters.ProtobufMessageConverter
import com.example.next_ble.converters.UuidConverter
import com.example.next_ble.model.ClearGattCacheErrorType
import com.example.next_ble.utils.discard
import com.example.next_ble.utils.toConnectionPriority
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.reactivex.Single
import io.reactivex.android.schedulers.AndroidSchedulers
import java.util.*
import com.example.next_ble.ProtobufModel as pb

@Suppress("TooManyFunctions")
class PluginController {

    private val pluginMethods =
        mapOf<String, (call: MethodCall, result: MethodChannel.Result) -> Unit>(
            "initialize" to this::initializeClient,
            "disposeClient" to this::disposeClient,
            "scanForDevices" to this::scanForDevices,
            "connectToDevice" to this::connectToDevice,
            "clearGattCache" to this::clearGattCache,
            "disconnectFromDevice" to this::disconnectFromDevice,
            "readCharacteristic" to this::readCharacteristic,
            "writeCharacteristicWithResponse" to this::writeCharacteristicWithResponse,
            "writeCharacteristicWithoutResponse" to this::writeCharacteristicWithoutResponse,
            "readNotifications" to this::readNotifications,
            "stopNotifications" to this::stopNotifications,
            "negotiateMtuSize" to this::negotiateMtuSize,
            "requestConnectionPriority" to this::requestConnectionPriority,
            "discoverServices" to this::discoverServices,
            "openSetting" to this::openSetting,
            "getName" to this::getName,
            "setName" to this::setName,
            "requestDiscoverable" to this::requestDiscoverable,
            "startDiscovery" to this::startDiscovery,
            "startGatt" to this::startGatt,
            "stopGatt" to this::stopGatt,
        )


    private lateinit var bleClient: com.example.next_ble.ble.BleClient

    private lateinit var scanchannel: EventChannel

    private lateinit var deviceConnectionChannel: EventChannel
    private lateinit var charNotificationChannel: EventChannel

    private lateinit var scanDevicesHandler: ScanDevicesHandler
    private lateinit var deviceConnectionHandler: DeviceConnectionHandler
    private lateinit var charNotificationHandler: CharNotificationHandler

    private val uuidConverter = UuidConverter()
    private val protoConverter = ProtobufMessageConverter()

    private lateinit var extensionBLEPlugin: ExtensionBLEPlugin

    private lateinit var activity: Activity

    fun setActivity(activity: Activity, context: Context) {
        this.activity = activity
        extensionBLEPlugin = ExtensionBLEPlugin(context, activity)
    }

    internal fun initialize(messenger: BinaryMessenger, context: Context) {
        bleClient = com.example.next_ble.ble.ReactiveBleClient(context)

        scanchannel = EventChannel(messenger, "next_ble_scan")
        deviceConnectionChannel = EventChannel(messenger, "next_ble_connected_device")
        charNotificationChannel = EventChannel(messenger, "next_ble_char_update")
        val bleStatusChannel = EventChannel(messenger, "next_ble_status")

        scanDevicesHandler = ScanDevicesHandler(bleClient)
        deviceConnectionHandler = DeviceConnectionHandler(bleClient)
        charNotificationHandler = CharNotificationHandler(bleClient)
        val bleStatusHandler = BleStatusHandler(bleClient)

        scanchannel.setStreamHandler(scanDevicesHandler)
        deviceConnectionChannel.setStreamHandler(deviceConnectionHandler)
        charNotificationChannel.setStreamHandler(charNotificationHandler)
        bleStatusChannel.setStreamHandler(bleStatusHandler)
    }

    internal fun execute(call: MethodCall, result: MethodChannel.Result) {
        pluginMethods[call.method]?.invoke(call, result) ?: result.notImplemented()
    }

    private fun initializeClient(call: MethodCall, result: MethodChannel.Result) {
        bleClient.initializeClient()
        result.success(null)
    }

    private fun disposeClient(call: MethodCall, result: MethodChannel.Result) {
        scanDevicesHandler.stopDeviceScan()
        deviceConnectionHandler.disconnectAll()
        result.success(null)
    }

    private fun scanForDevices(call: MethodCall, result: MethodChannel.Result) {
        scanDevicesHandler.prepareScan(pb.ScanForDevicesRequest.parseFrom(call.arguments as ByteArray))
        result.success(null)
    }

    private fun connectToDevice(call: MethodCall, result: MethodChannel.Result) {
        result.success(null)
        val connectDeviceMessage = pb.ConnectToDeviceRequest.parseFrom(call.arguments as ByteArray)
        deviceConnectionHandler.connectToDevice(connectDeviceMessage)
    }

    private fun clearGattCache(call: MethodCall, result: MethodChannel.Result) {
        val args = pb.ClearGattCacheRequest.parseFrom(call.arguments as ByteArray)
        bleClient.clearGattCache(args.deviceId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(
                {
                    val info = pb.ClearGattCacheInfo.getDefaultInstance()
                    result.success(info.toByteArray())
                },
                {
                    val info = protoConverter.convertClearGattCacheError(
                        ClearGattCacheErrorType.UNKNOWN,
                        it.message
                    )
                    result.success(info.toByteArray())
                }
            )
            .discard()
    }

    private fun disconnectFromDevice(call: MethodCall, result: MethodChannel.Result) {
        result.success(null)
        val connectDeviceMessage =
            pb.DisconnectFromDeviceRequest.parseFrom(call.arguments as ByteArray)
        deviceConnectionHandler.disconnectDevice(connectDeviceMessage.deviceId)
    }

    private fun readCharacteristic(call: MethodCall, result: MethodChannel.Result) {
        result.success(null)

        val readCharMessage = pb.ReadCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        val deviceId = readCharMessage.characteristic.deviceId
        val characteristic =
            uuidConverter.uuidFromByteArray(readCharMessage.characteristic.characteristicUuid.data.toByteArray())

        bleClient.readCharacteristic(
            readCharMessage.characteristic.deviceId, characteristic
        )
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe(
                { charResult ->
                    when (charResult) {
                        is com.example.next_ble.ble.CharOperationSuccessful -> {
                            val charInfo = protoConverter.convertCharacteristicInfo(
                                readCharMessage.characteristic,
                                charResult.value.toByteArray()
                            )
                            charNotificationHandler.addSingleReadToStream(charInfo)
                        }
                        is com.example.next_ble.ble.CharOperationFailed -> {
                            protoConverter.convertCharacteristicError(
                                readCharMessage.characteristic,
                                "Failed to connect"
                            )
                            charNotificationHandler.addSingleErrorToStream(
                                readCharMessage.characteristic,
                                charResult.errorMessage
                            )
                        }
                    }
                },
                { throwable ->
                    protoConverter.convertCharacteristicError(
                        readCharMessage.characteristic,
                        throwable.message
                    )
                    charNotificationHandler.addSingleErrorToStream(
                        readCharMessage.characteristic,
                        throwable?.message ?: "Failure"
                    )
                }
            )
            .discard()
    }

    private fun writeCharacteristicWithResponse(call: MethodCall, result: MethodChannel.Result) {
        executeWriteAndPropagateResultToChannel(
            call,
            result,
            com.example.next_ble.ble.BleClient::writeCharacteristicWithResponse
        )
    }

    private fun writeCharacteristicWithoutResponse(call: MethodCall, result: MethodChannel.Result) {
        executeWriteAndPropagateResultToChannel(
            call,
            result,
            com.example.next_ble.ble.BleClient::writeCharacteristicWithoutResponse
        )
    }

    private fun executeWriteAndPropagateResultToChannel(
        call: MethodCall,
        result: MethodChannel.Result,
        writeOperation: com.example.next_ble.ble.BleClient.(
            deviceId: String,
            characteristic: UUID,
            value: ByteArray
        ) -> Single<com.example.next_ble.ble.CharOperationResult>
    ) {
        val writeCharMessage = pb.WriteCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        bleClient.writeOperation(
            writeCharMessage.characteristic.deviceId,
            uuidConverter.uuidFromByteArray(writeCharMessage.characteristic.characteristicUuid.data.toByteArray()),
            writeCharMessage.value.toByteArray()
        )
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ operationResult ->
                when (operationResult) {
                    is com.example.next_ble.ble.CharOperationSuccessful -> {
                        result.success(
                            protoConverter.convertWriteCharacteristicInfo(
                                writeCharMessage,
                                null
                            ).toByteArray()
                        )
                    }
                    is com.example.next_ble.ble.CharOperationFailed -> {
                        result.success(
                            protoConverter.convertWriteCharacteristicInfo(
                                writeCharMessage,
                                operationResult.errorMessage
                            ).toByteArray()
                        )
                    }
                }
            },
                { throwable ->
                    result.success(
                        protoConverter.convertWriteCharacteristicInfo(
                            writeCharMessage,
                            throwable.message
                        ).toByteArray()
                    )
                }
            )
            .discard()
    }

    private fun readNotifications(call: MethodCall, result: MethodChannel.Result) {
        val request = pb.NotifyCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        charNotificationHandler.subscribeToNotifications(request)
        result.success(null)
    }

    private fun stopNotifications(call: MethodCall, result: MethodChannel.Result) {
        val request = pb.NotifyNoMoreCharacteristicRequest.parseFrom(call.arguments as ByteArray)
        charNotificationHandler.unsubscribeFromNotifications(request)
        result.success(null)
    }

    private fun negotiateMtuSize(call: MethodCall, result: MethodChannel.Result) {
        val request = pb.NegotiateMtuRequest.parseFrom(call.arguments as ByteArray)
        bleClient.negotiateMtuSize(request.deviceId, request.mtuSize)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ mtuResult ->
                result.success(protoConverter.convertNegotiateMtuInfo(mtuResult).toByteArray())
            }, { throwable ->
                result.success(
                    protoConverter.convertNegotiateMtuInfo(
                        com.example.next_ble.ble.MtuNegotiateFailed(
                            request.deviceId,
                            throwable.message ?: ""
                        )
                    ).toByteArray()
                )
            }
            )
            .discard()
    }

    private fun requestConnectionPriority(call: MethodCall, result: MethodChannel.Result) {
        val request = pb.ChangeConnectionPriorityRequest.parseFrom(call.arguments as ByteArray)

        bleClient.requestConnectionPriority(
            request.deviceId,
            request.priority.toConnectionPriority()
        )
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ requestResult ->
                result.success(
                    protoConverter
                        .convertRequestConnectionPriorityInfo(requestResult).toByteArray()
                )
            },
                { throwable ->
                    result.success(
                        protoConverter.convertRequestConnectionPriorityInfo(
                            RequestConnectionPriorityFailed(
                                request.deviceId, throwable?.message
                                    ?: "Unknown error"
                            )
                        ).toByteArray()
                    )
                })
            .discard()
    }

    private fun discoverServices(call: MethodCall, result: MethodChannel.Result) {
        val request = pb.DiscoverServicesRequest.parseFrom(call.arguments as ByteArray)

        bleClient.discoverServices(request.deviceId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribe({ discoverResult ->
                result.success(
                    protoConverter.convertDiscoverServicesInfo(
                        request.deviceId,
                        discoverResult
                    ).toByteArray()
                )
            }, { throwable ->
                result.error("service_discovery_failure", throwable.message, null)
            })
            .discard()
    }

    private fun openSetting(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.openSetting()
    }

    private fun getName(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.getName(result)
    }

    private fun setName(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.setName(call, result)
    }

    private fun requestDiscoverable(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.requestDiscoverable(call, result)
    }

    private fun startDiscovery(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.startDiscovery(result)
    }


    private fun startGatt(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.startGatt()
    }

    private fun stopGatt(call: MethodCall, result: MethodChannel.Result) {
        extensionBLEPlugin.destroyGatt()
    }
}
