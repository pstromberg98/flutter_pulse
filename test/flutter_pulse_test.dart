import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_pulse/pulse.dart';
import 'package:flutter_pulse/pulse_cache.dart';
import 'package:flutter_pulse/pulse_hooks.dart';
import 'package:flutter_pulse/pulse_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_pulse/flutter_pulse.dart';

void main() {
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

    pulse.listen((snapshot) {
      if (snapshot.hasData) {
        expect(snapshot.data, 'Hello');
      }
    });

    pulse.listen((snapshot) {
      if (snapshot.hasData) {
        expect(snapshot.data, 'Hello');
      }
    });

    await pulse.hydrate();
  });

  test('Create a pulse cache', () async {
    final pulseCache = PulseCache();
    final pulse = Pulse('name', () => Future.value('Parker'));

    pulseCache.addPulse(pulse);
    pulseCache.findPulse<String>('name').listen((snapshot) {
      if (snapshot.hasData) {
        expect(snapshot.data, 'Parker');
      }
    });

    await pulse.hydrate();
  });

  testWidgets('Pulse hook', (tester) async {
    await tester.pumpFrames(
      PulseCacheProvider(
        child: HookBuilder(
          builder: (ctx) {
            final nameSnapshot = usePulse(
              'name',
              () => Future.delayed(Duration(milliseconds: 100))
                  .then((_) => 'Parker'),
            );
            print(nameSnapshot.connectionState.toString());
            return Container();
          },
        ),
      ),
      Duration(milliseconds: 400),
    );
  });
}
