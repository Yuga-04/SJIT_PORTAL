import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Attendance status ────────────────────────────────────────────────────────
enum AttendanceStatus { present, absent, leave, holiday }

class DayAttendance {
  final AttendanceStatus status;
  final String? timeRange; // e.g. "08:00AM - 03:00PM"
  final String? note;      // e.g. "OD"

  const DayAttendance({
    required this.status,
    this.timeRange,
    this.note,
  });
}

// ── Constants ────────────────────────────────────────────────────────────────
const Color _purple      = Color(0xFF6C63FF);
const Color _sidebarBg   = Color(0xFF7C6FD0);
const Color _sidebarDark = Color(0xFF5A4FBF);
const Color _dotBlue     = Color(0xFF2196F3);
const Color _dotGreen    = Color(0xFF4CAF50);
const Color _dotRed      = Color(0xFFF44336);
const Color _panelBg     = Color(0xFFF5F4FF);

class AttendanceContent extends StatefulWidget {
  const AttendanceContent({super.key});

  @override
  State<AttendanceContent> createState() => _AttendanceContentState();
}

class _AttendanceContentState extends State<AttendanceContent> {
  int _year  = DateTime.now().year;
  int _month = DateTime.now().month;
  late DateTime _selected;

  // ── Mock data — replace with real API data ───────────────────────────────
  // Key format: 'YYYY-M-D'
  final Map<String, DayAttendance> _data = {
    '2026-2-16': const DayAttendance(
      status: AttendanceStatus.present,
      timeRange: '08:00AM - 03:00PM',
    ),
    '2026-2-17': const DayAttendance(
      status: AttendanceStatus.present,
      timeRange: '08:00AM - 03:00PM',
    ),
    '2026-2-18': const DayAttendance(
      status: AttendanceStatus.leave,
      note: 'OD',
    ),
    '2026-2-19': const DayAttendance(
      status: AttendanceStatus.present,
      timeRange: '08:00AM - 03:00PM',
    ),
    '2026-2-20': const DayAttendance(
      status: AttendanceStatus.present,
      timeRange: '08:00AM - 03:00PM',
    ),
  };

