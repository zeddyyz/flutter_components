import 'package:example/gallery/gallery_home.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  static ExampleAppState of(BuildContext context) {
    final ExampleAppState? state = context.findAncestorStateOfType<ExampleAppState>();
    assert(state != null, 'ExampleApp.of() called outside ExampleApp');
    return state!;
  }

  @override
  State<ExampleApp> createState() => ExampleAppState();
}

class ExampleAppState extends State<ExampleApp> {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    final bool isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    setState(() => themeMode = isDark ? ThemeMode.light : ThemeMode.dark);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Components',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme(
        context: context,
        primaryColor: Colors.black,
        secondaryColor: Colors.grey,
      ),
      darkTheme: AppThemeData.darkTheme(
        context: context,
        primaryColor: Colors.white,
        secondaryColor: Colors.grey,
      ),
      themeMode: themeMode,
      builder: (BuildContext context, Widget? child) {
        return ComponentNestedScrollViewConfig(child: child!);
      },
      home: const _AlertSnackbarHost(child: GalleryHome()),
    );
  }
}

/// Binds [AlertSnackbar] to the navigator overlay from a route that stays mounted.
class _AlertSnackbarHost extends StatefulWidget {
  const _AlertSnackbarHost({required this.child});

  final Widget child;

  @override
  State<_AlertSnackbarHost> createState() => _AlertSnackbarHostState();
}

class _AlertSnackbarHostState extends State<_AlertSnackbarHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        AlertSnackbar.init(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
