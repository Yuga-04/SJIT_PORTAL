import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../theme/app_theme.dart';

class AttendanceContent extends StatefulWidget {
  const AttendanceContent({super.key});

  @override
  State<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<AttendanceContent> {
  static const Color purpleAccent = Color(0xFF6C63FF);
  static const Color purpleLight  = Color(0xFFEDE9FF);
  static const Color sidebarBg    = Color(0xFF7C6FD0);

  int _selectedYear  = 2026;
  int _selectedMonth = 3; // March
  DateTime _selectedDate = DateTime(2026, 3, 2);

  // Mock events — replace with real data
  final Map<String, List<String>> _events = {
    '2026-3-10': ['Mathematics Class', 'Lab Session'],
    '2026-3-15': ['Guest Lecture'],
    '2026-3-20': ['Sports Day'],
  };

  static const List<String> _months = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];

  static const List<String> _weekDays = [
    'Sun','Mon','Tue','Wed','Thu','Fri','Sat',
  ];

  List<String> get _eventsForSelected {
    final key = '${_selectedYear}-${_selectedMonth}-${_selectedDate.day}';
    return _events[key] ?? [];
  }

  String _formatSelectedDate() {
    final months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December',
    ];
    return '${months[_selectedDate.month - 1]} ${_selectedDate.day}, ${_selectedDate.year}';
  }

  int _daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  int _firstWeekdayOfMonth(int year, int month) {
    return DateTime(year, month, 1).weekday % 7; // 0=Sun
  }

  void _prevYear() => setState(() => _selectedYear--);
  void _nextYear() => setState(() => _selectedYear++);

  void _selectMonth(int month) {
    setState(() {
      _selectedMonth = month;
      _selectedDate  = DateTime(_selectedYear, month, 1);
    });
  }

  void _prevMonth() {
    setState(() {
      if (_selectedMonth == 1) { _selectedMonth = 12; _selectedYear--; }
      else _selectedMonth--;
      _selectedDate = DateTime(_selectedYear, _selectedMonth, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) { _selectedMonth = 1; _selectedYear++; }
      else _selectedMonth++;
      _selectedDate = DateTime(_selectedYear, _selectedMonth, 1);
    });
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return day == now.day && _selectedMonth == now.month && _selectedYear == now.year;
  }

  bool _isSelected(int day) {
    return day == _selectedDate.day &&
        _selectedMonth == _selectedDate.month &&
        _selectedYear == _selectedDate.year;
  }

  bool _hasEvent(int day) {
    final key = '$_selectedYear-$_selectedMonth-$day';
    return _events.containsKey(key);
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
              'Attendance Report',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main card
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Left sidebar ──────────────────────────────────────────
                _buildSidebar(),

                // ── Center calendar ───────────────────────────────────────
                Expanded(child: _buildCalendar()),

                // ── Right panel ───────────────────────────────────────────
                _buildEventPanel(),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Sidebar ────────────────────────────────────────────────────────────────
  Widget _buildSidebar() {
    return Container(
      width: 110,
      decoration: BoxDecoration(
        color: sidebarBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Year navigator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _prevYear,
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 20),
                ),
                Text(
                  '$_selectedYear',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: _nextYear,
                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          // Month list
          ...List.generate(12, (i) {
            final isActive = (i + 1) == _selectedMonth;
            return GestureDetector(
              onTap: () => _selectMonth(i + 1),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                color: isActive ? const Color(0xFF5A4FBF) : Colors.transparent,
                child: Center(
                  child: Text(
                    _months[i],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  // ── Calendar ───────────────────────────────────────────────────────────────
  Widget _buildCalendar() {
    final daysInMonth  = _daysInMonth(_selectedYear, _selectedMonth);
    final startOffset  = _firstWeekdayOfMonth(_selectedYear, _selectedMonth);
    final totalCells   = startOffset + daysInMonth;
    final rows         = (totalCells / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Month + year header + navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(Icons.chevron_left, color: purpleAccent, size: 26),
              ),
              const SizedBox(width: 10),
              Text(
                '${_months[_selectedMonth - 1].toUpperCase()} $_selectedYear',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: purpleAccent,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(Icons.chevron_right, color: purpleAccent, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Weekday headers
          Row(
            children: _weekDays.map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 8),
          // Date grid
          ...List.generate(rows, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final day       = cellIndex - startOffset + 1;
                  final valid     = day >= 1 && day <= daysInMonth;

                  if (!valid) return const Expanded(child: SizedBox(height: 44));

                  final today    = _isToday(day);
                  final selected = _isSelected(day);
                  final hasEvent = _hasEvent(day);

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selectedDate = DateTime(_selectedYear, _selectedMonth, day);
                      }),
                      child: Container(
                        height: 44,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: today ? Border.all(color: purpleAccent, width: 1.5) : null,
                          color: selected && !today ? purpleAccent : Colors.transparent,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$day',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: today || selected ? FontWeight.w700 : FontWeight.w400,
                                  color: selected && !today
                                      ? Colors.white
                                      : today
                                          ? purpleAccent
                                          : Colors.black87,
                                ),
                              ),
                              if (hasEvent)
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: selected ? Colors.white : purpleAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Right event panel ──────────────────────────────────────────────────────
  Widget _buildEventPanel() {
    final events = _eventsForSelected;

    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4FF),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(
          left: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatSelectedDate(),
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'No event for today.. so take a rest! 😊',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            ...events.map((e) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: purpleLight),
                boxShadow: [
                  BoxShadow(
                    color: purpleAccent.withOpacity(0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: purpleAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      e,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}