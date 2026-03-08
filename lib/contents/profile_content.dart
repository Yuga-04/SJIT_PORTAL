import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/profile_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
//  ProfileContent
// ════════════════════════════════════════════════════════════════════════════
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── PERSONAL DETAILS ──────────────────────────────────────────────
          _SectionHeader(icon: Icons.person_rounded, label: 'Personal')
              .animate().fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          MultiPageFlipCard(
            avatarAsset: 'assets/images/profile.png',
            pages: const [
              PageData('Personal Details', [
                FieldData('Roll',          '23IT1251'),
                FieldData('Reg. No',       '312423205253'),
                FieldData('Name',          'YUGA T'),
                FieldData('Gender',        'Male'),
                FieldData('Blood Group',   'B +ve'),
                FieldData('Batch',         '2023-2027'),
              ]),
              PageData('Contact & Course', [
                FieldData('Course',        'BTECH'),
                FieldData('Department',    'IT'),
                FieldData('Section',       'D'),
                FieldData('Mobile No.',    '8682812310'),
                FieldData('Mail ID',       'ec1yugat@gmail.com'),
                FieldData('Food',          'NV'),
                FieldData('Accommodation', 'HOSTEL'),
              ]),
            ],
          ).animate(delay: 40.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 20),

          // ── FAMILY ────────────────────────────────────────────────────────
          _SectionHeader(icon: Icons.family_restroom_rounded, label: 'Family')
              .animate(delay: 55.ms).fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          MultiPageFlipCard(
            avatarAsset: 'assets/images/men.jpg',
            pages: const [
              PageData("Father's Details", [
                FieldData("Father's Name",  'THIYAGARAJAN R'),
                FieldData('Qualification',  '10th'),
                FieldData('Occupation',     'FARMER'),
                FieldData('Designation',    'FARMER'),
              ]),
              PageData("Father's Contact", [
                FieldData('Address',
                    '417, UTHANGARAI KADU, RAYARPALAYAM,\nPETHANUR (POST), CHINNASALEM,\nKALLAKURICHI - 606 201'),
                FieldData('Landline', 'NA'),
                FieldData('Mobile',   '9944412310'),
                FieldData('Mail ID',  'thiyagarajanyuga@gmail.com'),
              ]),
            ],
          ).animate(delay: 65.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 12),

          MultiPageFlipCard(
            avatarAsset: 'assets/images/woman.jpg',
            pages: const [
              PageData("Mother's Details", [
                FieldData("Mother's Name", 'KOKILA T'),
                FieldData('Qualification', '11th'),
                FieldData('Occupation',    'HOUSE WIFE'),
                FieldData('Designation',   'HOUSE WIFE'),
              ]),
              PageData("Mother's Contact", [
                FieldData('Address',
                    '417, UTHANGARAI KADU, RAYARPALAYAM,\nPETHANUR (POST), CHINNASALEM,\nKALLAKURICHI - 606 201'),
                FieldData('Landline', 'NA'),
                FieldData('Mobile',   '6380495502'),
                FieldData('Mail ID',  'NA'),
              ]),
            ],
          ).animate(delay: 80.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 20),

          // ── LOCAL GUARDIANS ───────────────────────────────────────────────
          _SectionHeader(
                  icon: Icons.supervised_user_circle_rounded,
                  label: 'Local Guardians')
              .animate(delay: 95.ms).fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          MultiPageFlipCard(
            avatarAsset: 'assets/images/men.jpg',
            pages: const [
              PageData('Guardian 1 — Details', [
                FieldData('Name',     'BALASUBRAMANIAN P'),
                FieldData('Phone No.','9840505020'),
                FieldData('Door No.', '3/19 KGR MAHADEV APARTMENTS'),
              ]),
              PageData('Guardian 1 — Address', [
                FieldData('Street Name', 'VEMBULIAMMAN KOVIL STREET'),
                FieldData('Area',        'WEST KK NAGAR'),
                FieldData('City',        'CHENNAI'),
                FieldData('Pin Code',    '78'),
              ]),
            ],
          ).animate(delay: 105.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 12),

          MultiPageFlipCard(
            avatarAsset: 'assets/images/men.jpg',
            pages: const [
              PageData('Guardian 2 — Details', [
                FieldData('Name',     'DHANALAKSHMI B'),
                FieldData('Phone No.','9894624124'),
                FieldData('Door No.', '3/19'),
              ]),
              PageData('Guardian 2 — Address', [
                FieldData('Street Name', 'VEMBULIAMMAN KOVIL STREET'),
                FieldData('Area',        'WEST KK NAGAR'),
                FieldData('City',        'CHENNAI'),
                FieldData('Pin Code',    '78'),
              ]),
            ],
          ).animate(delay: 115.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 20),

          // ── PERMANENT ADDRESS ─────────────────────────────────────────────
          _SectionHeader(icon: Icons.home_rounded, label: 'Address')
              .animate(delay: 130.ms).fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          MultiPageFlipCard(
            pages: const [
              PageData('Permanent Address', [
                FieldData('Roll No.',    '23IT1251'),
                FieldData('Name',        'YUGA T'),
                FieldData('Door No.',    '417'),
                FieldData('Street Name', 'UTHANGARAI KADU'),
                FieldData('Area',        'RAYARPALAYAM'),
                FieldData('City',        'CHINNA SALEM'),
              ]),
              PageData('Address — Continued', [
                FieldData('District', 'KALLAKURICHI'),
                FieldData('State',    'TAMILNADU'),
                FieldData('Country',  'INDIA'),
                FieldData('Pin Code', '606 201'),
              ]),
            ],
          ).animate(delay: 140.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0),

          const SizedBox(height: 20),

          // ── ACADEMIC PROFILE ──────────────────────────────────────────────
          _SectionHeader(icon: Icons.school_rounded, label: 'Academic Profile')
              .animate(delay: 155.ms).fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          const _AcademicProfileSection(),

          const SizedBox(height: 20),

          // ── ACADEMIC HISTORY ──────────────────────────────────────────────
          _SectionHeader(
                  icon: Icons.history_edu_rounded, label: 'Academic History')
              .animate(delay: 200.ms).fadeIn(duration: 350.ms),
          const SizedBox(height: 10),

          const _AcademicDetailsSection(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Academic Profile
// ════════════════════════════════════════════════════════════════════════════
class _AcademicProfileSection extends StatelessWidget {
  const _AcademicProfileSection();

  static const List<PageData> _pages = [
    PageData('Admission Details', [
      FieldData('Date of Admission',       '2023-08-23'),
      FieldData('Admission Allotment',     'BC'),
      FieldData('Govt / Management',       'COUNSELING'),
      FieldData('Overall Rank',            '50721'),
      FieldData('Community Rank',          '28304'),
      FieldData('Sports Admission',        'No'),
      FieldData('Game Name',               'NA'),
      FieldData('Medium of Instruction',   'ENGLISH'),
    ]),
    PageData('Personal & Background', [
      FieldData('Date of Birth',                   '2005-11-04'),
      FieldData('Caste',                           'NATTU GOUNDER'),
      FieldData('Parents Annual Income',           '₹ 84,000'),
      FieldData('Religion',                        'Hindu'),
      FieldData('Nationality',                     'INDIAN'),
      FieldData('Mother Tongue',                   'TAMIL'),
      FieldData('NSS / YRC / NCC / Others',        'NA'),
    ]),
    PageData('Visa & Passport', [
      FieldData('Visa No.',       'NA'),
      FieldData('Type of Visa',   'NA'),
      FieldData('Visa Expiry',    'NA'),
    ], secondSection: SectionData('Passport Details', [
      FieldData('Foreign Student', 'NA'),
      FieldData('Passport No.',    'NA'),
      FieldData('Passport Expiry', 'NA'),
    ])),
    PageData('Transfer Details', [
      FieldData('Transferred From',          '12th Std'),
      FieldData('Institution',
          'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Address',
          'V KOOTROOD, NEAR SHIPFARM,\nPERYERI, SALEM'),
      FieldData('Group',                     'MATHS COMPUTER'),
      FieldData('Year of Admission',         'NA'),
      FieldData('Year of Relief',            'NA'),
      FieldData('Course Completed',          '2023'),
      FieldData('Board',                     'STATE BOARD'),
      FieldData('Medium of Study',           'ENGLISH'),
      FieldData('Reason for Discontinuation','NA'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiPageFlipCard(
      pages: _pages,
    ).animate(delay: 165.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  Academic History
// ════════════════════════════════════════════════════════════════════════════
class _AcademicDetailsSection extends StatelessWidget {
  const _AcademicDetailsSection();

  static const List<PageData> _pages = [
    PageData('10th Standard', [
      FieldData('School',                'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Marks Obtained',        'PASS'),
      FieldData('Board',                 'STATE BOARD'),
      FieldData('Medium of Instruction', 'English'),
      FieldData('Year of Passing',       '2021'),
    ]),
    PageData('12th Standard', [
      FieldData('School',                'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Marks Obtained',        '521 / 600'),
      FieldData('Board',                 'STATE BOARD'),
      FieldData('Medium of Instruction', 'English'),
      FieldData('Year of Passing',       '2023'),
    ]),
    PageData('Diploma', [
      FieldData('College',               'NA'),
      FieldData('Marks Obtained',        'NA'),
      FieldData('Board',                 'NA'),
      FieldData('Medium of Instruction', 'NA'),
      FieldData('Year of Passing',       'NA'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiPageFlipCard(
      pages: _pages,
    ).animate(delay: 210.ms).fadeIn(duration: 400.ms).slideY(begin: 0.04, end: 0);
  }
}

// ── Section header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SectionHeader({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.darkCard,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.darkBorder),
          ),
          child: Icon(
            icon,
            size: 15,
            color: AppTheme.accentBlue,                    // ← was Colors.white70, now blue
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.white.withValues(alpha: 0.20),
                Colors.white.withValues(alpha: 0),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}