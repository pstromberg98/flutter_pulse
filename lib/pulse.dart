import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

typedef PulseListener<T> = void Function(AsyncSnapshot<T> value);
typedef PulseSource<T> = Future<T> Function();

class Pulse<T> {
  String get key => _key;
  AsyncSnapshot<T> get latestValue => _stateStream.value;

  final PulseSource<T> _source;
  final String _key;

  final BehaviorSubject<AsyncSnapshot<T>> _stateStream =
      BehaviorSubject.seeded(AsyncSnapshot.nothing());

  Pulse(this._key, this._source);

  Future<T> hydrate() {
    _stateStream.add(AsyncSnapshot.waiting());
    return _source().then((value) {
      // If source fetch succeed
      _stateStream.add(AsyncSnapshot.withData(
        ConnectionState.active,
        value,
      ));
      return value;
    }).catchError((err) {
      // If source fetch fails
      _stateStream.add(AsyncSnapshot.withError(
        ConnectionState.done,
        err,
      ));
    });
  }

  StreamSubscription listen(PulseListener<T> listener) {
    return _stateStream.listen(listener);
  }
}
