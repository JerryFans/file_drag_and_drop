
import 'dart:async';

import 'package:flutter/services.dart';

class FileDragAndDrop {
  static const MethodChannel _channel =
      const MethodChannel('file_drag_and_drop');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
