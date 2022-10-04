package com.example.next_ble.channelhandlers

import com.example.next_ble.ProtobufModel as pb
import com.example.next_ble.converters.ProtobufMessageConverter
import com.example.next_ble.utils.Duration
import io.flutter.plugin.common.EventChannel
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.Disposable
import java.util.concurrent.TimeUnit

class DeviceConnectionHandler(private val bleClient: com.example.next_ble.ble.BleClient) :
    EventChannel.StreamHandler {
    private var connectDeviceSink: EventChannel.EventSink? = null
    private val converter = ProtobufMessageConverter()

    private lateinit var connectionUpdatesDisposable: Disposable

    override fun onListen(objectSink: Any?, eventSink: EventChannel.EventSink?) {
        eventSink?.let {
            connectDeviceSink = eventSink
            connectionUpdatesDisposable = listenToConnectionChanges()
        }
    }

    override fun onCancel(objectSink: Any?) {
        disconnectAll()
        connectionUpdatesDisposable.dispose()
    }

    fun connectToDevice(connectToDeviceMessage: pb.ConnectToDeviceRequest) {
        bleClient.connectToDevice(
            connectToDeviceMessage.deviceId,
            Duration(connectToDeviceMessage.timeoutInMs.toLong(), TimeUnit.MILLISECONDS)
        )
    }

    fun disconnectDevice(deviceId: String) {
        bleClient.disconnectDevice(deviceId)
    }

    fun disconnectAll() {
        connectDeviceSink = null
        bleClient.disconnectAllDevices()
    }

    private fun listenToConnectionChanges() = bleClient.connectionUpdateSubject
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe { update ->
            when (update) {
                is com.example.next_ble.ble.ConnectionUpdateSuccess -> {
                    handleDeviceConnectionUpdateResult(converter.convertToDeviceInfo(update))
                }
                is com.example.next_ble.ble.ConnectionUpdateError -> {
                    handleDeviceConnectionUpdateResult(
                        converter.convertConnectionErrorToDeviceInfo(
                            update.deviceId,
                            update.errorMessage
                        )
                    )
                }
            }
        }

    private fun handleDeviceConnectionUpdateResult(connectionUpdateMessage: pb.DeviceInfo) {
        connectDeviceSink?.success(connectionUpdateMessage.toByteArray())
    }
}
