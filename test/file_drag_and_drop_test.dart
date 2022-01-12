import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:file_drag_and_drop/file_drag_and_drop.dart';

void main() {
  const MethodChannel channel = MethodChannel('file_drag_and_drop');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FileDragAndDrop.platformVersion, '42');
  });
}
