package com.example.next_ble

import android.bluetooth.BluetoothAdapter
import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class NextBlePlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {
    lateinit var pluginController: PluginController
    lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginController = PluginController()

        val channel = MethodChannel(binding.binaryMessenger, "next_ble_method")
        channel.setMethodCallHandler(this)
        pluginController.initialize(binding.binaryMessenger, binding.applicationContext)
        context = binding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {}

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        pluginController.execute(call, result)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        pluginController.setActivity(binding.activity, context)
    }

    override fun onDetachedFromActivityForConfigChanges() {}

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        pluginController.setActivity(binding.activity, context)
    }

    override fun onDetachedFromActivity() {}
}
