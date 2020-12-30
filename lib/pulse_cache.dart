import 'package:flutter_pulse/pulse.dart';

class PulseCache {
  final List<Pulse> _pulses = [];

  void addPulse(Pulse pulse) {
    _pulses.add(pulse);
  }

  void removePulse(Pulse pulse) {
    _pulses.remove(pulse);
  }

  Pulse<T> findPulse<T>(String key) {
    return _pulses.firstWhere(
      (p) => p.key == key,
      orElse: () => null,
    );
  }
}
