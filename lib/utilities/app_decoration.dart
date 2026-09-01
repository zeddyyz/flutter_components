import 'package:material_ui/material_ui.dart';
import 'package:flutter_components/components_context_extension.dart';

class AppDecoration {
  static const spaceZero = EdgeInsets.zero;

  static var borderRadiusSm = BorderRadius.circular(9);
  static var borderRadiusMd = BorderRadius.circular(13);
  static var borderRadiusLg = BorderRadius.circular(16);
  static var borderRadiusXl = BorderRadius.circular(20);
  static var borderRadius2xl = BorderRadius.circular(24);
  static var borderRadiusCard = BorderRadius.circular(24);
  static var borderRadiusStadium = BorderRadius.circular(40);
  static var iOSModalBorderRadius = BorderRadius.circular(32);

  static const radiusSm = Radius.circular(9);
  static const radiusMd = Radius.circular(13);
  static const radiusLg = Radius.circular(16);
  static const radiusXl = Radius.circular(20);
  static const radius2xl = Radius.circular(24);
  static const radiusCard = Radius.circular(24);
  static const radiusStadium = Radius.circular(40);
  static const iOSModalRadius = Radius.circular(32);

  static AnimationStyle get smoothSheetAnimationStyle => const AnimationStyle(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeIn,
    reverseDuration: Duration(milliseconds: 300),
    reverseCurve: Curves.fastEaseInToSlowEaseOut,
  );

  /// Determines the number of columns for masonry grid based on screen width
  static int getMasonryGridColumnCount(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;

    // For mobile, use 1 column
    if (context.isMobile) return 1;

    // For tablets, adapt based on width
    if (width < 800) return 1;
    if (width < 1200) return 2;
    return 3; // For very large screens
  }
}
