import 'package:flutter/material.dart';
import 'package:flutter_js_eval_inject/flutter_js_eval_inject.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter JS Eval Inject Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter JS Eval Inject Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _output = '';
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _fileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _codeController.text = '''
// Example JavaScript code
function greet(name) {
  return "Hello, " + name + "!";
}
greet("Flutter");
''';
    _fileController.text = 'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js';
  }

  Future<void> _addJavascriptCode() async {
    try {
      await FlutterJsEvalInject.addJavascriptCode(_codeController.text);
      setState(() {
        _output = 'JavaScript code added successfully!';
      });
    } catch (e) {
      setState(() {
        _output = 'Error adding JavaScript code: $e';
      });
    }
  }

  Future<void> _addJavascriptFile() async {
    try {
      await FlutterJsEvalInject.addJavascriptFile(_fileController.text);
      setState(() {
        _output = 'JavaScript file loaded successfully!';
      });
    } catch (e) {
      setState(() {
        _output = 'Error loading JavaScript file: $e';
      });
    }
  }

  Future<void> _evalJavascript() async {
    try {
      final result = await FlutterJsEvalInject.evalJavascript(_codeController.text);
      setState(() {
        _output = 'Result: $result';
      });
    } catch (e) {
      setState(() {
        _output = 'Error evaluating JavaScript: $e';
      });
    }
  }

  Future<void> _testLodash() async {
    try {
      await FlutterJsEvalInject.addJavascriptFile('https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final result = await FlutterJsEvalInject.evalJavascript('''
        _.map([1, 2, 3, 4], function(n) {
          return n * n;
        })
      ''');
      
      setState(() {
        _output = 'Lodash test result: $result';
      });
    } catch (e) {
      setState(() {
        _output = 'Error testing Lodash: $e';
      });
    }
  }

  Future<void> _testComplexEval() async {
    try {
      await FlutterJsEvalInject.addJavascriptCode('''
        window.myCustomAPI = {
          calculate: function(a, b) {
            return {
              sum: a + b,
              product: a * b,
              difference: a - b,
              quotient: a / b
            };
          },
          greet: function(name) {
            return "Welcome, " + name + "!";
          },
          getArray: function() {
            return [1, 2, 3, 4, 5];
          }
        };
      ''');
      
      final result = await FlutterJsEvalInject.evalJavascript('window.myCustomAPI.calculate(10, 5)');
      
      setState(() {
        _output = 'Complex eval result: $result';
      });
    } catch (e) {
      setState(() {
        _output = 'Error in complex eval: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'JavaScript Code:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              maxLines: 6,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter JavaScript code here',
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'JavaScript File URL:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _fileController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter JavaScript file URL',
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: _addJavascriptCode,
                  child: const Text('Add JS Code'),
                ),
                ElevatedButton(
                  onPressed: _addJavascriptFile,
                  child: const Text('Load JS File'),
                ),
                ElevatedButton(
                  onPressed: _evalJavascript,
                  child: const Text('Eval JS'),
                ),
                ElevatedButton(
                  onPressed: _testLodash,
                  child: const Text('Test Lodash'),
                ),
                ElevatedButton(
                  onPressed: _testComplexEval,
                  child: const Text('Test Complex'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Output:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              constraints: const BoxConstraints(minHeight: 100),
              child: SelectableText(
                _output.isEmpty ? 'Results will appear here...' : _output,
                style: TextStyle(
                  fontFamily: 'monospace',
                  color: _output.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    _fileController.dispose();
    super.dispose();
  }
}