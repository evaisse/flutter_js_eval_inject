import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_js_eval_inject_example/main.dart';

void main() {
  testWidgets('App loads and displays UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    expect(find.text('Flutter JS Eval Inject Demo'), findsOneWidget);
    
    expect(find.text('JavaScript Code:'), findsOneWidget);
    expect(find.text('JavaScript File URL:'), findsOneWidget);
    
    expect(find.text('Add JS Code'), findsOneWidget);
    expect(find.text('Load JS File'), findsOneWidget);
    expect(find.text('Eval JS'), findsOneWidget);
    expect(find.text('Test Lodash'), findsOneWidget);
    expect(find.text('Test Complex'), findsOneWidget);
    
    expect(find.text('Output:'), findsOneWidget);
    
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byType(ElevatedButton), findsNWidgets(5));
  });
  
  testWidgets('JavaScript code field has initial content', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    final textField = find.byType(TextField).first;
    final TextField widget = tester.widget(textField);
    
    expect(widget.controller?.text, contains('function greet'));
    expect(widget.controller?.text, contains('Flutter'));
  });
  
  testWidgets('File URL field has initial Lodash URL', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    final textField = find.byType(TextField).last;
    final TextField widget = tester.widget(textField);
    
    expect(widget.controller?.text, contains('lodash'));
    expect(widget.controller?.text, contains('cdnjs'));
  });
}