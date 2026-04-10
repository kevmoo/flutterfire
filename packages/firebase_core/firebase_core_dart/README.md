# firebase_core_dart

A pure Dart shared core for Firebase plugins.

## Overview

This package is part of an initiative to "peel away" Flutter dependencies from the core Firebase logic in the FlutterFire repository. By move foundational data classes and exceptions into a pure Dart package, we enable:

1.  **Non-Flutter Usage**: Usage of Firebase logic in pure Dart environments (CLI, Server-side, pure Web).
2.  **Cleaner Architecture**: A clear separation between platform-agnostic data models and platform-specific Flutter implementations.
3.  **Code Sharing**: Shared logic between the existing Flutter plugins and future pure Dart SDKs.

## Current Progress

So far, the following has been migrated from `firebase_core_platform_interface` to `firebase_core_dart`:

- **`FirebaseException`**: Decoupled from `package:flutter` and `package:plugin_platform_interface`.
- **`FirebaseOptions`**: Decoupled from `package:flutter`.

### Architectural Pattern

To maintain backward compatibility with existing Flutter plugins while keeping this package pure Dart, we use **Extensions**:

- The core `FirebaseOptions` class lives here and contains only standard Dart types.
- Platform-specific logic (like `FirebaseOptions.fromPigeon`) is implemented as an `extension` within the `firebase_core_platform_interface` package.
- This allows Flutter-specific tools (like Pigeon) to continue working as they always have, while the core remains clean.

## Getting Started

This package is intended for internal use within the FlutterFire monorepo.

```yaml
dependencies:
  firebase_core_dart:
    path: ../firebase_core_dart
```
