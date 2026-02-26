import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
//  Riverpod
// ════════════════════════════════════════════════════════════════════════════
final profileFlipProvider = StateProvider<Set<int>>((ref) => {});

// ════════════════════════════════════════════════════════════════════════════
//  Data Models
// ════════════════════════════════════════════════════════════════════════════
class FieldData {
  final String label;
  final String value;
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
  final List<SectionData> extraSections;
  const PageData(
    this.title,
    this.fields, {
    this.secondSection,
    this.extraSections = const [],
  });
}

// ════════════════════════════════════════════════════════════════════════════
//  _FieldTile
// ════════════════════════════════════════════════════════════════════════════
class FieldTile extends StatelessWidget {
  final String label;
  final String value;
  const FieldTile({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppTheme.textGrey,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  FlipCard  — two-face card (personal / family / guardian)
// ════════════════════════════════════════════════════════════════════════════
class FlipCard extends ConsumerStatefulWidget {
  final int index;
  final String? avatarAsset;
  final String title;
  final List<FieldData> frontFields;
  final List<FieldData> backFields;

  const FlipCard({
    super.key,
    required this.index,
    required this.title,
    required this.frontFields,
    required this.backFields,
    this.avatarAsset,
  });

  @override
  ConsumerState<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends ConsumerState<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _flip() {
    final current = Set<int>.from(ref.read(profileFlipProvider));
    _isFront ? current.add(widget.index) : current.remove(widget.index);
    ref.read(profileFlipProvider.notifier).state = current;
    _isFront ? _ctrl.forward() : _ctrl.reverse();
    setState(() => _isFront = !_isFront);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final angle = _anim.value * pi;
        final showingBack = angle > pi / 2;

        return IntrinsicHeight(
          child: Stack(
            children: [
              // Ghost front face — keeps card height stable
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: _CardFace(
                  isBack: false,
                  avatarAsset: widget.avatarAsset,
                  title: widget.title,
                  fields: widget.frontFields,
                  onFlip: _flip,
                ),
              ),
              // Ghost back face
              Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: _CardFace(
                  isBack: true,
                  avatarAsset: widget.avatarAsset,
                  title: widget.title,
                  fields: widget.backFields,
                  onFlip: _flip,
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0014)
                  ..rotateY(angle),
                child: showingBack
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _CardFace(
                          isBack: true,
                          avatarAsset: widget.avatarAsset,
                          title: widget.title,
                          fields: widget.backFields,
                          onFlip: _flip,
                        ),
                      )
                    : _CardFace(
                        isBack: false,
                        avatarAsset: widget.avatarAsset,
                        title: widget.title,
                        fields: widget.frontFields,
                        onFlip: _flip,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  _CardFace
// ════════════════════════════════════════════════════════════════════════════
class _CardFace extends StatelessWidget {
  final bool isBack;
  final String? avatarAsset;
  final String title;
  final List<FieldData> fields;
  final VoidCallback onFlip;

  static const Color _accent = AppTheme.accentBlue;
  static const double _tabW = 36.0;

  const _CardFace({
    required this.isBack,
    required this.avatarAsset,
    required this.title,
    required this.fields,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFlip,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isBack && avatarAsset != null) ...[
                      _buildAvatar(avatarAsset!),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isBack) ...[
                            Text(
                              title,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 2,
                              width: 40,
                              decoration: BoxDecoration(
                                color: _accent,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          ...fields.map(
                            (f) => FieldTile(label: f.label, value: f.value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onFlip,
              child: Container(
                width: _tabW,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: AnimatedRotation(
                    turns: isBack ? 0.5 : 0,
                    duration: const Duration(milliseconds: 550),
                    curve: Curves.easeInOut,
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAvatar(String asset) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ClipOval(
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: _accent.withOpacity(0.08),
            child: const Icon(Icons.person, size: 38, color: _accent),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  MultiPageFlipCard  — paginated card with flip animation
// ════════════════════════════════════════════════════════════════════════════
class MultiPageFlipCard extends StatefulWidget {
  final List<PageData> pages;
  const MultiPageFlipCard({super.key, required this.pages});

  @override
  State<MultiPageFlipCard> createState() => _MultiPageFlipCardState();
}

class _MultiPageFlipCardState extends State<MultiPageFlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  int _currentPage = 0;
  int _targetPage = 0;
  bool _goingForward = true;
  bool _isFlipping = false;
  double? _fixedHeight;
  late final List<GlobalKey> _probeKeys;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
    _probeKeys = List.generate(widget.pages.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndLock());
  }

  void _measureAndLock() {
    double maxH = 0;
    for (final k in _probeKeys) {
      final box = k.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize && box.size.height > maxH) {
        maxH = box.size.height;
      }
    }
    if (maxH > 0) setState(() => _fixedHeight = maxH);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _navigate(bool forward) {
    if (_isFlipping) return;
    _goingForward = forward;
    _targetPage = forward
        ? (_currentPage + 1) % widget.pages.length
        : (_currentPage - 1 + widget.pages.length) % widget.pages.length;
    setState(() => _isFlipping = true);
    _ctrl.forward(from: 0).then((_) {
      setState(() {
        _currentPage = _targetPage;
        _isFlipping = false;
      });
      _ctrl.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = widget.pages.length;

    // Phase 1: measuring
    if (_fixedHeight == null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PageFace(
            key: _probeKeys[0],
            page: widget.pages[0],
            currentIndex: 0,
            totalPages: totalPages,
            fixedHeight: null,
            onNext: () {},
            onPrev: () {},
          ),
          for (int i = 1; i < widget.pages.length; i++)
            Offstage(
              offstage: true,
              child: PageFace(
                key: _probeKeys[i],
                page: widget.pages[i],
                currentIndex: i,
                totalPages: totalPages,
                fixedHeight: null,
                onNext: () {},
                onPrev: () {},
              ),
            ),
        ],
      );
    }

    // Phase 2: locked height + flip animation
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        final angle = _goingForward ? _anim.value * pi : -_anim.value * pi;
        final showTarget = _goingForward ? angle > pi / 2 : angle < -pi / 2;
        final displayPage = showTarget ? _targetPage : _currentPage;

        return SizedBox(
          height: _fixedHeight,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0014)
              ..rotateY(angle),
            child: showTarget
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: PageFace(
                      page: widget.pages[displayPage],
                      currentIndex: displayPage,
                      totalPages: totalPages,
                      fixedHeight: _fixedHeight,
                      onNext: () => _navigate(true),
                      onPrev: () => _navigate(false),
                    ),
                  )
                : PageFace(
                    page: widget.pages[displayPage],
                    currentIndex: displayPage,
                    totalPages: totalPages,
                    fixedHeight: _fixedHeight,
                    onNext: () => _navigate(true),
                    onPrev: () => _navigate(false),
                  ),
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  PageFace
// ════════════════════════════════════════════════════════════════════════════
class PageFace extends StatelessWidget {
  final PageData page;
  final int currentIndex;
  final int totalPages;
  final double? fixedHeight;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  static const Color _accent = AppTheme.accentBlue;
  static const double _tabW = 36.0;

  const PageFace({
    super.key,
    required this.page,
    required this.currentIndex,
    required this.totalPages,
    required this.fixedHeight,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == totalPages - 1;

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left arrow tab
          GestureDetector(
            onTap: onPrev,
            child: Container(
              width: _tabW,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 20,
                  color: isFirst ? Colors.black.withOpacity(0.25) : Colors.black,
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: fixedHeight == null
                ? _buildMeasureContent()
                : _buildLockedContent(),
          ),

          // Right arrow tab
          GestureDetector(
            onTap: onNext,
            child: Container(
              width: _tabW,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20,
                  color: isLast ? Colors.black.withOpacity(0.25) : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return fixedHeight == null
        ? IntrinsicHeight(child: card)
        : SizedBox(width: double.infinity, height: fixedHeight, child: card);
  }

  Widget _dotsBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (i) {
        final active = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? _accent : _accent.withOpacity(0.25),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildMeasureContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 8),
          child: _buildPageContent(),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 14, top: 4),
          child: _dotsBar(),
        ),
      ],
    );
  }

  Widget _buildLockedContent() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 30,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
              child: _buildPageContent(),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: 30,
          child: Center(child: _dotsBar()),
        ),
      ],
    );
  }

  Widget _buildPageContent() {
    if (page.extraSections.isNotEmpty) return _buildMultiColumn(page);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionTitle(page.title),
        const SizedBox(height: 14),
        ...page.fields.map((f) => FieldTile(label: f.label, value: f.value)),
        if (page.secondSection != null) ...[
          const SizedBox(height: 16),
          Divider(color: _accent.withOpacity(0.2), thickness: 1),
          const SizedBox(height: 12),
          _sectionTitle(page.secondSection!.title),
          const SizedBox(height: 14),
          ...page.secondSection!.fields
              .map((f) => FieldTile(label: f.label, value: f.value)),
        ],
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 2,
          width: 40,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiColumn(PageData page) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(child: _sectionTitle(page.title)),
        const SizedBox(height: 16),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < page.extraSections.length; i++) ...[
                if (i > 0)
                  VerticalDivider(
                    color: _accent.withOpacity(0.2),
                    thickness: 1,
                    width: 16,
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _accent.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          page.extraSections[i].title,
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: _accent,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ...page.extraSections[i].fields.map(
                        (f) => FieldTile(label: f.label, value: f.value),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}