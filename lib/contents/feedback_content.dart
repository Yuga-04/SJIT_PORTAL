import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class FeedbackContent extends StatefulWidget {
  const FeedbackContent({super.key});

  @override
  State<FeedbackContent> createState() => _FeedbackContentState();
}

class _FeedbackContentState extends State<FeedbackContent> {
  String? _academicYear;
  String? _batch;
  String? _department;
  String? _section;
  String? _semester;
  String? _theoryOrLab;
  String? _subjectCode;
  String? _staffDetails;

  final List<String> _academicYears = [
    '2023-2024',
    '2024-2025',
    '2025-2026',
    '2026-2027',
  ];
  final List<String> _batches = [
    '2021-2025',
    '2022-2026',
    '2023-2027',
    '2024-2028',
  ];
  final List<String> _departments = [
    'IT',
    'CSE',
    'ECE',
    'EEE',
    'MECH',
    'CIVIL',
  ];
  final List<String> _sections = ['A', 'B', 'C', 'D', 'E'];
  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6',
    'Semester 7',
    'Semester 8',
  ];
  final List<String> _theoryOrLabOptions = ['Theory', 'Laboratory'];
  final List<String> _subjects = [
    '23IT501 - Machine Learning',
    '23IT502 - Cloud Computing',
    '23IT503 - Information Security',
    '23IT504 - Big Data Analytics',
  ];
  final List<String> _staffList = [
    'Dr. A. Kumar - ML',
    'Prof. B. Raj - Cloud',
    'Dr. C. Priya - Security',
  ];

  void _submit() {
    if (_academicYear == null ||
        _batch == null ||
        _department == null ||
        _section == null ||
        _semester == null ||
        _theoryOrLab == null ||
        _subjectCode == null ||
        _staffDetails == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields before submitting.',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }
    // TODO: submit to API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Feedback submitted successfully!',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          // White card — matches image exactly
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                Text(
                  'Feedback',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryDark,
                  ),
                ),
                const SizedBox(height: 28),

                // Row 1: Academic Year + Batch
                _buildRow(
                  left: _buildDropdownField(
                    label: 'Academic Year',
                    value: _academicYear,
                    items: _academicYears,
                    onChanged: (val) => setState(() => _academicYear = val),
                  ),
                  right: _buildDropdownField(
                    label: 'Batch',
                    value: _batch,
                    items: _batches,
                    onChanged: (val) => setState(() => _batch = val),
                  ),
                ),
                const SizedBox(height: 20),

                // Row 2: Department + Section
                _buildRow(
                  left: _buildDropdownField(
                    label: 'Department',
                    value: _department,
                    items: _departments,
                    onChanged: (val) => setState(() => _department = val),
                  ),
                  right: _buildDropdownField(
                    label: 'Section',
                    value: _section,
                    items: _sections,
                    onChanged: (val) => setState(() => _section = val),
                  ),
                ),
                const SizedBox(height: 20),

                // Row 3: Semester + Theory or Laboratory
                _buildRow(
                  left: _buildDropdownField(
                    label: 'Semester',
                    value: _semester,
                    items: _semesters,
                    onChanged: (val) => setState(() => _semester = val),
                  ),
                  right: _buildDropdownField(
                    label: 'Theory or Laboratory',
                    value: _theoryOrLab,
                    items: _theoryOrLabOptions,
                    onChanged: (val) => setState(() => _theoryOrLab = val),
                  ),
                ),
                const SizedBox(height: 20),

                // Row 4: Subject Code + Staff Details
                // Row 4: Subject Code + Staff Details (bottom-aligned for 2-line label)
                _buildRow(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  left: _buildDropdownField(
                    label: 'Subject Code & Subject Name',
                    value: _subjectCode,
                    items: _subjects,
                    onChanged: (val) => setState(() => _subjectCode = val),
                  ),
                  right: _buildDropdownField(
                    label: 'Staff Details',
                    value: _staffDetails,
                    items: _staffList,
                    onChanged: (val) => setState(() => _staffDetails = val),
                  ),
                ),
                const SizedBox(height: 36),

                // Submit button
                SizedBox(
                  width: 220,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'SUBMIT',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow({
    required Widget left,
    required Widget right,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Pre-fill matching defaults from image
    final String hint = value == null ? _defaultHint(label) : value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.primaryDark,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppTheme.borderColor, width: 1.2),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                hint,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppTheme.primaryDark,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: AppTheme.primaryDark,
                size: 20,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(8),
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppTheme.primaryDark,
              ),
              onChanged: onChanged,
              items: items
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: GoogleFonts.poppins(fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  String _defaultHint(String label) {
    switch (label) {
      case 'Academic Year':
        return '2025-2026';
      case 'Batch':
        return '2023-2027';
      case 'Department':
        return 'IT';
      case 'Section':
        return 'D';
      default:
        return 'Select';
    }
  }
}
