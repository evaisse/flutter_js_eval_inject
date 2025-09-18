import 'dart:async';
import 'flutter_js_eval_inject_platform_interface.dart';

export 'flutter_js_eval_inject_platform_interface.dart' show FlutterJsEvalInjectPlatform;

class FlutterJsEvalInject {
  static Future<void> addJavascriptFile(String filePath) {
    return FlutterJsEvalInjectPlatform.instance.addJavascriptFile(filePath);
  }

  static Future<void> addJavascriptCode(String code) {
    return FlutterJsEvalInjectPlatform.instance.addJavascriptCode(code);
  }

  static Future<dynamic> evalJavascript(String codeToEval) {
    return FlutterJsEvalInjectPlatform.instance.evalJavascript(codeToEval);
  }
}