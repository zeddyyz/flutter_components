import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

/// Product mark that adds the wordmark when the rail is extended.
class NavigationRailDemoHeader extends StatelessWidget {
  const NavigationRailDemoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isExtended = ComponentNavigationRailScope.isExtendedOf(context);
    final Widget mark = const _ProductMark();

    if (!isExtended) {
      return mark;
    }

    return Row(
      children: [
        mark,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            'Components',
            style: context.body2Bold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Account row that collapses to an avatar on the compact rail.
class NavigationRailDemoFooter extends StatelessWidget {
  const NavigationRailDemoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isExtended = ComponentNavigationRailScope.isExtendedOf(context);
    const Widget avatar = ComponentAvatar(initials: 'Ada Lovelace', size: 32);

    if (!isExtended) {
      return avatar;
    }

    return Row(
      children: [
        avatar,
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ada Lovelace',
                style: context.bodyHeavy,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'ada@example.com',
                style: context.labelMedium.copyWith(color: context.hintIntense),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductMark extends StatelessWidget {
  const _ProductMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: context.primary,
        shape: const RoundedSuperellipseBorder(
          borderRadius: AppDecoration.borderRadiusSm,
        ),
      ),
      child: Text(
        'C',
        style: context.body2Bold.copyWith(color: context.primaryInverse),
      ),
    );
  }
}
