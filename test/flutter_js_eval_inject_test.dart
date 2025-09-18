import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_js_eval_inject/flutter_js_eval_inject.dart';

void main() {
  test('Plugin exports are accessible', () {
    expect(FlutterJsEvalInject.addJavascriptFile, isNotNull);
    expect(FlutterJsEvalInject.addJavascriptCode, isNotNull);
    expect(FlutterJsEvalInject.evalJavascript, isNotNull);
  });
}