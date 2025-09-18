import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'flutter_js_eval_inject_platform_interface.dart';

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
      
      final scriptElement = html.ScriptElement()
        ..type = 'text/javascript'
        ..text = bridgeScript;
      html.document.head?.append(scriptElement);
      
      _bridgeInitialized = true;
    } catch (e) {
      print('Error initializing JavaScript bridge: $e');
    }
  }

  @override
  Future<void> addJavascriptFile(String filePath) async {
    await _ensureBridgeInitialized();
    
    final scriptElement = html.ScriptElement()
      ..type = 'text/javascript'
      ..src = filePath;
    
    final completer = Completer<void>();
    
    scriptElement.onLoad.listen((_) {
      completer.complete();
    });
    
    scriptElement.onError.listen((error) {
      completer.completeError('Failed to load JavaScript file: $filePath');
    });
    
    html.document.head?.append(scriptElement);
    
    return completer.future;
  }

  @override
  Future<void> addJavascriptCode(String code) async {
    await _ensureBridgeInitialized();
    
    try {
      final scriptElement = html.ScriptElement()
        ..type = 'text/javascript'
        ..text = code;
      html.document.head?.append(scriptElement);
    } catch (e) {
      throw Exception('Failed to add JavaScript code: $e');
    }
  }

  @override
  Future<dynamic> evalJavascript(String codeToEval) async {
    await _ensureBridgeInitialized();
    
    try {
      if (js.context.hasProperty('flutterJsEvalInject')) {
        final result = js.context.callMethod('eval', [codeToEval]);
        return _convertJsObjectToDart(result);
      } else {
        final result = js.context.callMethod('eval', [codeToEval]);
        return _convertJsObjectToDart(result);
      }
    } catch (e) {
      throw Exception('JavaScript evaluation failed: $e');
    }
  }

  Future<void> _ensureBridgeInitialized() async {
    if (!_bridgeInitialized) {
      await _initializeBridge();
    }
  }

  dynamic _convertJsObjectToDart(dynamic jsObject) {
    if (jsObject == null) return null;
    
    if (jsObject is bool || jsObject is num || jsObject is String) {
      return jsObject;
    }
    
    if (js.context['Array'].callMethod('isArray', [jsObject])) {
      final List<dynamic> list = [];
      final length = js.context['Object'].callMethod('keys', [jsObject]).length;
      for (int i = 0; i < length; i++) {
        list.add(_convertJsObjectToDart(js.JsObject.fromBrowserObject(jsObject)[i]));
      }
      return list;
    }
    
    if (jsObject is js.JsObject) {
      final Map<String, dynamic> map = {};
      final keys = js.context['Object'].callMethod('keys', [jsObject]) as js.JsArray;
      for (int i = 0; i < keys.length; i++) {
        final key = keys[i] as String;
        map[key] = _convertJsObjectToDart(jsObject[key]);
      }
      return map;
    }
    
    return jsObject.toString();
  }
}