import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pulse/pulse.dart';
import 'package:flutter_pulse/pulse_cache.dart';
import 'package:provider/provider.dart';

class _PulseHook<T> extends Hook<T> {
  final String key;
  final PulseSource<T> source;
  final PulseCache cache;

  _PulseHook(
    this.key,
    this.cache, [
    this.source,
  ]);

  @override
  HookState<T, Hook<T>> createState() => _PulseHookState<T>();
}

class _PulseHookState<T> extends HookState<T, _PulseHook<T>> {
  T latestValue;

  @override
  void initHook() {
    final cache = hook.cache;

    // Find and create step
    var targetPulse = cache.findPulse(hook.key);
    if (hook.source != null && targetPulse == null) {
      targetPulse = Pulse<T>(hook.key, hook.source);
      cache.addPulse(targetPulse);
    }

    targetPulse.addListener(_listener);
  }

  @override
  void dispose() {
    final cache = hook.cache;
    final targetPulse = cache.findPulse(hook.key);
    targetPulse.removeListener(_listener);
    super.dispose();
  }

  @override
  T build(BuildContext context) => latestValue;

  void _listener(T value) {
    setState(() => latestValue = value);
  }
}

T usePulse<T>(String key, [PulseSource<T> source]) {
  final cache = Provider.of<PulseCache>(useContext());
  return use(_PulseHook<T>(key, cache, source));
}
