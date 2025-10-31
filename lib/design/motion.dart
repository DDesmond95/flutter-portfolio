// lib/design/motion.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_settings.dart';

class AppMotion {
  // Durations tuned for “calm” feel
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration small = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration large = Duration(milliseconds: 360);

  // Curves: faster in, slower out (natural feel)
  static const Curve easeEmphInOut = Curves.easeInOutCubicEmphasized;
  static const Curve ease = Curves.easeInOut;

  // Wrap any animation duration to zero if reduced motion is ON
  static Duration of(BuildContext context, Duration d) {
    final reduced = context.read<AppSettings?>()?.reducedMotion ?? false;
    return reduced ? Duration.zero : d;
  }

  // A simple fade-in builder you can reuse anywhere
  static Widget fadeIn(
    BuildContext context, {
    required Widget child,
    Duration? duration,
    Curve curve = easeEmphInOut,
    Key? key,
  }) {
    final d = of(context, duration ?? small);
    return _FadeIn(key: key, duration: d, curve: curve, child: child);
  }
}

class _FadeIn extends StatefulWidget {
  const _FadeIn({
    super.key,
    required this.duration,
    required this.curve,
    required this.child,
  });
  final Duration duration;
  final Curve curve;
  final Widget child;

  @override
  State<_FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<_FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..forward();
  late final Animation<double> _a = CurvedAnimation(
    parent: _c,
    curve: widget.curve,
  );

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _a, child: widget.child);
  }
}
