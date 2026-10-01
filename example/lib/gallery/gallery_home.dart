import 'package:example/gallery/demo_scaffold.dart';
import 'package:example/gallery/gallery_catalog.dart';
import 'package:flutter_components/flutter_components.dart';
import 'package:material_ui/material_ui.dart';

class GalleryHome extends StatefulWidget {
  const GalleryHome({super.key});

  @override
  State<GalleryHome> createState() => _GalleryHomeState();
}

class _GalleryHomeState extends State<GalleryHome> {
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<GallerySection> get _sections {
    final String query = _search.text.trim().toLowerCase();
    return gallerySections()
        .map((section) {
          if (query.isEmpty) return section;
          final matches = section.entries
              .where(
                (entry) =>
                    entry.title.toLowerCase().contains(query) ||
                    entry.subtitle.toLowerCase().contains(query),
              )
              .toList();
          return GallerySection(title: section.title, entries: matches);
        })
        .where((section) => section.entries.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<GallerySection> sections = _sections;
    final int columns = context.gridViewCrossAxisCount;

    return Scaffold(
      body: ComponentNestedScrollViewConfig(
        child: CustomScrollView(
          slivers: [
            ComponentSliverLargeTitleAppBar(
              context: context,
              title: 'Components',
              subtitle: 'Tap a widget to try it on this device',
              automaticallyImplyLeading: false,
              actions: const [ThemeToggleButton()],
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                context.defaultPadding,
                8,
                context.defaultPadding,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: ComponentTextField(
                  controller: _search,
                  hintText: 'Search widgets',
                  icon: const Icon(Icons.search_rounded),
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            if (sections.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'No widgets match that search',
                    style: context.bodyMedium.copyWith(color: context.hintIntense),
                  ),
                ),
              )
            else
              for (final GallerySection section in sections) ...[
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    context.defaultPadding,
                    28,
                    context.defaultPadding,
                    12,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Text(section.title, style: context.body2Heavy),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: context.defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: _SectionGrid(
                      entries: section.entries,
                      crossAxisCount: columns,
                    ),
                  ),
                ),
              ],
            SliverToBoxAdapter(child: SizedBox(height: context.paddingBottom)),
          ],
        ),
      ),
    );
  }
}

class _SectionGrid extends StatefulWidget {
  const _SectionGrid({
    required this.entries,
    required this.crossAxisCount,
  });

  final List<GalleryEntry> entries;
  final int crossAxisCount;

  @override
  State<_SectionGrid> createState() => _SectionGridState();
}

class _SectionGridState extends State<_SectionGrid> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicGridView(
      controller: _controller,
      itemCount: widget.entries.length,
      crossAxisCount: widget.crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      builder: (BuildContext context, int index) {
        return _GalleryCard(entry: widget.entries[index]);
      },
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.entry});

  final GalleryEntry entry;

  @override
  Widget build(BuildContext context) {
    return ComponentCard(
      key: ValueKey<String>('gallery-${entry.id}'),
      displayBorder: true,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: entry.page),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: ShapeDecoration(
              color: context.chipColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppDecoration.borderRadiusMd,
              ),
            ),
            child: Icon(entry.icon, color: context.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.title, style: context.body2Heavy),
                const SizedBox(height: 4),
                Text(
                  entry.subtitle,
                  style: context.bodyMedium.copyWith(color: context.hintIntense),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
