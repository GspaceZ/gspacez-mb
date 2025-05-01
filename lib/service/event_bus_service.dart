import 'dart:async';

class KeyedEventBus {
  // Singleton instance
  static final KeyedEventBus _instance = KeyedEventBus._internal();

  factory KeyedEventBus() => _instance;

  KeyedEventBus._internal();

  final Map<String, List<StreamController<dynamic>>> _controllers = {};

  void sink(String key, dynamic value) {
    if (_controllers.containsKey(key)) {
      for (var controller in _controllers[key]!) {
        if (!controller.isClosed) {
          controller.add(value);
        }
      }
    }
  }

  Stream<T> listener<T>(String key) {
    final controller = StreamController<T>.broadcast();
    _controllers.putIfAbsent(key, () => []).add(controller);
    return controller.stream;
  }

  void disposeKey(String key) {
    if (_controllers.containsKey(key)) {
      for (var controller in _controllers[key]!) {
        controller.close();
      }
      _controllers.remove(key);
    }
  }

  void disposeAll() {
    for (var controllers in _controllers.values) {
      for (var controller in controllers) {
        controller.close();
      }
    }
    _controllers.clear();
  }
}
