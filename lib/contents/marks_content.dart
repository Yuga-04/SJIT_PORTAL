import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class SubjectMark {
  final String code;
  final String name;
  final String marks;
  const SubjectMark({required this.code, required this.name, required this.marks});
}

// ── Subject list per semester ─────────────────────────────────────────────────
// Replace MarksService.fetch() body with a real HTTP call when your API is ready.
class MarksService {
  static final Map<int, List<String>> _subjects = {
    1: [
      'CY4104|Engineering Chemistry',
      'GE4106|Engineering Graphics',
      'GE4109|Problem Solving and Programming in C',
      'GE4151|Heritage of Tamil',
      'HS4101|Communicative English',
      'MA4102|Engineering Mathematics',
      'PH4103|Engineering Physics',
    ],
    2: [
      'MA4201|Mathematics II',
      'PH4202|Engineering Physics II',
      'CS4201|Programming in C++',
      'EE4201|Basic Electrical Engineering',
      'ME4201|Engineering Mechanics',
      'HS4201|Technical English',
    ],
    3: [
      'MA6351|Transforms and Partial Differential Equations',
      'CS6301|Programming and Data Structures II',
      'CS6302|Database Management Systems',
      'CS6303|Computer Architecture',
      'CS6304|Analog and Digital Communication',
      'CS6305|Theory of Computation',
    ],
    4: [
      'MA6461|Probability and Queueing Theory',
      'CS6401|Operating Systems',
      'CS6402|Design and Analysis of Algorithms',
      'CS6403|Software Engineering',
      'CS6404|Compiler Design',
      'CS6405|Computer Networks',
    ],
    5: [
      'CS6501|Internet Programming',
      'CS6502|Object Oriented Analysis and Design',
      'CS6503|Theory of Computation',
      'CS6504|Computer Graphics',
      'CS6505|Automata and Complexity Theory',
    ],
    6: [
      'CS6601|Distributed Systems',
      'CS6602|Data Warehousing and Data Mining',
      'CS6603|Total Quality Management',
      'CS6604|Digital Image Processing',
      'CS6605|Pattern Recognition and Image Analysis',
    ],
    7: [
      'CS6701|Cryptography and Network Security',
      'CS6702|Graph Theory and Applications',
      'CS6703|Grid and Cloud Computing',
      'CS6001|C# and .Net Programming',
      'CS6002|Embedded Systems',
    ],
    8: [
      'CS6811|Project Work',
      'CS6812|Professional Ethics in Engineering',
      'CS6813|Entrepreneurship Development',
    ],
  };

  static const List<String> exams = ['Model-1', 'Model-2', 'Model-3'];

  /// Simulates an API call. Swap the body here to call your real endpoint.
  static Future<List<SubjectMark>> fetch({
    required int sem,
    required String model,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final subjects = _subjects[sem] ?? [];
    final modelIdx = exams.indexOf(model);

    return subjects.asMap().entries.map((e) {
      final idx = e.key;
      final parts = e.value.split('|');
      // Deterministic score so it stays consistent on re-render
      final score = 45 + ((sem * 11 + modelIdx * 7 + idx * 5) % 36);
      return SubjectMark(
        code: parts[0],
        name: parts[1],
        marks: '$score',
      );
    }).toList();
  }
}

// ════════════════════════════════════════════════════════════════════════════
class MarksContent extends StatefulWidget {
  const MarksContent({super.key});

  @override
  State<MarksContent> createState() => _MarksContentState();
}

class _MarksContentState extends State<MarksContent> {
  int _sem = 1;
  String _exam = 'Model-1';

  List<SubjectMark> _marks = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await MarksService.fetch(sem: _sem, model: _exam);
      if (mounted) setState(() { _marks = data; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _setSem(int s) { setState(() => _sem = s); _load(); }
  void _setExam(String e) { setState(() => _exam = e); _load(); }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.22),
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
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                  child: Text(
                    'Marks Report',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel('Sem:'),
                      const SizedBox(height: 12),
                      _semSelector(),
                      const SizedBox(height: 24),
                      _sectionLabel('Exam:'),
                      const SizedBox(height: 12),
                      _examSelector(),
                      const SizedBox(height: 28),
                      _sectionLabel('MARKS:'),
                      const SizedBox(height: 12),
                      _tableArea(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.05, end: 0),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String t) => Text(
        t,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.primaryDark,
        ),
      );

  // Sem tiles 1–8
  Widget _semSelector() => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(8, (i) {
          final s = i + 1;
          final on = s == _sem;
          return GestureDetector(
            onTap: () => _setSem(s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: on ? AppTheme.primaryDark : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: on ? AppTheme.primaryDark : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
                boxShadow: on
                    ? [BoxShadow(
                        color: AppTheme.primaryDark.withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                '$s',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: on ? Colors.white : AppTheme.primaryDark,
                ),
              ),
            ),
          );
        }),
      );

  // Exam chips
  Widget _examSelector() => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: MarksService.exams.map((ex) {
          final on = ex == _exam;
          return GestureDetector(
            onTap: () => _setExam(ex),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
              decoration: BoxDecoration(
                color: on ? AppTheme.primaryDark : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: on ? AppTheme.primaryDark : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
                boxShadow: on
                    ? [BoxShadow(
                        color: AppTheme.primaryDark.withOpacity(0.28),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      )]
                    : [],
              ),
              child: Text(
                ex,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: on ? Colors.white : AppTheme.primaryDark,
                ),
              ),
            ),
          );
        }).toList(),
      );

  // ── Table area ─────────────────────────────────────────────────────────────
  Widget _tableArea() {
    if (_loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              const CircularProgressIndicator(
                color: AppTheme.primaryDark,
                strokeWidth: 2.5,
              ),
              const SizedBox(height: 16),
              Text('Fetching marks…',
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: Colors.grey.shade400)),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red.shade200),
              const SizedBox(height: 12),
              Text('Failed to load marks',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.red.shade300)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _load,
                child: Text('Retry',
                    style: GoogleFonts.poppins(color: AppTheme.accentBlue)),
              ),
            ],
          ),
        ),
      );
    }

    if (_marks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.bar_chart_outlined,
                  size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No marks available for\nSem $_sem · $_exam',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      );
    }

    return Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(1.2),
        },
        border: TableBorder.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
        ),
        children: [
          // Header row
          TableRow(
            decoration: const BoxDecoration(color: AppTheme.primaryDark),
            children: [
              _th('SUBJECTS'),
              _th('MARKS'),
            ],
          ),
          // Data rows
          ..._marks.asMap().entries.map((e) {
            final even = e.key % 2 == 0;
            final item = e.value;
            final isNull = item.marks == 'null';
            return TableRow(
              decoration: BoxDecoration(
                color: even ? Colors.white : const Color(0xFFF8FAFC),
              ),
              children: [
                _td('${item.code} - ${item.name}'),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  child: Text(
                    item.marks,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isNull
                          ? Colors.grey.shade400
                          : const Color(0xFF1E293B),
                      fontStyle: isNull
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ).animate().fadeIn(duration: 350.ms);
  }

  Widget _th(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text(t,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.5,
            )),
      );

  Widget _td(String t) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Text(t,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: const Color(0xFF1E293B),
              height: 1.4,
            )),
      );
}