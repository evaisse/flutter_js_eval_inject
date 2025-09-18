import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FlutterJsEvalInjectStub extends FlutterJsEvalInjectPlatform {
  @override
  Future<void> addJavascriptFile(String filePath) async {
    // No-op implementation for non-web platforms
  }

  @override
  Future<void> addJavascriptCode(String code) async {
    // No-op implementation for non-web platforms
  }

  @override
  Future<dynamic> evalJavascript(String codeToEval) async {
    // No-op implementation for non-web platforms
    return null;
  }
}

abstract class FlutterJsEvalInjectPlatform extends PlatformInterface {
  FlutterJsEvalInjectPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterJsEvalInjectPlatform _instance = FlutterJsEvalInjectStub();

  static FlutterJsEvalInjectPlatform get instance => _instance;

  static set instance(FlutterJsEvalInjectPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> addJavascriptFile(String filePath);

  Future<void> addJavascriptCode(String code);

  Future<dynamic> evalJavascript(String codeToEval);
}