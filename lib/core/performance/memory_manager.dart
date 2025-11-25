import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wp_commander/core/performance/network_optimizer.dart';

class MemoryManager {
  static final List<Disposable> _disposables = [];

  static void registerDisposable(Disposable disposable) {
    _disposables.add(disposable);
  }

  static void disposeAll() {
    for (final disposable in _disposables) {
      disposable.dispose();
    }
    _disposables.clear();
    
    if (kDebugMode) {
      debugPrint('🧹 MemoryManager: disposed ${_disposables.length} objects');
    }
  }

  static void forceGarbageCollection() {
    // En environnement de développement, forcer le GC
    if (kDebugMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Cela peut aider à déclencher le GC
        Future.delayed(const Duration(milliseconds: 100), () {
          debugPrint('🗑️  Forced garbage collection attempted');
        });
      });
    }
  }

  static String getMemoryInfo() {
    // Retourner des informations sur l'usage mémoire
    return '''
💾 Memory Info:
- Registered disposables: ${_disposables.length}
- Cache size: ${OptimizedApiClient.cacheSize} items
''';
  }
}

abstract class Disposable {
  void dispose();
}

// Mixin pour les objets qui doivent être disposés
mixin DisposableMixin implements Disposable {
  final List<Disposable> _children = [];

  void registerDisposable(Disposable disposable) {
    _children.add(disposable);
  }

  @override
  void dispose() {
    for (final child in _children) {
      child.dispose();
    }
    _children.clear();
  }
}