package com.enablearia.esjzone

import android.view.KeyEvent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "volume_key"
    private var interceptVolumeKey = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, _ ->
            when (call.method) {
                "enable_volume_intercept" -> interceptVolumeKey = true
                "disable_volume_intercept" -> interceptVolumeKey = false
            }
        }
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (interceptVolumeKey) {
            when (keyCode) {
                KeyEvent.KEYCODE_VOLUME_UP -> {
                    sendToFlutter("volume_up")
                    return true // 拦截系统音量更改
                }

                KeyEvent.KEYCODE_VOLUME_DOWN -> {
                    sendToFlutter("volume_down")
                    return true // 拦截系统音量更改
                }
            }
        }
        return super.onKeyDown(keyCode, event)
    }

    private fun sendToFlutter(action: String) {
        MethodChannel(
            flutterEngine!!.dartExecutor.binaryMessenger,
            CHANNEL
        ).invokeMethod(action, null)
    }
}
