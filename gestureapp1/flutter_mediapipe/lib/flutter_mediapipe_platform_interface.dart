import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_mediapipe_method_channel.dart';

abstract class FlutterMediapipePlatform extends PlatformInterface {
  /// Constructs a FlutterMediapipePlatform.
  FlutterMediapipePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediapipePlatform _instance = MethodChannelFlutterMediapipe();

  /// The default instance of [FlutterMediapipePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMediapipe].
  static FlutterMediapipePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMediapipePlatform] when
  /// they register themselves.
  static set instance(FlutterMediapipePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
