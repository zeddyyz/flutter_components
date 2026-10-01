import 'package:material_ui/material_ui.dart';
import 'package:flutter_components/components_context_extension.dart';

class AppDecoration {
  static const spaceZero = EdgeInsets.zero;

  static const borderRadiusSm = BorderRadius.all(Radius.circular(9));
  static const borderRadiusMd = BorderRadius.all(Radius.circular(13));
  static const borderRadiusLg = BorderRadius.all(Radius.circular(16));
  static const borderRadiusXl = BorderRadius.all(Radius.circular(20));
  static const borderRadius2xl = BorderRadius.all(Radius.circular(24));
  static const borderRadiusCard = BorderRadius.all(Radius.circular(24));
  static const borderRadiusStadium = BorderRadius.all(Radius.circular(40));
  static const iOSModalBorderRadius = BorderRadius.all(Radius.circular(32));

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