  static const _monthNames = [
    'January', 'February', 'March',    'April',   'May',      'June',
    'July',    'August',   'September','October',  'November', 'December',
  ];
  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = DateTime(_year, _month, now.day);
  }

  String _key(int y, int m, int d) => '$y-$m-$d';

  int get _daysInMonth  => DateTime(_year, _month + 1, 0).day;
  int get _firstWeekday => DateTime(_year, _month, 1).weekday % 7; // 0 = Sun

  bool _isToday(int d) {
    final n = DateTime.now();
    return d == n.day && _month == n.month && _year == n.year;
  }

  bool _isSelected(int d) =>
      d == _selected.day && _month == _selected.month && _year == _selected.year;

  void _prevMonth() => setState(() {
        if (_month == 1) {
          _month = 12;
          _year--;
        } else {
          _month--;
        }
        _selected = DateTime(_year, _month, 1);
      });

  void _nextMonth() => setState(() {
        if (_month == 12) {
          _month = 1;
          _year++;
        } else {
          _month++;
        }
        _selected = DateTime(_year, _month, 1);
      });

  void _prevYear() => setState(() {
        _year--;
        _selected = DateTime(_year, _month, 1);
      });

  void _nextYear() => setState(() {
        _year++;
        _selected = DateTime(_year, _month, 1);
      });

  // ── Root build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 12),
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
          LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final sidebarW  = (totalWidth * 0.22).clamp(90.0, 120.0);
              final panelW    = (totalWidth * 0.26).clamp(120.0, 160.0);
              return Container(
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
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildSidebar(sidebarW),
                      Expanded(child: _buildCalendar()),
                      _buildRightPanel(panelW),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ── Left sidebar ───────────────────────────────────────────────────────────
  Widget _buildSidebar(double width) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _sidebarBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          bottomLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Year navigator row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _prevYear,
                  child: const Icon(Icons.chevron_left,
                      color: Colors.white, size: 20),
                ),
                Text(
                  '$_year',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                GestureDetector(
                  onTap: _nextYear,
                  child: const Icon(Icons.chevron_right,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
          // Month list
          ...List.generate(12, (i) {
            final active = (i + 1) == _month;
            return GestureDetector(
              onTap: () => setState(() {
                _month    = i + 1;
                _selected = DateTime(_year, i + 1, 1);
              }),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 7),
                color: active ? _sidebarDark : Colors.transparent,
                child: Center(
                  child: Text(
                    _monthNames[i],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w400,
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
    final days   = _daysInMonth;
    final offset = _firstWeekday;
    final rows   = ((offset + days) / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          // Month navigation header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(Icons.chevron_left, color: _purple, size: 26),
              ),
              const SizedBox(width: 8),
              Text(
                '${_monthNames[_month - 1].toUpperCase()} $_year',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _purple,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(Icons.chevron_right, color: _purple, size: 26),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Weekday headers
          Row(
            children: _weekDays
                .map((d) => Expanded(
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
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),

          // Date grid rows
          ...List.generate(rows, (row) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: List.generate(7, (col) {
                  final idx  = row * 7 + col;
                  final day  = idx - offset + 1;
                  final valid = day >= 1 && day <= days;

                  if (!valid) {
                    return const Expanded(child: SizedBox(height: 52));
                  }

                  final today    = _isToday(day);
                  final selected = _isSelected(day);
                  final att      = _data[_key(_year, _month, day)];

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _selected = DateTime(_year, _month, day);
                      }),
                      child: Container(
                        height: 52,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: today
                              ? Border.all(
                                  color: Colors.black54, width: 1.5)
                              : null,
                          // no fill — matches screenshots
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$day',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: today || selected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            if (att != null) _buildDots(att),
                          ],
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

  /// Blue dot = working day, Green/Red dot = present / leave
  Widget _buildDots(DayAttendance att) {
    final rightColor = att.status == AttendanceStatus.present
        ? _dotGreen
        : att.status == AttendanceStatus.leave ||
                att.status == AttendanceStatus.absent
            ? _dotRed
            : Colors.grey;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(_dotBlue),
        const SizedBox(width: 3),
        _dot(rightColor),
      ],
    );
  }

  Widget _dot(Color c) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      );

  // ── Right panel ────────────────────────────────────────────────────────────
  Widget _buildRightPanel(double width) {
    final att     = _data[_key(_year, _month, _selected.day)];
    final dateStr =
        '${_monthNames[_selected.month - 1]} ${_selected.day}, ${_selected.year}';

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: _panelBg,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        border: Border(left: BorderSide(color: Colors.grey.shade200)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 12, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateStr,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (att == null) _noEventBox() else _attendanceDetails(att),
        ],
      ),
    );
  }

  Widget _noEventBox() => Container(
        padding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          'No event for today.. so take a rest! 😊',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      );

  Widget _attendanceDetails(DayAttendance att) {
    final hasWorkingDay = att.timeRange != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Working Day row (blue dot) ──────────────────────────────────
        if (hasWorkingDay) ...[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 4),
                    _dot(_dotBlue),
                    // Connector line down to next dot
                    Expanded(
                      child: Container(
                        width: 1.5,
                        color: Colors.grey.shade300,
                        margin:
                            const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Working Day',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.grey.shade300),
                        ),
                      child: Text(
                          att.timeRange!,
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            color: Colors.black54,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        // ── Status row (green / red dot) ────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: _dot(_statusColor(att.status)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _statusLabel(att.status),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (att.note != null)
                    Text(
                      att.note!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _statusColor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return _dotGreen;
      case AttendanceStatus.leave:
      case AttendanceStatus.absent:
        return _dotRed;
      default:
        return Colors.grey;
    }
  }

  String _statusLabel(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.holiday:
        return 'Holiday';
    }
  }
}