import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension ResponsiveX on BuildContext {
  bool get isMobile => ResponsiveBreakpoints.of(this).isMobile;
  bool get isTablet => ResponsiveBreakpoints.of(this).isTablet;
  bool get isDesktop => ResponsiveBreakpoints.of(this).isDesktop;

  /// Constrain readable content width by device class
  double get readableMaxWidth {
    if (isMobile) return 600; // single-column
    if (isTablet) return 900; // comfy reading width
    return 1100; // desktop article width
  }

  /// Spacing that scales with screen size
  double get pagePadding {
    if (isMobile) return 12;
    if (isTablet) return 16;
    return 24;
  }

  /// Tile/card density
  bool get denseTiles => isMobile;
}
