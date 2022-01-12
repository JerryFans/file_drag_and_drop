
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final dragAndDropChannel = FileDragAndDropChannel.instance;

class FileDragAndDropChannel {
  
  FileDragAndDropChannel._() {
    // _channel.setMethodCallHandler(_methodCallHandler);
  }

  static final FileDragAndDropChannel instance = FileDragAndDropChannel._();

  static const MethodChannel _channel =
      const MethodChannel('file_drag_and_drop');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> initializedMainView() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _channel.invokeMethod('initializedMainView');
  }
}
