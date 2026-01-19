import 'package:flutter/services.dart';

class VolumeKeyChannel {
  static const MethodChannel _channel = MethodChannel('volume_key');
  static VoidCallback? _onVolumeUp;
  static VoidCallback? _onVolumeDown;

  /// 启用音量监听
  static void attach({
    required VoidCallback onVolumeUp,
    required VoidCallback onVolumeDown,
  }) async {
    _onVolumeUp = onVolumeUp;
    _onVolumeDown = onVolumeDown;

    _channel.setMethodCallHandler(_handleMethod);
    await _channel.invokeMethod('enable_volume_intercept'); // 通知启用音量拦截
  }

  /// 禁用音量监听
  static void detach() async {
    _onVolumeUp = null;
    _onVolumeDown = null;
    await _channel.invokeMethod('disable_volume_intercept'); // 通知禁用音量拦截
  }

  static Future<void> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'volume_up':
        _onVolumeUp?.call();
        break;
      case 'volume_down':
        _onVolumeDown?.call();
        break;
    }
  }
}