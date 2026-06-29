import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_components/components_context_extension.dart';
import 'package:flutter_components/utilities/app_decoration.dart';

class ComponentDialogWidget extends StatelessWidget {
  const ComponentDialogWidget({
    super.key,
    this.height,
    this.icon,
    required this.title,
    this.description,
    this.content,
    required this.confirmText,
    required this.cancelText,
    this.isDestructive = false,
    this.showCancel = true,
    required this.onConfirm,
    required this.onCancel,
  });

  final double? height;
  final Widget? icon;
  final String title;
  final String? description;
  final Widget? content;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final bool showCancel;

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedSuperellipseBorder(
        borderRadius: AppDecoration.iOSModalBorderRadius,
      ),
      elevation: 8,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          height: height,
          width: context.isMobile ? null : 450,
          decoration: ShapeDecoration(
            color: context.isLightMode ? Colors.white : const Color.fromARGB(255, 27, 27, 27),
            shape: RoundedSuperellipseBorder(
              borderRadius: AppDecoration.iOSModalBorderRadius,
              side: BorderSide(
                color: context.borderColor,
              ),
            ),
          ),
          padding: EdgeInsets.all(context.defaultPadding + 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null)
                Row(
                  spacing: 20,
                  children: [
                    icon!,
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              const SizedBox(height: 24),
              if (description != null)
                Text(
                  description!,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ?content,
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: onConfirm,
                    style: ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      backgroundColor: WidgetStateProperty.all(
                        isDestructive ? Colors.red : Theme.of(context).primaryColor,
                      ),
                      fixedSize: WidgetStateProperty.all(
                        const Size(double.infinity, kIsWeb ? 54 : 50),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedSuperellipseBorder(
                          borderRadius: AppDecoration.borderRadiusStadium,
                        ),
                      ),
                    ),
                    child: Text(
                      confirmText,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (showCancel)
                    TextButton(
                      onPressed: onCancel,
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        backgroundColor: WidgetStateProperty.all(
                          context.isLightMode
                              ? Colors.grey.withValues(alpha: 0.15)
                              : const Color.fromARGB(255, 43, 42, 42),
                        ),
                        fixedSize: WidgetStateProperty.all(
                          const Size(double.infinity, kIsWeb ? 54 : 50),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedSuperellipseBorder(
                            borderRadius: AppDecoration.borderRadiusStadium,
                          ),
                        ),
                        overlayColor: WidgetStateProperty.all(
                          context.isLightMode
                              ? Colors.grey.withValues(alpha: 0.15)
                              : const Color.fromARGB(255, 43, 42, 42),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
