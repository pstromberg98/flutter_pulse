import 'package:flutter/cupertino.dart';
import 'package:flutter_pulse/pulse_cache.dart';
import 'package:provider/provider.dart';

class PulseCacheProvider extends StatelessWidget {
  final Widget child;
  PulseCacheProvider({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (ctx) => PulseCache(),
      child: child,
    );
  }
}
