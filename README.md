# Flutter JS Eval Inject

[![Flutter Tests](https://github.com/evaisse/flutter_js_eval_inject/actions/workflows/test.yml/badge.svg)](https://github.com/evaisse/flutter_js_eval_inject/actions/workflows/test.yml)
[![Code Coverage](https://github.com/evaisse/flutter_js_eval_inject/actions/workflows/coverage.yml/badge.svg)](https://github.com/evaisse/flutter_js_eval_inject/actions/workflows/coverage.yml)
[![pub package](https://img.shields.io/pub/v/flutter_js_eval_inject.svg)](https://pub.dev/packages/flutter_js_eval_inject)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A hassle-free Flutter plugin that allows you to inject and evaluate JavaScript code directly from Dart without any configuration. Perfect for web applications that need to interact with JavaScript libraries or execute dynamic JavaScript code.

## Features

- 🚀 **Zero Configuration**: Works out of the box, no setup required
- 📦 **Load External Libraries**: Easily load JavaScript files from URLs
- 💉 **Code Injection**: Inject JavaScript code directly into your web page
- 🔄 **Evaluate JavaScript**: Execute JavaScript and get results back in Dart
- 🎯 **Type Conversion**: Automatic conversion between JavaScript and Dart types
- ⚡ **Async/Await Support**: Clean async API with Future support
- 🛡️ **Error Handling**: Proper exception handling with meaningful error messages

## Getting Started

### Installation

Add `flutter_js_eval_inject` to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_js_eval_inject: ^0.0.1
```

### Platform Support

| Platform | Status |
|----------|--------|
| Web      | ✅     |
| Android  | ❌     |
| iOS      | ❌     |
| Desktop  | ❌     |

This plugin is currently designed for Flutter Web applications only.

## Usage

### Import the Package

```dart
import 'package:flutter_js_eval_inject/flutter_js_eval_inject.dart';
```

### Basic Examples

#### 1. Evaluate Simple JavaScript

```dart
final result = await FlutterJsEvalInject.evalJavascript('2 + 2');
print(result); // 4
```

#### 2. Add JavaScript Code

```dart
await FlutterJsEvalInject.addJavascriptCode('''
  function greet(name) {
    return "Hello, " + name + "!";
  }
''');

final greeting = await FlutterJsEvalInject.evalJavascript('greet("Flutter")');
print(greeting); // Hello, Flutter!
```

#### 3. Load External JavaScript Libraries

```dart
// Load Lodash library
await FlutterJsEvalInject.addJavascriptFile(
  'https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.21/lodash.min.js'
);

// Use Lodash functions
final result = await FlutterJsEvalInject.evalJavascript('''
  _.map([1, 2, 3, 4], function(n) {
    return n * n;
  })
''');
print(result); // [1, 4, 9, 16]
```

#### 4. Create Custom JavaScript APIs

```dart
await FlutterJsEvalInject.addJavascriptCode('''
  window.myAPI = {
    calculate: function(a, b) {
      return {
        sum: a + b,
        product: a * b,
        difference: a - b,
        quotient: a / b
      };
    },
    getData: function() {
      return [1, 2, 3, 4, 5];
    }
  };
''');

final result = await FlutterJsEvalInject.evalJavascript('myAPI.calculate(10, 5)');
print(result); // {sum: 15, product: 50, difference: 5, quotient: 2}
```

### Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_js_eval_inject/flutter_js_eval_inject.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String output = '';

  Future<void> runJavaScript() async {
    try {
      // Add custom JavaScript function
      await FlutterJsEvalInject.addJavascriptCode('''
        function fibonacci(n) {
          if (n <= 1) return n;
          return fibonacci(n - 1) + fibonacci(n - 2);
        }
      ''');
      
      // Calculate Fibonacci number
      final result = await FlutterJsEvalInject.evalJavascript('fibonacci(10)');
      
      setState(() {
        output = 'Fibonacci(10) = $result';
      });
    } catch (e) {
      setState(() {
        output = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('JS Eval Inject Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: runJavaScript,
                child: Text('Run JavaScript'),
              ),
              SizedBox(height: 20),
              Text(output),
            ],
          ),
        ),
      ),
    );
  }
}
```

## API Reference

### Methods

#### `addJavascriptFile(String filePath)`

Loads a JavaScript file from a URL or path.

```dart
Future<void> addJavascriptFile(String filePath)
```

**Parameters:**
- `filePath`: URL or path to the JavaScript file

**Returns:** `Future<void>` that completes when the file is loaded

#### `addJavascriptCode(String code)`

Injects JavaScript code directly into the page.

```dart
Future<void> addJavascriptCode(String code)
```

**Parameters:**
- `code`: JavaScript code to inject

**Returns:** `Future<void>` that completes when the code is injected

#### `evalJavascript(String codeToEval)`

Evaluates JavaScript code and returns the result.

```dart
Future<dynamic> evalJavascript(String codeToEval)
```

**Parameters:**
- `codeToEval`: JavaScript expression or code to evaluate

**Returns:** `Future<dynamic>` with the evaluation result

### Type Conversion

The plugin automatically converts between JavaScript and Dart types:

| JavaScript Type | Dart Type |
|----------------|-----------|
| Number         | num       |
| String         | String    |
| Boolean        | bool      |
| Array          | List      |
| Object         | Map       |
| null           | null      |
| undefined      | null      |

## Error Handling

All methods throw exceptions on failure. Always wrap calls in try-catch blocks:

```dart
try {
  final result = await FlutterJsEvalInject.evalJavascript('someCode()');
} catch (e) {
  print('JavaScript error: $e');
}
```

## Example Application

Check out the `/example` folder for a complete demo application showing all features:

```bash
cd example
flutter run -d chrome
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this plugin helpful, please give it a ⭐ on [GitHub](https://github.com/evaisse/flutter_js_eval_inject)!

For issues and feature requests, please [create an issue](https://github.com/evaisse/flutter_js_eval_inject/issues).

## Acknowledgments

- Flutter team for the amazing framework
- Contributors and users of this plugin