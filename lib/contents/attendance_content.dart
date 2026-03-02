import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Models ───────────────────────────────────────────────────────────────────
enum AttendanceStatus { present, absent, leave, holiday }

class DayAttendance {
  final AttendanceStatus status;
  final String? timeRange;
  final String? note;
  const DayAttendance({required this.status, this.timeRange, this.note});
}

// ── Theme constants ──────────────────────────────────────────────────────────
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

  // ── Mock data — replace with API ─────────────────────────────────────────
  final Map<String, DayAttendance> _data = {
    '2026-2-16': const DayAttendance(status: AttendanceStatus.present, timeRange: '08:00AM - 03:00PM'),
    '2026-2-17': const DayAttendance(status: AttendanceStatus.present, timeRange: '08:00AM - 03:00PM'),
    '2026-2-18': const DayAttendance(status: AttendanceStatus.leave,   note: 'OD'),
    '2026-2-19': const DayAttendance(status: AttendanceStatus.present, timeRange: '08:00AM - 03:00PM'),
    '2026-2-20': const DayAttendance(status: AttendanceStatus.present, timeRange: '08:00AM - 03:00PM'),
  };

  static const _monthNames = [
    'January','February','March','April','May','June',
    'July','August','September','October','November','December',
  ];
  static const _weekDays = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];

  @override
  void initState() {
    super.initState();
    _selected = DateTime(_year, _month, DateTime.now().day);
  }

  String _key(int y, int m, int d) => '$y-$m-$d';
  int get _daysInMonth  => DateTime(_year, _month + 1, 0).day;
  int get _firstWeekday => DateTime(_year, _month, 1).weekday % 7;

  bool _isToday(int d) {
    final n = DateTime.now();
    return d == n.day && _month == n.month && _year == n.year;
  }

  void _prevMonth() => setState(() {
    _month == 1 ? (_month = 12, _year--) : _month--;
    _selected = DateTime(_year, _month, 1);
  });

  void _nextMonth() => setState(() {
    _month == 12 ? (_month = 1, _year++) : _month++;
    _selected = DateTime(_year, _month, 1);
  });

  void _prevYear() => setState(() { _year--; _selected = DateTime(_year, _month, 1); });
  void _nextYear() => setState(() { _year++; _selected = DateTime(_year, _month, 1); });

  // ── Root ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title — same style as HomeContent
          Center(
            child: Text(
              'Attendance Report',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // White card — same shadow/radius style as HomeContent card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // ── Top row: sidebar + calendar ──────────────────────────
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sidebar — fixed narrow width
                      _buildSidebar(),
                      // Calendar — takes all remaining space
                      Expanded(child: _buildCalendar()),
                    ],
                  ),
                ),

                // ── Divider ──────────────────────────────────────────────
                Divider(height: 1, color: Colors.grey.shade200),

                // ── Bottom panel: selected date detail ───────────────────
                _buildBottomPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Left sidebar ──────────────────────────────────────────────────────────
  Widget _buildSidebar() {
    return Container(
      width: 90,
      decoration: const BoxDecoration(
        color: _sidebarBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(14),
        ),
      ),
      child: Column(
        children: [
          // Year row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: _prevYear,
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 18),
                ),
                Text(
                  '$_year',
                  style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13,
                  ),
                ),
                GestureDetector(
                  onTap: _nextYear,
                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 18),
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
                padding: const EdgeInsets.symmetric(vertical: 6),
                color: active ? _sidebarDark : Colors.transparent,
                child: Center(
                  child: Text(
                    _monthNames[i],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Calendar grid ─────────────────────────────────────────────────────────
  Widget _buildCalendar() {
    final days   = _daysInMonth;
    final offset = _firstWeekday;
    final rows   = ((offset + days) / 7).ceil();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 12),
      child: Column(
        children: [
          // Month + nav
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _prevMonth,
                child: Icon(Icons.chevron_left, color: _purple, size: 22),
              ),
              const SizedBox(width: 6),
              Text(
                '${_monthNames[_month - 1].toUpperCase()} $_year',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _purple,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _nextMonth,
                child: Icon(Icons.chevron_right, color: _purple, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Weekday labels
          Row(
            children: _weekDays.map((d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black45,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 6),

          // Date rows
          ...List.generate(rows, (row) => Row(
            children: List.generate(7, (col) {
              final idx   = row * 7 + col;
              final day   = idx - offset + 1;
              final valid = day >= 1 && day <= days;

              if (!valid) return const Expanded(child: SizedBox(height: 44));

              final today    = _isToday(day);
              final selected = _selected.day == day &&
                               _selected.month == _month &&
                               _selected.year  == _year;
              final att      = _data[_key(_year, _month, day)];

              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _selected = DateTime(_year, _month, day);
                  }),
                  child: SizedBox(
                    height: 44,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Date circle
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: today
                                ? Border.all(color: Colors.black54, width: 1.5)
                                : selected
                                    ? Border.all(color: _purple, width: 1.5)
                                    : null,
                          ),
                          child: Center(
                            child: Text(
                              '$day',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: today || selected
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: today
                                    ? Colors.black87
                                    : selected
                                        ? _purple
                                        : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        // Dots
                        if (att != null) ...[
                          const SizedBox(height: 2),
                          _buildDots(att),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            }),
          )),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildDots(DayAttendance att) {
    final rightColor = att.status == AttendanceStatus.present
        ? _dotGreen
        : (att.status == AttendanceStatus.leave || att.status == AttendanceStatus.absent)
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
    width: 5, height: 5,
    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
  );

  // ── Bottom detail panel ───────────────────────────────────────────────────
  Widget _buildBottomPanel() {
    final att     = _data[_key(_year, _month, _selected.day)];
    final dateStr = '${_monthNames[_selected.month - 1]} ${_selected.day}, ${_selected.year}';

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _panelBg,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
          const SizedBox(height: 12),
          if (att == null)
            _noEventBox()
          else
            _attendanceDetails(att),
        ],
      ),
    );
  }

  Widget _noEventBox() => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Text(
      'No event for today.. so take a rest! 😊',
      style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
    ),
  );

  Widget _attendanceDetails(DayAttendance att) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Working Day column (blue dot + connector + green/red dot)
        if (att.timeRange != null) ...[
          _detailItem(
            dotColor: _dotBlue,
            title: 'Working Day',
            subtitle: att.timeRange,
            showConnector: true,
          ),
          const SizedBox(width: 24),
        ],
        _detailItem(
          dotColor: _statusColor(att.status),
          title: _statusLabel(att.status),
          subtitle: att.note,
          showConnector: false,
        ),
      ],
    );
  }

  Widget _detailItem({
    required Color dotColor,
    required String title,
    String? subtitle,
    required bool showConnector,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot (+ optional vertical connector if subtitle is shown)
        Column(
          children: [
            const SizedBox(height: 4),
            _dot(dotColor),
            if (showConnector && subtitle != null) ...[
              Container(width: 1.5, height: 30, color: Colors.grey.shade300,
                  margin: const EdgeInsets.symmetric(vertical: 3)),
            ],
          ],
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  subtitle,
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.black54),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Color _statusColor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return _dotGreen;
      case AttendanceStatus.leave:
      case AttendanceStatus.absent:  return _dotRed;
      default:                       return Colors.grey;
    }
  }

  String _statusLabel(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return 'Present';
      case AttendanceStatus.leave:   return 'Leave';
      case AttendanceStatus.absent:  return 'Absent';
      case AttendanceStatus.holiday: return 'Holiday';
    }
  }
}