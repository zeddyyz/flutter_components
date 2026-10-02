import 'package:flutter_components/components_context_extension.dart';
import 'package:material_ui/material_ui.dart';

class ComponentAvatar extends StatelessWidget {
  const ComponentAvatar({
    super.key,
    this.image,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.foregroundColor,
  });

  final ImageProvider? image;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  String get _resolvedInitials {
    final String raw = initials?.trim() ?? '';
    if (raw.isEmpty) return '';
    final List<String> parts = raw.split(RegExp(r'\s+')).where((part) => part.isNotEmpty).toList();
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final Color background = backgroundColor ?? context.componentTheme.chipColor;
    final Color foreground = foregroundColor ?? context.primary;

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        color: background,
        image: image == null ? null : DecorationImage(image: image!, fit: BoxFit.cover),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(size / 2),
        ),
      ),
      alignment: Alignment.center,
      child: image != null
          ? null
          : Text(
              _resolvedInitials,
              style: context.bodyHeavy.copyWith(
                color: foreground,
                fontSize: size * 0.36,
              ),
            ),
    );
  }
}

class ComponentAvatarGroup extends StatelessWidget {
  const ComponentAvatarGroup({
    super.key,
    required this.avatars,
    this.max = 3,
    this.size = 36,
    this.overlap = 12,
  });

  final List<ComponentAvatar> avatars;
  final int max;
  final double size;
  final double overlap;

  @override
  Widget build(BuildContext context) {
    final List<ComponentAvatar> visible = avatars.take(max).toList();
    final int overflow = avatars.length - visible.length;
    final int count = visible.length + (overflow > 0 ? 1 : 0);

    return SizedBox(
      width: size + (count - 1) * (size - overlap),
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < visible.length; i++)
            Positioned(
              left: i * (size - overlap),
              child: ComponentAvatar(
                image: visible[i].image,
                initials: visible[i].initials,
                size: size,
                backgroundColor: visible[i].backgroundColor,
                foregroundColor: visible[i].foregroundColor,
              ),
            ),
          if (overflow > 0)
            Positioned(
              left: visible.length * (size - overlap),
              child: ComponentAvatar(
                initials: '+$overflow',
                size: size,
                backgroundColor: context.componentTheme.chipColor,
              ),
            ),
        ],
      ),
    );
  }
}
