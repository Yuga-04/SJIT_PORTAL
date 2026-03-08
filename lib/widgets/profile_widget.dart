import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Data Models ───────────────────────────────────────────────────────────────
class FieldData {
  final String label, value;
  const FieldData(this.label, this.value);
}

class SectionData {
  final String title;
  final List<FieldData> fields;
  const SectionData(this.title, this.fields);
}

class PageData {
  final String title;
  final List<FieldData> fields;
  final SectionData? secondSection;
  const PageData(this.title, this.fields, {this.secondSection});
}

// ─────────────────────────────────────────────────────────────────────────────
//  Layout constants  (all sizes in logical pixels)
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const double accentBar     = 3;
  static const double dotRow        = 36;
  static const EdgeInsets pagePad   = EdgeInsets.fromLTRB(16, 14, 16, 12);
  static const double avatarSize    = 50;
  // ignore: unused_field
  static const double avatarGap     = 12;
  static const double titleBlock    = 36.5 + 12;
  // ignore: unused_field
  static const double titleNoAvatar = 49;
  // ignore: unused_field
  static const double subHeadH      = 18 + 4 + 2.5 + 10;
  static const double subGapAbove   = 10;
  static const double fieldH        = 16 * 1.4 + 8;
  static const double fieldH2       = 16 * 1.4 * 2 + 8;
}

// ─────────────────────────────────────────────────────────────────────────────
//  Height calculator
// ─────────────────────────────────────────────────────────────────────────────
double calcContentHeight({
  required bool hasAvatar,
  required List<PageData> pages,
  required bool multiPage,
}) {
  double maxH = 0;

  for (int i = 0; i < pages.length; i++) {
    final page    = pages[i];
    final isFirst = i == 0;
    final hasTitle = page.title.isNotEmpty;
    double h = _C.pagePad.top + _C.pagePad.bottom;

    if (isFirst && hasTitle) {
      h += (hasAvatar ? _C.avatarSize : 0) + _C.titleBlock;
    }
    if (!isFirst && hasTitle) {
      h += _C.titleBlock;
    }

    for (final f in page.fields) {
      h += _isMultiLine(f.value) ? _C.fieldH2 : _C.fieldH;
    }

    if (page.secondSection != null) {
      h += _C.subGapAbove + _C.titleBlock;
      for (final f in page.secondSection!.fields) {
        h += _isMultiLine(f.value) ? _C.fieldH2 : _C.fieldH;
      }
    }

    if (h > maxH) maxH = h;
  }

  return maxH + 8;
}

bool _isMultiLine(String value) =>
    value.length > 40 || value.contains('\n');

// ═══════════════════════════════════════════════════════════════════════════════
//  MultiPageFlipCard
// ═══════════════════════════════════════════════════════════════════════════════
class MultiPageFlipCard extends StatefulWidget {
  final List<PageData> pages;
  final String? avatarAsset;
  final double? contentHeight;

  const MultiPageFlipCard({
    super.key,
    required this.pages,
    this.avatarAsset,
    this.contentHeight,
  });

  @override
  State<MultiPageFlipCard> createState() => _MultiPageFlipCardState();
}

class _MultiPageFlipCardState extends State<MultiPageFlipCard> {
  late final PageController _ctrl;
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _ctrl = PageController();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _goTo(int i) {
    if (i < 0 || i >= widget.pages.length) return;
    _ctrl.animateToPage(
      i,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final total     = widget.pages.length;
    final multiPage = total > 1;

    final double contentH = widget.contentHeight ??
        calcContentHeight(
          hasAvatar: widget.avatarAsset != null,
          pages: widget.pages,
          multiPage: multiPage,
        );

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: AppTheme.darkBorder, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header strip ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
            color: AppTheme.darkSurface,
            child: Row(
              children: [
                // Accent dot — blue
                Container(
                  width: 7, height: 7,
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue,            // ← blue dot
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.pages[_current].title,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),      // ← near-black
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                // Page indicator pills — blue
                if (total > 1)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(total, (i) {
                      final on = i == _current;
                      return GestureDetector(
                        onTap: () => _goTo(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          margin: const EdgeInsets.only(left: 5),
                          width: on ? 18 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: on
                                ? AppTheme.accentBlue
                                : AppTheme.accentBlue.withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
              ],
            ),
          ),

          // ── Swipeable page body ───────────────────────────────────────────
          SizedBox(
            height: contentH,
            child: PageView.builder(
              controller: _ctrl,
              physics: const ClampingScrollPhysics(),
              itemCount: total,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => _PageBody(
                page: widget.pages[i],
                showTitle: false,
                avatarAsset: i == 0 ? widget.avatarAsset : null,
                pageSubHeading: null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Single page body ──────────────────────────────────────────────────────────
class _PageBody extends StatelessWidget {
  final PageData   page;
  final bool       showTitle;
  final String?    avatarAsset;
  final String?    pageSubHeading;

  const _PageBody({
    required this.page,
    required this.showTitle,
    this.avatarAsset,
    this.pageSubHeading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _C.pagePad,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (avatarAsset != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _Avatar(avatarAsset!),
            ),

          ...page.fields.map((f) => FieldTile(label: f.label, value: f.value)),

          if (page.secondSection != null) ...[
            const SizedBox(height: 10),
            _SubSectionTitle(page.secondSection!.title),
            const SizedBox(height: 8),
            ...page.secondSection!.fields
                .map((f) => FieldTile(label: f.label, value: f.value)),
          ],
        ],
      ),
    );
  }
}

// ── Field Tile ────────────────────────────────────────────────────────────────
class FieldTile extends StatelessWidget {
  final String label, value;
  const FieldTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 126,
            child: Text(
              label,
              style: GoogleFonts.dmSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF6B7280),            // ← grey label
                height: 1.4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Text(
              ':',
              style: GoogleFonts.dmSans(
                fontSize: 11.5,
                color: const Color(0xFF9CA3AF),            // ← light grey colon
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.dmSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),            // ← near-black value
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sub-section title (inside page body) ──────────────────────────────────────
class _SubSectionTitle extends StatelessWidget {
  final String text;
  const _SubSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.dmSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF374151),                // ← dark grey
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                const Color(0xFF9CA3AF).withValues(alpha: 0.50),
                const Color(0xFF9CA3AF).withValues(alpha: 0),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String asset;
  const _Avatar(this.asset);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _C.avatarSize,
      height: _C.avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2), // ← grey border
      ),
      child: ClipOval(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (ctx, err, stk) => Container(
            color: const Color(0xFFF3F4F6),                // ← light grey fallback
            child: const Icon(
              Icons.person_rounded,
              size: 24,
              color: Color(0xFF9CA3AF),                    // ← grey icon
            ),
          ),
        ),
      ),
    );
  }
}

// ── Legacy FlipCard alias ─────────────────────────────────────────────────────
class FlipCard extends StatelessWidget {
  final int             index;
  final String?         avatarAsset;
  final String          title;
  final List<FieldData> frontFields;
  final List<FieldData> backFields;

  const FlipCard({
    super.key,
    required this.index,
    this.avatarAsset,
    required this.title,
    required this.frontFields,
    required this.backFields,
  });

  @override
  Widget build(BuildContext context) {
    return MultiPageFlipCard(
      avatarAsset: avatarAsset,
      pages: [
        PageData(title, frontFields),
        PageData('', backFields),
      ],
    );
  }
}