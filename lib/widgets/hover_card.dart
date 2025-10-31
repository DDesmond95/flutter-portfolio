import 'package:flutter/material.dart';
import '../design/motion.dart';

class HoverCard extends StatefulWidget {
  const HoverCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final duration = AppMotion.of(context, AppMotion.micro);

    return FocusableActionDetector(
      onShowHoverHighlight: (h) => setState(() => _hover = h),
      child: AnimatedContainer(
        duration: duration,
        curve: AppMotion.easeEmphInOut,
        transform: _hover
            ? (Matrix4.identity()..translateByDouble(0.0, -2.0, 0.0, 0.0))
            : Matrix4.identity(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: _hover
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
          // Optional: use surface color to match theme cards
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
  }
}
