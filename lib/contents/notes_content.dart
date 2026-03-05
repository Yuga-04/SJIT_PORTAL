import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NotesContent extends StatefulWidget {
  const NotesContent({super.key});

  @override
  State<NotesContent> createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  // ── State ──────────────────────────────────────────────────────────────────
  String? _selectedYear;
  int     _selectedSem  = 1;
  String? _selectedSubject;
  String? _selectedNotesType;
  bool    _searched     = false;

  // ── Static data ────────────────────────────────────────────────────────────
  static final List<String> _academicYears = List.generate(13, (i) {
    final start = 2026 - i;
    return '$start-${start + 1}';
  });

  static const Map<int, List<String>> _subjectsBySem = {
    1: ['CY4101-Engineering Mathematics I', 'CY4102-Engineering Physics',
        'CY4103-C Programming', 'CY4104-Engineering Chemistry'],
    2: ['CY4201-Engineering Mathematics II', 'CY4202-Basic Electrical Engineering',
        'CY4203-Data Structures', 'CY4204-Digital Electronics'],
    3: ['CY4301-Operating Systems', 'CY4302-Computer Networks',
        'CY4303-Database Management', 'CY4304-Discrete Mathematics'],
    4: ['CY4401-Design and Analysis of Algorithms', 'CY4402-Microprocessors',
        'CY4403-Software Engineering', 'CY4404-Computer Architecture'],
    5: ['CY4501-Web Technology', 'CY4502-Compiler Design',
        'CY4503-Mobile Computing', 'CY4504-Object Oriented Programming'],
    6: ['CY4601-Machine Learning', 'CY4602-Cloud Computing',
        'CY4603-Information Security', 'CY4604-Big Data Analytics'],
    7: ['CY4701-Artificial Intelligence', 'CY4702-IoT',
        'CY4703-Deep Learning', 'CY4704-Natural Language Processing'],
    8: ['CY4801-Project Work', 'CY4802-Elective I', 'CY4803-Elective II'],
  };

  static const List<String> _notesTypes = [
    'Class Notes',
    'Question Bank',
    'Previous University Questions',
    'Model Keys',
    'IAE Keys',
    'Syllabus',
    'Previous University Answers',
    'Video Lectures',
  ];

  // Mock notes — replace with API response
  final List<Map<String, String>> _mockNotes = [
    {'title': 'HCI Alan Dix.pdf',     'type': 'PDF'},
    {'title': 'UNIT 4.docx.pdf',      'type': 'PDF'},
    {'title': 'UNIT 2 NOTES',         'type': 'PDF'},
    {'title': 'UNIT 3 NOTES',         'type': 'PDF'},
    {'title': 'UNIT 4 NOTES',         'type': 'PDF'},
    {'title': 'UNIT 5 NOTES',         'type': 'PDF'},
    {'title': 'HCI Unit 1.pdf',       'type': 'PDF'},
    {'title': 'HCI unit 2.pdf',       'type': 'PDF'},
    {'title': 'Unit_3_Lex_Yacc',      'type': 'PDF'},
    {'title': 'UNIT IV FDIP.pdf',     'type': 'PDF'},
    {'title': 'Unit III FDIP.pptx',   'type': 'PPT'},
    {'title': 'Unit IV part 1.pptx',  'type': 'PPT'},
    {'title': 'Unit IV part 2.pptx',  'type': 'PPT'},
  ];

  // ── Derived ────────────────────────────────────────────────────────────────
  List<String> get _subjects => _subjectsBySem[_selectedSem] ?? [];

  bool get _canSearch =>
      _selectedYear != null &&
      _selectedSubject != null &&
      _selectedNotesType != null;

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── White form card ──────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    'Notes Download',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE5E7EB),
                  ),
                ),

                // Form fields
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Academic Year ──────────────────────────────────
                      _fieldLabel('Academic Year:'),
                      const SizedBox(height: 8),
                      // LayoutBuilder so the dropdown never exceeds card width
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final dropW =
                              (constraints.maxWidth * 0.55).clamp(140.0, 220.0);
                          return SizedBox(
                            width: dropW,
                            child: _buildDropdown(
                              value: _selectedYear,
                              hint: 'Select',
                              items: _academicYears,
                              onChanged: (v) => setState(() {
                                _selectedYear    = v;
                                _selectedSubject = null;
                                _searched        = false;
                              }),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // ── Sem chips (Wrap — never overflows) ────────────
                      _fieldLabel('Sem :'),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(8, (i) {
                          final sem      = i + 1;
                          final isActive = sem == _selectedSem;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedSem     = sem;
                              _selectedSubject = null;
                              _searched        = false;
                            }),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppTheme.primaryDark
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isActive
                                      ? AppTheme.primaryDark
                                      : const Color(0xFFD1D5DB),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$sem',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.white
                                        : AppTheme.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 20),

                      // ── Subject (full width) ───────────────────────────
                      _fieldLabel('Subject:'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _selectedSubject,
                        hint: _selectedYear == null
                            ? 'Select academic year first'
                            : 'Select',
                        items: _subjects,
                        onChanged: _selectedYear == null
                            ? null
                            : (v) => setState(() {
                                  _selectedSubject   = v;
                                  _selectedNotesType = null;
                                  _searched          = false;
                                }),
                      ),
                      const SizedBox(height: 16),

                      // ── Notes Type (full width) ────────────────────────
                      _fieldLabel('Notes Type:'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _selectedNotesType,
                        hint: _selectedSubject == null
                            ? 'Select subject first'
                            : 'Select',
                        items: _notesTypes,
                        onChanged: _selectedSubject == null
                            ? null
                            : (v) => setState(() {
                                  _selectedNotesType = v;
                                  _searched          = false;
                                }),
                      ),
                      const SizedBox(height: 24),

                      // ── Search button ──────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _canSearch
                              ? () => setState(() => _searched = true)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentBlue,
                            disabledBackgroundColor: AppTheme.borderColor,
                            padding:
                                const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'SEARCH',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Results / empty state ────────────────────────────────────────
          if (_searched) ...[
            const SizedBox(height: 20),
            _mockNotes.isEmpty
                ? _emptyState(Icons.search_off_rounded, 'No notes found')
                : _buildFileTable(),
          ] else ...[
            const SizedBox(height: 32),
            _emptyState(
              Icons.menu_book_rounded,
              'Select all fields to browse notes',
            ),
          ],
        ],
      ),
    );
  }

  // ── Dropdown ───────────────────────────────────────────────────────────────
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    String hint = 'Select',
  }) {
    final disabled = onChanged == null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: disabled ? const Color(0xFFF9FAFB) : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppTheme.textGrey,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: disabled ? AppTheme.textGrey : AppTheme.primaryDark,
            size: 20,
          ),
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: AppTheme.primaryDark,
          ),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(8),
          onChanged: onChanged,
          // Prevent selected value text from overflowing
          selectedItemBuilder: (context) => items
              .map(
                (item) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              )
              .toList(),
          items: items
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(
                    item,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ── File table ─────────────────────────────────────────────────────────────
  Widget _buildFileTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            // Dark navy header row
            Container(
              width: double.infinity,
              color: AppTheme.primaryDark,
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Text(
                'File Name',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),

            // File rows
            ...List.generate(_mockNotes.length, (i) {
              final note   = _mockNotes[i];
              final isEven = i % 2 == 0;
              return GestureDetector(
                onTap: () {
                  // TODO: open / download file
                },
                child: Container(
                  width: double.infinity,
                  color:
                      isEven ? Colors.white : const Color(0xFFF8F9FF),
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      _fileIcon(note['type'] ?? 'PDF'),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          note['title']!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppTheme.primaryDark,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                            decorationColor: AppTheme.primaryDark,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.download_rounded,
                        size: 18,
                        color: AppTheme.textGrey,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ── File type badge ────────────────────────────────────────────────────────
  Widget _fileIcon(String type) {
    final t = type.toUpperCase();
    Color bg;
    Color fg;

    if (t == 'PDF') {
      bg = const Color(0xFFFFEEEE);
      fg = Colors.red.shade600;
    } else if (t == 'PPT' || t == 'PPTX') {
      bg = const Color(0xFFFFF3EE);
      fg = Colors.orange.shade700;
    } else if (t == 'DOC' || t == 'DOCX') {
      bg = const Color(0xFFEEF3FF);
      fg = Colors.blue.shade700;
    } else {
      bg = const Color(0xFFEEF5EE);
      fg = Colors.green.shade700;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          t.length > 3 ? t.substring(0, 3) : t,
          style: GoogleFonts.poppins(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
        ),
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _fieldLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      );

  Widget _emptyState(IconData icon, String message) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(icon, size: 56, color: Colors.white24),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
        ),
      );
}