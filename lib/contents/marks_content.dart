import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Sample data model ────────────────────────────────────────────────────────
class SubjectMark {
  final String code;
  final String name;
  final String marks; // String to allow "null" values

  const SubjectMark({
    required this.code,
    required this.name,
    required this.marks,
  });
}

// ── Mock data per semester/exam ───────────────────────────────────────────────
const Map<int, Map<String, List<SubjectMark>>> _marksData = {
  1: {
    'Model-1': [
      SubjectMark(code: 'CY4104', name: 'Engineering Chemistry', marks: '52'),
      SubjectMark(code: 'GE4106', name: 'Engineering Graphics', marks: '75'),
      SubjectMark(
          code: 'GE4109',
          name: 'Problem Solving and Programming in C',
          marks: 'null'),
      SubjectMark(code: 'GE4151', name: 'Heritage of Tamil', marks: '79'),
      SubjectMark(
          code: 'HS4101', name: 'Communicative English', marks: '67'),
      SubjectMark(
          code: 'MA4102', name: 'Engineering Mathematics', marks: '75'),
      SubjectMark(code: 'PH4103', name: 'Engineering Physics', marks: '80'),
    ],
    'Model-2': [
      SubjectMark(code: 'CY4104', name: 'Engineering Chemistry', marks: '61'),
      SubjectMark(code: 'GE4106', name: 'Engineering Graphics', marks: '80'),
      SubjectMark(
          code: 'GE4109',
          name: 'Problem Solving and Programming in C',
          marks: '70'),
      SubjectMark(code: 'GE4151', name: 'Heritage of Tamil', marks: '85'),
      SubjectMark(
          code: 'HS4101', name: 'Communicative English', marks: '72'),
      SubjectMark(
          code: 'MA4102', name: 'Engineering Mathematics', marks: '68'),
      SubjectMark(code: 'PH4103', name: 'Engineering Physics', marks: '77'),
    ],
    'Model-3': [
      SubjectMark(code: 'CY4104', name: 'Engineering Chemistry', marks: '58'),
      SubjectMark(code: 'GE4106', name: 'Engineering Graphics', marks: '82'),
      SubjectMark(
          code: 'GE4109',
          name: 'Problem Solving and Programming in C',
          marks: '74'),
      SubjectMark(code: 'GE4151', name: 'Heritage of Tamil', marks: '88'),
      SubjectMark(
          code: 'HS4101', name: 'Communicative English', marks: '76'),
      SubjectMark(
          code: 'MA4102', name: 'Engineering Mathematics', marks: '71'),
      SubjectMark(code: 'PH4103', name: 'Engineering Physics', marks: '83'),
    ],
  },
};

// ════════════════════════════════════════════════════════════════════════════
class MarksContent extends StatefulWidget {
  const MarksContent({super.key});

  @override
  State<MarksContent> createState() => _MarksContentState();
}

class _MarksContentState extends State<MarksContent> {
  int _selectedSem = 1;
  String _selectedExam = 'Model-1';

  static const List<String> _exams = ['Model-1', 'Model-2', 'Model-3'];

  List<SubjectMark> get _currentMarks =>
      _marksData[_selectedSem]?[_selectedExam] ?? [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          // ── Card container ─────────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
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
                // ── Header ───────────────────────────────────────────────────
                _buildHeader(),

                const Divider(height: 1, color: Color(0xFFE5E7EB)),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Sem selector ─────────────────────────────────────
                      _buildLabel('Sem:'),
                      const SizedBox(height: 12),
                      _buildSemSelector(),
                      const SizedBox(height: 24),

                      // ── Exam selector ────────────────────────────────────
                      _buildLabel('Exam:'),
                      const SizedBox(height: 12),
                      _buildExamSelector(),
                      const SizedBox(height: 28),

                      // ── Marks table ──────────────────────────────────────
                      _buildLabel('MARKS:'),
                      const SizedBox(height: 12),
                      _buildMarksTable(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .slideY(begin: -0.05, end: 0),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      child: Text(
        'Marks Report',
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppTheme.primaryDark,
        ),
      ),
    );
  }

  // ── Section label ──────────────────────────────────────────────────────────
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryDark,
        letterSpacing: 0.3,
      ),
    );
  }

  // ── Semester selector (1–8) ────────────────────────────────────────────────
  Widget _buildSemSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(8, (i) {
        final sem = i + 1;
        final selected = sem == _selectedSem;
        return GestureDetector(
          onTap: () => setState(() => _selectedSem = sem),
          child: AnimatedContainer(
            duration: 200.ms,
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: selected ? AppTheme.primaryDark : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppTheme.primaryDark : const Color(0xFFCBD5E1),
                width: 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryDark.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: Text(
                '$sem',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppTheme.primaryDark,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  // ── Exam selector ─────────────────────────────────────────────────────────
  Widget _buildExamSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _exams.map((exam) {
        final selected = exam == _selectedExam;
        return GestureDetector(
          onTap: () => setState(() => _selectedExam = exam),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            decoration: BoxDecoration(
              color: selected ? AppTheme.primaryDark : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? AppTheme.primaryDark : const Color(0xFFCBD5E1),
                width: 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryDark.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )
                    ]
                  : [],
            ),
            child: Text(
              exam,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppTheme.primaryDark,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Marks table ────────────────────────────────────────────────────────────
  Widget _buildMarksTable() {
    if (_currentMarks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(Icons.bar_chart_outlined,
                  size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No marks available',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1.2),
        },
        border: TableBorder.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          // Header row
          TableRow(
            decoration: const BoxDecoration(
              color: AppTheme.primaryDark,
            ),
            children: [
              _tableHeaderCell('SUBJECTS'),
              _tableHeaderCell('MARKS'),
            ],
          ),
          // Data rows
          ..._currentMarks.asMap().entries.map((entry) {
            final idx = entry.key;
            final item = entry.value;
            final isEven = idx % 2 == 0;
            return TableRow(
              decoration: BoxDecoration(
                color: isEven ? Colors.white : const Color(0xFFF8FAFC),
              ),
              children: [
                _tableDataCell('${item.code} - ${item.name}'),
                _tableMarksCell(item.marks),
              ],
            );
          }),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms, delay: 100.ms);
  }

  Widget _tableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _tableDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF1E293B),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _tableMarksCell(String marks) {
    final isNull = marks == 'null';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Text(
        marks,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isNull ? Colors.grey.shade400 : const Color(0xFF1E293B),
          fontStyle: isNull ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }
}