typedef PulseListener<T> = void Function(T value);
typedef PulseSource<T> = Future<T> Function();

class Pulse<T> {
  final List<PulseListener<T>> listeners = [];

  T get latestValue => _latestValue;
  String get key => _key;

  final PulseSource<T> _source;
  final String _key;
  T _latestValue;

  Pulse(this._key, this._source);

  Future<T> hydrate() {
    return _source().then((value) {
      listeners.forEach((listener) {
        _latestValue = value;
        listener(value);
      });
      return value;
    });
  }

  void addListener(PulseListener<T> listener) {
    listeners.add(listener);
  }

  void removeListener(PulseListener<T> listener) {
    listeners.remove(listener);
  }
}
