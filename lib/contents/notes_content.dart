import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class NotesContent extends StatefulWidget {
  const NotesContent({super.key});

  @override
  State<NotesContent> createState() => _NotesContentState();
}

class _NotesContentState extends State<NotesContent> {
  String? _selectedSemester;
  String? _selectedSubject;
  String? _selectedUnit;

  final List<String> _semesters = [
    'Semester 1', 'Semester 2', 'Semester 3',
    'Semester 4', 'Semester 5', 'Semester 6',
    'Semester 7', 'Semester 8',
  ];

  final Map<String, List<String>> _subjectsBySemester = {
    'Semester 1': ['Engineering Mathematics I', 'Engineering Physics', 'Engineering Chemistry'],
    'Semester 2': ['Engineering Mathematics II', 'Basic Electrical Engineering', 'C Programming'],
    'Semester 3': ['Data Structures', 'Digital Electronics', 'Discrete Mathematics'],
    'Semester 4': ['Operating Systems', 'Computer Networks', 'Database Management'],
    'Semester 5': ['Software Engineering', 'Web Technology', 'Compiler Design'],
    'Semester 6': ['Machine Learning', 'Cloud Computing', 'Information Security'],
    'Semester 7': ['Artificial Intelligence', 'Big Data Analytics', 'IoT'],
    'Semester 8': ['Project Work', 'Elective I', 'Elective II'],
  };

  final List<String> _units = ['Unit 1', 'Unit 2', 'Unit 3', 'Unit 4', 'Unit 5'];

  // Mock notes data — replace with real API data
  final List<Map<String, String>> _mockNotes = [
    {
      'title': 'Introduction to Data Structures',
      'unit': 'Unit 1',
      'type': 'PDF',
      'size': '2.4 MB',
      'date': 'Jan 10, 2026',
    },
    {
      'title': 'Arrays and Linked Lists',
      'unit': 'Unit 1',
      'type': 'PDF',
      'size': '1.8 MB',
      'date': 'Jan 15, 2026',
    },
    {
      'title': 'Stacks and Queues',
      'unit': 'Unit 2',
      'type': 'PPT',
      'size': '3.1 MB',
      'date': 'Feb 2, 2026',
    },
    {
      'title': 'Trees and Binary Trees',
      'unit': 'Unit 3',
      'type': 'PDF',
      'size': '4.2 MB',
      'date': 'Feb 18, 2026',
    },
    {
      'title': 'Graph Algorithms',
      'unit': 'Unit 4',
      'type': 'PDF',
      'size': '2.9 MB',
      'date': 'Mar 1, 2026',
    },
  ];

  List<String> get _subjects =>
      _selectedSemester != null ? (_subjectsBySemester[_selectedSemester!] ?? []) : [];

  List<Map<String, String>> get _filteredNotes {
    if (_selectedSemester == null) return [];
    return _mockNotes.where((note) {
      if (_selectedUnit != null && note['unit'] != _selectedUnit) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          // Title
          Center(
            child: Text(
              'Study Notes',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Filter card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter Notes',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 16),

                // Row 1: Semester + Subject
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Semester',
                        value: _selectedSemester,
                        items: _semesters,
                        onChanged: (val) => setState(() {
                          _selectedSemester = val;
                          _selectedSubject = null;
                          _selectedUnit = null;
                        }),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDropdown(
                        label: 'Subject',
                        value: _selectedSubject,
                        items: _subjects,
                        onChanged: _subjects.isEmpty
                            ? null
                            : (val) => setState(() => _selectedSubject = val),
                        hint: _selectedSemester == null ? 'Select semester first' : 'Select',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Row 2: Unit
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        label: 'Unit',
                        value: _selectedUnit,
                        items: _units,
                        onChanged: _selectedSubject == null
                            ? null
                            : (val) => setState(() => _selectedUnit = val),
                        hint: _selectedSubject == null ? 'Select subject first' : 'Select',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _selectedSemester != null
                                ? () => setState(() {})
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.accentBlue,
                              disabledBackgroundColor: AppTheme.borderColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
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
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Notes list
          if (_selectedSemester == null)
            _buildEmptyState(
              icon: Icons.menu_book_rounded,
              message: 'Select a semester to browse notes',
            )
          else if (_filteredNotes.isEmpty)
            _buildEmptyState(
              icon: Icons.search_off_rounded,
              message: 'No notes found for selected filters',
            )
          else ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '${_filteredNotes.length} note${_filteredNotes.length > 1 ? 's' : ''} found',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white60,
                ),
              ),
            ),
            ..._filteredNotes.map((note) => _buildNoteCard(note)),
          ],

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    String hint = 'Select',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: onChanged == null ? AppTheme.inputBg : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.borderColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.textGrey,
                ),
              ),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down,
                  color: onChanged == null ? AppTheme.textGrey : AppTheme.primaryDark,
                  size: 20),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.primaryDark,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              onChanged: onChanged,
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item,
                            style: GoogleFonts.poppins(fontSize: 13)),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(Map<String, String> note) {
    final isPdf = note['type'] == 'PDF';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // File type icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isPdf
                  ? const Color(0xFFFFEEEE)
                  : const Color(0xFFEEF0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                note['type']!,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isPdf ? Colors.red.shade600 : AppTheme.accentBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Note info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['title']!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _chip(note['unit']!),
                    const SizedBox(width: 6),
                    Text(
                      '${note['size']} · ${note['date']}',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Download button
          GestureDetector(
            onTap: () {
              // TODO: implement download
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.download_rounded,
                color: AppTheme.accentBlue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentBlue,
        ),
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
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
}