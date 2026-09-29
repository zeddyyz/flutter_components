import 'package:example/demos/blur_widget_demo.dart';
import 'package:example/demos/blurred_app_bar_demo.dart';
import 'package:example/demos/bottom_nav_demo.dart';
import 'package:example/demos/buttons_demo.dart';
import 'package:example/demos/calendar_demo.dart';
import 'package:example/demos/date_picker_demo.dart';
import 'package:example/demos/large_title_app_bar_demo.dart';
import 'package:example/demos/onboarding_demo.dart';
import 'package:example/demos/overlays_demo.dart';
import 'package:example/demos/responsive_demo.dart';
import 'package:example/demos/sliver_app_bar_demo.dart';
import 'package:example/demos/surfaces_demo.dart';
import 'package:example/demos/tab_bar_demo.dart';
import 'package:example/demos/text_field_demo.dart';
import 'package:material_ui/material_ui.dart';

class GalleryEntry {
  const GalleryEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder page;
}

class GallerySection {
  const GallerySection({required this.title, required this.entries});

  final String title;
  final List<GalleryEntry> entries;
}

List<GallerySection> gallerySections() {
  return [
    GallerySection(
      title: 'Actions',
      entries: [
        GalleryEntry(
          id: 'buttons',
          title: 'Buttons',
          subtitle: 'Filled, outlined, danger, light, back, close',
          icon: Icons.smart_button_rounded,
          page: (_) => const ButtonsDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Inputs',
      entries: [
        GalleryEntry(
          id: 'text-field',
          title: 'Text field',
          subtitle: 'Icons, fill, error, multiline',
          icon: Icons.short_text_rounded,
          page: (_) => const TextFieldDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Surfaces',
      entries: [
        GalleryEntry(
          id: 'surfaces',
          title: 'Cards & tiles',
          subtitle: 'Card, list tile, pill, filter chip',
          icon: Icons.layers_rounded,
          page: (_) => const SurfacesDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Navigation',
      entries: [
        GalleryEntry(
          id: 'tab-bar',
          title: 'Tab bar',
          subtitle: 'Segmented tabs with optional blur',
          icon: Icons.tab_rounded,
          page: (_) => const TabBarDemoPage(),
        ),
        GalleryEntry(
          id: 'bottom-nav',
          title: 'Bottom nav',
          subtitle: 'Blurred island bar over scrolling content',
          icon: Icons.space_dashboard_rounded,
          page: (_) => const BottomNavDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'App bars',
      entries: [
        GalleryEntry(
          id: 'blurred-app-bar',
          title: 'Blurred app bar',
          subtitle: 'Content fades under a blurred toolbar',
          icon: Icons.web_asset_rounded,
          page: (_) => const BlurredAppBarDemoPage(),
        ),
        GalleryEntry(
          id: 'sliver-app-bar',
          title: 'Sliver blurred app bar',
          subtitle: 'Pinned header in a CustomScrollView',
          icon: Icons.view_agenda_rounded,
          page: (_) => const SliverAppBarDemoPage(),
        ),
        GalleryEntry(
          id: 'large-title',
          title: 'Large title app bar',
          subtitle: 'iOS-style title that collapses on scroll',
          icon: Icons.title_rounded,
          page: (_) => const LargeTitleAppBarDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Overlays',
      entries: [
        GalleryEntry(
          id: 'overlays',
          title: 'Modals & alerts',
          subtitle: 'Sheet, dialog, snackbar, full screen',
          icon: Icons.filter_none_rounded,
          page: (_) => const OverlaysDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Date',
      entries: [
        GalleryEntry(
          id: 'calendar',
          title: 'Calendar',
          subtitle: 'Month grid with range highlight',
          icon: Icons.calendar_month_rounded,
          page: (_) => const CalendarDemoPage(),
        ),
        GalleryEntry(
          id: 'date-picker',
          title: 'Date picker',
          subtitle: 'Month pager with confirm / cancel',
          icon: Icons.event_available_rounded,
          page: (_) => const DatePickerDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Layout',
      entries: [
        GalleryEntry(
          id: 'responsive',
          title: 'Responsive widget',
          subtitle: 'Mobile, medium, large, extra-large',
          icon: Icons.devices_rounded,
          page: (_) => const ResponsiveDemoPage(),
        ),
        GalleryEntry(
          id: 'onboarding',
          title: 'Onboarding carousel',
          subtitle: 'Paged intro with next / done',
          icon: Icons.view_carousel_rounded,
          page: (_) => const OnboardingDemoPage(),
        ),
        GalleryEntry(
          id: 'blur-widget',
          title: 'Blurred widget',
          subtitle: 'Soft-edged backdrop blur over content',
          icon: Icons.blur_on_rounded,
          page: (_) => const BlurWidgetDemoPage(),
        ),
      ],
    ),
  ];
}
