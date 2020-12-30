import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pulse/pulse.dart';
import 'package:flutter_pulse/pulse_cache.dart';
import 'package:flutter_pulse/pulse_hooks.dart';
import 'package:flutter_pulse/pulse_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pulse/flutter_pulse.dart';

void main() {
  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  test('Create a pulse', () async {
    final pulse = Pulse<String>(
      'delayed-hello',
      () => Future.delayed(
        Duration(milliseconds: 300),
      ).then(
        (value) {
          return 'Hello';
        },
      ),
    );

    pulse.addListener((value) {
      expect(value, 'Hello');
    });

    pulse.addListener((value) {
      expect(value, 'Hello');
    });

    await pulse.hydrate();
  });

  test('Create a pulse cache', () async {
    final pulseCache = PulseCache();
    final pulse = Pulse('name', () => Future.value('Parker'));

    pulseCache.addPulse(pulse);
    pulseCache.findPulse<String>('name').addListener((value) {
      expect(value, 'Parker');
    });

    await pulse.hydrate();
  });

  testWidgets('Pulse hook', (tester) async {
    tester.pumpWidget(
      PulseCacheProvider(
        child: HookBuilder(
          builder: (ctx) {
            final name = usePulse('name', () => Future.value('Parker'));
            return Container();
          },
        ),
      ),
    );
  });
}
