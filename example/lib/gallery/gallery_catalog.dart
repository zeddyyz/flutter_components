import 'package:example/demos/activity_indicator_demo.dart';
import 'package:example/demos/adaptive_navigation_demo.dart';
import 'package:example/demos/avatar_demo.dart';
import 'package:example/demos/badge_demo.dart';
import 'package:example/demos/blur_widget_demo.dart';
import 'package:example/demos/blurred_app_bar_demo.dart';
import 'package:example/demos/bottom_nav_demo.dart';
import 'package:example/demos/buttons_demo.dart';
import 'package:example/demos/calendar_demo.dart';
import 'package:example/demos/controls_demo.dart';
import 'package:example/demos/date_picker_demo.dart';
import 'package:example/demos/empty_state_demo.dart';
import 'package:example/demos/large_title_app_bar_demo.dart';
import 'package:example/demos/list_section_demo.dart';
import 'package:example/demos/onboarding_demo.dart';
import 'package:example/demos/overlays_demo.dart';
import 'package:example/demos/patterns_demo.dart';
import 'package:example/demos/pickers_demo.dart';
import 'package:example/demos/progress_demo.dart';
import 'package:example/demos/responsive_demo.dart';
import 'package:example/demos/search_field_demo.dart';
import 'package:example/demos/segmented_control_demo.dart';
import 'package:example/demos/selection_card_demo.dart';
import 'package:example/demos/skeleton_demo.dart';
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
          subtitle: 'Filled, outlined, danger, light, icon, loading',
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
        GalleryEntry(
          id: 'search-field',
          title: 'Search field',
          subtitle: 'Clear, cancel, optional debounce',
          icon: Icons.search_rounded,
          page: (_) => const SearchFieldDemoPage(),
        ),
        GalleryEntry(
          id: 'selection-card',
          title: 'Selection card',
          subtitle: 'Single, multi, and on/off choices',
          icon: Icons.check_circle_outline_rounded,
          page: (_) => const SelectionCardDemoPage(),
        ),
        GalleryEntry(
          id: 'segmented-control',
          title: 'Segmented control',
          subtitle: 'Equal-width sliding thumb',
          icon: Icons.view_week_rounded,
          page: (_) => const SegmentedControlDemoPage(),
        ),
        GalleryEntry(
          id: 'controls',
          title: 'Controls',
          subtitle: 'Stepper, slider, select, accordion',
          icon: Icons.tune_rounded,
          page: (_) => const ControlsDemoPage(),
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
        GalleryEntry(
          id: 'list-section',
          title: 'List section',
          subtitle: 'Grouped list with switch and checkbox rows',
          icon: Icons.list_alt_rounded,
          page: (_) => const ListSectionDemoPage(),
        ),
        GalleryEntry(
          id: 'avatar',
          title: 'Avatar',
          subtitle: 'Initials and stacked groups',
          icon: Icons.account_circle_outlined,
          page: (_) => const AvatarDemoPage(),
        ),
        GalleryEntry(
          id: 'badge',
          title: 'Badge',
          subtitle: 'Count and notification dot',
          icon: Icons.notifications_outlined,
          page: (_) => const BadgeDemoPage(),
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
        GalleryEntry(
          id: 'adaptive-nav',
          title: 'Adaptive navigation',
          subtitle: 'Bottom bar on phones, sidebar on large screens',
          icon: Icons.view_sidebar_outlined,
          page: (_) => const AdaptiveNavigationDemoPage(),
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
        GalleryEntry(
          id: 'patterns',
          title: 'Sheets & menus',
          subtitle: 'Action sheet, context menu, OTP, refresh',
          icon: Icons.more_horiz_rounded,
          page: (_) => const PatternsDemoPage(),
        ),
      ],
    ),
    GallerySection(
      title: 'Feedback',
      entries: [
        GalleryEntry(
          id: 'empty-state',
          title: 'Empty state',
          subtitle: 'Placeholder and error with retry',
          icon: Icons.inbox_outlined,
          page: (_) => const EmptyStateDemoPage(),
        ),
        GalleryEntry(
          id: 'skeleton',
          title: 'Skeleton',
          subtitle: 'Shimmer placeholders',
          icon: Icons.preview_outlined,
          page: (_) => const SkeletonDemoPage(),
        ),
        GalleryEntry(
          id: 'activity-indicator',
          title: 'Activity indicator',
          subtitle: 'Spinning progress mark',
          icon: Icons.sync_rounded,
          page: (_) => const ActivityIndicatorDemoPage(),
        ),
        GalleryEntry(
          id: 'progress',
          title: 'Progress',
          subtitle: 'Bar, ring, and page dots',
          icon: Icons.pie_chart_outline_rounded,
          page: (_) => const ProgressDemoPage(),
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
          subtitle: 'Month pager with year and month grids',
          icon: Icons.event_available_rounded,
          page: (_) => const DatePickerDemoPage(),
        ),
        GalleryEntry(
          id: 'pickers',
          title: 'Date, time, range',
          subtitle: 'Field, clock, and range sheet',
          icon: Icons.schedule_rounded,
          page: (_) => const PickersDemoPage(),
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
