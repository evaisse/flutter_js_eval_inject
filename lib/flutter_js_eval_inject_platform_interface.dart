import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterJsEvalInjectPlatform extends PlatformInterface {
  FlutterJsEvalInjectPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterJsEvalInjectPlatform? _instance;

  static FlutterJsEvalInjectPlatform get instance {
    if (_instance == null) {
      throw StateError('FlutterJsEvalInject has not been initialized for this platform');
    }
    return _instance!;
  }

  static set instance(FlutterJsEvalInjectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> addJavascriptFile(String filePath);

  Future<void> addJavascriptCode(String code);

  Future<dynamic> evalJavascript(String codeToEval);
}