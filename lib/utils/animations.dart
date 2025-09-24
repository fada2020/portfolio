import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Convenience extension for slide + fade animations used across home sections.
extension AnimateExtensions on Widget {
  Widget fadeSlide({
    Duration duration = const Duration(milliseconds: 400),
    Duration delay = Duration.zero,
    Offset beginOffset = const Offset(0, 0.1),
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOutCubic)
        .slide(begin: beginOffset, end: Offset.zero, curve: Curves.easeOutCubic);
  }

  Widget fadeScale({
    Duration duration = const Duration(milliseconds: 450),
    Duration delay = Duration.zero,
    double beginScale = 0.96,
  }) {
    return animate(delay: delay)
        .fadeIn(duration: duration, curve: Curves.easeOutCubic)
        .scale(begin: Offset(beginScale, beginScale), end: const Offset(1, 1), curve: Curves.easeOutBack);
  }
}
