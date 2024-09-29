import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mediapipe/flutter_mediapipe.dart';
import 'package:flutter_mediapipe/flutter_mediapipe_platform_interface.dart';
import 'package:flutter_mediapipe/flutter_mediapipe_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMediapipePlatform
    with MockPlatformInterfaceMixin
    implements FlutterMediapipePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMediapipePlatform initialPlatform = FlutterMediapipePlatform.instance;

  test('$MethodChannelFlutterMediapipe is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMediapipe>());
  });

  test('getPlatformVersion', () async {
    FlutterMediapipe flutterMediapipePlugin = FlutterMediapipe();
    MockFlutterMediapipePlatform fakePlatform = MockFlutterMediapipePlatform();
    FlutterMediapipePlatform.instance = fakePlatform;

    expect(await flutterMediapipePlugin.getPlatformVersion(), '42');
  });
}
