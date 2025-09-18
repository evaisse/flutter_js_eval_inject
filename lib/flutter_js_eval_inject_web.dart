import 'dart:async';
import 'dart:js_interop';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;
import 'flutter_js_eval_inject_platform_interface.dart';

@JS('eval')
external JSAny? _eval(String code);

@JS('JSON.stringify')
external String _jsonStringify(JSAny? value);

@JS('JSON.parse')
external JSAny? _jsonParse(String json);

class FlutterJsEvalInjectWeb extends FlutterJsEvalInjectPlatform {
  static void registerWith(Registrar registrar) {
    FlutterJsEvalInjectPlatform.instance = FlutterJsEvalInjectWeb();
  }

  FlutterJsEvalInjectWeb() {
    _initializeBridge();
  }

  bool _bridgeInitialized = false;

  Future<void> _initializeBridge() async {
    if (_bridgeInitialized) return;

    try {
      final bridgeScript = await rootBundle.loadString('packages/flutter_js_eval_inject/lib/assets/js_bridge.js');
      
      final scriptElement = web.HTMLScriptElement()
        ..type = 'text/javascript'
        ..text = bridgeScript;
      
      web.document.head?.appendChild(scriptElement);
      
      _bridgeInitialized = true;
    } catch (e) {
      // Silent failure - bridge initialization failed
      // This is acceptable as the plugin will still function without the bridge
    }
  }

  @override
  Future<void> addJavascriptFile(String filePath) async {
    await _ensureBridgeInitialized();
    
    final scriptElement = web.HTMLScriptElement()
      ..type = 'text/javascript'
      ..src = filePath;
    
    final completer = Completer<void>();
    
    void loadHandler(web.Event event) {
      completer.complete();
    }
    
    void errorHandler(web.Event event) {
      completer.completeError('Failed to load JavaScript file: $filePath');
    }
    
    scriptElement.addEventListener('load', loadHandler.toJS);
    scriptElement.addEventListener('error', errorHandler.toJS);
    
    web.document.head?.appendChild(scriptElement);
    
    return completer.future;
  }

  @override
  Future<void> addJavascriptCode(String code) async {
    await _ensureBridgeInitialized();
    
    try {
      final scriptElement = web.HTMLScriptElement()
        ..type = 'text/javascript'
        ..text = code;
      
      web.document.head?.appendChild(scriptElement);
    } catch (e) {
      throw Exception('Failed to add JavaScript code: $e');
    }
  }

  @override
  Future<dynamic> evalJavascript(String codeToEval) async {
    await _ensureBridgeInitialized();
    
    try {
      final result = _eval(codeToEval);
      return _convertJsObjectToDart(result);
    } catch (e) {
      throw Exception('JavaScript evaluation failed: $e');
    }
  }

  Future<void> _ensureBridgeInitialized() async {
    if (!_bridgeInitialized) {
      await _initializeBridge();
    }
  }

  dynamic _convertJsObjectToDart(JSAny? jsObject) {
    if (jsObject == null || jsObject.isUndefinedOrNull) {
      return null;
    }
    
    // Check if it's a primitive type
    final dartValue = jsObject.dartify();
    if (dartValue is bool || dartValue is num || dartValue is String) {
      return dartValue;
    }
    
    // For complex types, try to convert via JSON
    try {
      final jsonString = _jsonStringify(jsObject);
      final parsed = _jsonParse(jsonString);
      return parsed?.dartify();
    } catch (e) {
      // If JSON conversion fails, return the dartified version
      return dartValue;
    }
  }
}