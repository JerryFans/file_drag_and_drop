import 'dart:async';
import 'dart:io';
import 'package:file_drag_and_drop/drag_container_listener.dart';
import 'package:file_drag_and_drop/file_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final dragAndDropChannel = FileDragAndDropChannel.instance;

const kFileDragAndDropEventEntered = 'enter';
const kFileDragAndDropEventExit = 'exit';
const kFileDragAndDropEventPrepareDragTask = 'prepare-drag-task';
const kFileDragAndDropEventPerformDragTask = 'perform-dragtask';

class FileDragAndDropChannel {
  FileDragAndDropChannel._() {
    if (Platform.isMacOS == false) return;
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  static final FileDragAndDropChannel instance = FileDragAndDropChannel._();

  static const MethodChannel _channel =
      const MethodChannel('file_drag_and_drop');

  ObserverList<DragContainerListener>? _listeners =
      ObserverList<DragContainerListener>();

  Future<void> _methodCallHandler(MethodCall call) async {
    if (_listeners == null) return;

    for (final DragContainerListener listener in listeners) {
      if (!_listeners!.contains(listener)) {
        return;
      }

      if (call.method != 'onEvent') throw UnimplementedError();

      String eventName = call.arguments['eventName'];
      Map<String, Function> funcMap = {
        kFileDragAndDropEventEntered: listener.draggingFileEntered,
        kFileDragAndDropEventExit: listener.draggingFileExit,
        kFileDragAndDropEventPrepareDragTask:
            listener.prepareForDragFileOperation,
        kFileDragAndDropEventPerformDragTask: listener.performDragFileOperation,
      };
      if (eventName == kFileDragAndDropEventPerformDragTask) {
        List fileResult = call.arguments['fileResult'];
        var resultList = <DragFileResult>[];
        fileResult.forEach((element) { 
          var result = DragFileResult.fromJson(element);
          resultList.add(result);
        });
        funcMap[eventName]!(resultList);
      } else {
        funcMap[eventName]!();
      }
    }
  }

  List<DragContainerListener> get listeners {
    final List<DragContainerListener> localListeners =
        List<DragContainerListener>.from(_listeners!);
    return localListeners;
  }

  bool get hasListeners {
    return _listeners!.isNotEmpty;
  }

  void addListener(DragContainerListener listener) {
    _listeners!.add(listener);
  }

  void removeListener(DragContainerListener listener) {
    _listeners!.remove(listener);
  }

  Future<void> initializedMainView() async {
    if (Platform.isMacOS == false) return;
    await _channel.invokeMethod('initializedMainView');
  }
}
