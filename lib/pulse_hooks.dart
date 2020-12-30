import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pulse/pulse.dart';
import 'package:flutter_pulse/pulse_cache.dart';
import 'package:provider/provider.dart';

class _PulseHook<T> extends Hook<AsyncSnapshot<T>> {
  final String key;
  final PulseSource<T> source;
  final PulseCache cache;

  _PulseHook(
    this.key,
    this.cache, [
    this.source,
  ]);

  @override
  HookState<AsyncSnapshot<T>, Hook<AsyncSnapshot<T>>> createState() =>
      _PulseHookState<T>();
}

class _PulseHookState<T> extends HookState<AsyncSnapshot<T>, _PulseHook<T>> {
  AsyncSnapshot<T> latestValue;
  Function _dispose;

  @override
  void initHook() {
    final cache = hook.cache;

    // Find and create step
    var targetPulse = cache.findPulse(hook.key);
    if (hook.source != null && targetPulse == null) {
      targetPulse = Pulse<T>(hook.key, hook.source);
      cache.addPulse(targetPulse);
    }

    latestValue = targetPulse.latestValue;

    final subscription = targetPulse.listen(_listener);
    _dispose = subscription.cancel;

    targetPulse.hydrate();
  }

  @override
  void dispose() {
    if (_dispose != null) {
      _dispose();
    }

    super.dispose();
  }

  @override
  AsyncSnapshot<T> build(BuildContext context) => latestValue;

  void _listener(AsyncSnapshot<T> value) {
    setState(() => latestValue = value);
  }
}

AsyncSnapshot<T> usePulse<T>(String key, [PulseSource<T> source]) {
  final cache = Provider.of<PulseCache>(useContext());
  return use(_PulseHook<T>(key, cache, source));
}
