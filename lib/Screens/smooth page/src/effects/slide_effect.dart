import 'package:flutter/material.dart';
import 'package:Elivatme/Screens/smooth%20page/src/painters/indicator_painter.dart';
import 'package:Elivatme/Screens/smooth%20page/src/painters/slide_painter.dart';


import 'indicator_effect.dart';

/// Holds painting configuration to be used by [SlidePainter]
class SlideEffect extends BasicIndicatorEffect {
  /// The effect variant
  ///
  /// defaults to [SlideType.normal]
  final SlideType type;

  /// Default constructor
  const SlideEffect({
    super.activeDotColor = Colors.indigo,
    double offset = 16.0,
    super.dotWidth = 16.0,
    super.dotHeight = 16.0,
    super.spacing = 8.0,
    super.radius = 16,
    super.dotColor = Colors.grey,
    super.strokeWidth = 1.0,
    super.paintStyle = PaintingStyle.fill,
    this.type = SlideType.normal,
  });

  @override
  IndicatorPainter buildPainter(int count, double offset) {
    return SlidePainter(count: count, offset: offset, effect: this);
  }
}

/// The Slide effect variants
enum SlideType {
  /// Paints regular dot sliding animation
  normal,

  /// Paints masked (under-layered) dot sliding animation
  slideUnder
}
