# Development Guidelines for Flutter JS Eval Inject

This document outlines the development standards, rules, and best practices for maintaining the `flutter_js_eval_inject` plugin.

## Code Quality Standards

### Dart Analyze Requirements

All code must pass `dart analyze` with **zero issues**:
- No errors
- No warnings  
- No info messages

#### Common Issues to Avoid

1. **Unused Declarations**
   - Remove any unused imports, variables, functions, or JS interop declarations
   - Example: Unused `@JS()` external declarations should be removed

2. **Production Code Practices**
   - Avoid using `print()` statements in production code
   - Use proper error handling with try-catch blocks
   - Prefer silent failures over console logging when appropriate

3. **Import Optimization**
   - Only import what you use
   - Remove unused import statements

### Cross-Platform Compatibility

#### Platform-Specific Implementation Rules

1. **Web Platform**
   - Use `dart:js_interop` for JavaScript interaction
   - Implement full functionality for web platform
   - Handle DOM manipulation safely

2. **Non-Web Platforms (iOS, Android, macOS, Linux, Windows)**
   - Provide no-op implementations that don't throw errors
   - Methods should complete successfully without actual functionality
   - Use stub classes extending the platform interface

#### Implementation Pattern

```dart
// Platform interface with default stub implementation
static FlutterJsEvalInjectPlatform _instance = FlutterJsEvalInjectStub();

// Stub class for non-web platforms
class FlutterJsEvalInjectStub extends FlutterJsEvalInjectPlatform {
  @override
  Future<void> methodName() async {
    // No-op implementation for non-web platforms
  }
}
```

## Flutter Plugin Development Guidelines

### Project Structure

```
lib/
├── flutter_js_eval_inject.dart              # Main API
├── flutter_js_eval_inject_platform_interface.dart  # Platform interface + stub
├── flutter_js_eval_inject_web.dart          # Web implementation
└── assets/
    └── js_bridge.js                         # JavaScript bridge
```

### Platform Interface Design

1. **Abstract Methods**: Define all public API methods in the platform interface
2. **Default Instance**: Provide a default stub instance to prevent initialization errors
3. **Token Verification**: Use `PlatformInterface.verifyToken()` for security

### Web Implementation Best Practices

1. **JS Interop Usage**
   - Use `@JS()` annotations for external JavaScript functions
   - Prefer `dart:js_interop` over legacy `dart:js`
   - Handle type conversions between Dart and JavaScript safely

2. **Error Handling**
   - Wrap JavaScript calls in try-catch blocks
   - Provide meaningful error messages
   - Handle edge cases gracefully

3. **Resource Management**
   - Clean up event listeners
   - Manage script element lifecycle
   - Initialize bridges only once

## Code Style Guidelines

### Naming Conventions

- Use descriptive names for variables and methods
- Follow Dart naming conventions (camelCase for variables, PascalCase for classes)
- Prefix private members with underscore (`_`)

### Documentation

- Add meaningful comments for complex logic
- Document public APIs with dartdoc comments
- Explain platform-specific behavior when relevant

### Error Messages

- Provide clear, actionable error messages
- Include context about what operation failed
- Avoid exposing internal implementation details

## Version Management

### Semantic Versioning

Follow semantic versioning (semver):
- **PATCH** (0.0.X): Bug fixes, code cleanup, dart analyze fixes
- **MINOR** (0.X.0): New features, platform support additions
- **MAJOR** (X.0.0): Breaking API changes

### Changelog Requirements

Document all changes in `CHANGELOG.md`:
- Use conventional commit format
- Group changes by type (feat, fix, refactor, etc.)
- Include migration notes for breaking changes

## Testing Requirements

### Analysis Checks

Before any commit:
1. Run `dart analyze` on root package - must pass with zero issues
2. Run `dart analyze` on example app - must pass with zero issues
3. Verify all platforms build successfully

### Example App Testing

The example app should:
- Demonstrate all plugin features
- Work on all supported platforms
- Handle errors gracefully
- Provide clear user feedback

## Commit Guidelines

### Conventional Commits

Use conventional commit format:
```
type(scope): description

feat: add new feature
fix: resolve bug
refactor: improve code structure
docs: update documentation
test: add or update tests
chore: maintenance tasks
```

### Commit Content

- Stage all related changes together
- Include version bumps when adding features
- Update CHANGELOG.md with every significant change
- Ensure commit messages are descriptive and clear

## Security Considerations

### JavaScript Injection Safety

1. **Input Validation**: Validate all JavaScript code inputs
2. **Sandboxing**: Consider execution context limitations
3. **XSS Prevention**: Be aware of cross-site scripting risks
4. **Error Information**: Don't expose sensitive data in error messages

### Package Security

- Don't include sensitive information in source code
- Review all external dependencies
- Keep dependencies up to date
- Follow Flutter security best practices

## Performance Guidelines

### Web Performance

1. **Lazy Loading**: Initialize JavaScript bridges only when needed
2. **Script Management**: Clean up unused script elements
3. **Memory Management**: Avoid memory leaks in long-running applications
4. **Bundle Size**: Minimize JavaScript payload

### Cross-Platform Performance

1. **No-op Efficiency**: Keep stub implementations lightweight
2. **Platform Detection**: Use Flutter's platform detection efficiently
3. **Resource Usage**: Minimize resource consumption on non-target platforms

## Maintenance Checklist

Before releasing any version:
- [ ] `dart analyze` passes on package (zero issues)
- [ ] `dart analyze` passes on example (zero issues)
- [ ] All platforms build successfully
- [ ] Example app works on target platforms
- [ ] Version updated in `pubspec.yaml`
- [ ] `CHANGELOG.md` updated
- [ ] Commit follows conventional format
- [ ] Documentation is up to date

---

*This document should be updated as the project evolves and new requirements emerge.*