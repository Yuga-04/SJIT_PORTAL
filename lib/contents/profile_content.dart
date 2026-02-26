import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/profile_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
//  ProfileContent  —  assembles all profile cards
// ════════════════════════════════════════════════════════════════════════════
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
      child: Column(
        children: [
          FlipCard(
            index: 0,
            avatarAsset: 'assets/images/profile.png',
            title: 'Personal Details',
            frontFields: const [
              FieldData('Roll', '23IT1251'),
              FieldData('Reg. No', '312423205253'),
              FieldData('Name', 'YUGA T'),
              FieldData('Gender', 'Male'),
              FieldData('Blood Group', 'B +ve'),
              FieldData('Batch', '2023-2027'),
            ],
            backFields: const [
              FieldData('Course', 'BTECH'),
              FieldData('Department', 'IT'),
              FieldData('Section', 'D'),
              FieldData('Mobile No.', '8682812310'),
              FieldData('Mail ID', 'ec1yugat@gmail.com'),
              FieldData('Food', 'NV'),
              FieldData('Accommodation', 'HOSTEL'),
            ],
          ).animate(delay: 0.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),

          FlipCard(
            index: 1,
            avatarAsset: 'assets/images/men.jpg',
            title: 'Father Details',
            frontFields: const [
              FieldData("Father's Name", 'THIYAGARAJAN R'),
              FieldData('Qualification', '10th'),
              FieldData('Occupation', 'FARMER'),
              FieldData('Designation', 'FARMER'),
            ],
            backFields: const [
              FieldData('Address',
                  '417, UTHANGARAI KADU, RAYARPALAYAM, PETHANUR (POST), CHINNASALEM, KALLAKURICHI - 606 201'),
              FieldData('Landline', 'NA'),
              FieldData('Mobile', '9944412310'),
              FieldData('Mail ID', 'thiyagarajanyuga@gmail.com'),
            ],
          ).animate(delay: 70.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),

          FlipCard(
            index: 2,
            avatarAsset: 'assets/images/woman.jpg',
            title: 'Mother Details',
            frontFields: const [
              FieldData("Mother's Name", 'KOKILA T'),
              FieldData('Qualification', '11th'),
              FieldData('Occupation', 'HOUSE WIFE'),
              FieldData('Designation', 'HOUSE WIFE'),
            ],
            backFields: const [
              FieldData('Address',
                  '417, UTHANGARAI KADU, RAYARPALAYAM, PETHANUR (POST), CHINNASALEM, KALLAKURICHI - 606 201'),
              FieldData('Landline', 'NA'),
              FieldData('Mobile', '6380495502'),
              FieldData('Mail ID', 'NA'),
            ],
          ).animate(delay: 130.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),

          FlipCard(
            index: 3,
            avatarAsset: 'assets/images/men.jpg',
            title: 'Local Guardian - 1 Details',
            frontFields: const [
              FieldData('Name', 'BALASUBRAMANIAN P'),
              FieldData('Phone No.', '9840505020'),
              FieldData('Door No.', '3/19 KGR MAHADEV APARTMENTS'),
            ],
            backFields: const [
              FieldData('Street Name', 'VEMBULIAMMAN KOVIL STREET'),
              FieldData('Area', 'WEST KK NAGAR'),
              FieldData('City', 'CHENNAI'),
              FieldData('Pin Code', '78'),
            ],
          ).animate(delay: 190.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),

          FlipCard(
            index: 4,
            avatarAsset: 'assets/images/men.jpg',
            title: 'Local Guardian - 2 Details',
            frontFields: const [
              FieldData('Name', 'DHANALAKSHMI B'),
              FieldData('Phone No.', '9894624124'),
              FieldData('Door No.', '3/19'),
            ],
            backFields: const [
              FieldData('Street Name', 'VEMBULIAMMAN KOVIL STREET'),
              FieldData('Area', 'WEST KK NAGAR'),
              FieldData('City', 'CHENNAI'),
              FieldData('Pin Code', '78'),
            ],
          ).animate(delay: 250.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),

          FlipCard(
            index: 5,
            title: 'General Details',
            frontFields: const [
              FieldData('Roll No.', '23IT1251'),
              FieldData('Name', 'YUGA T'),
              FieldData('Door No.', '417'),
              FieldData('Street Name', 'UTHANGARAI KADU'),
              FieldData('Area', 'RAYARPALAYAM'),
              FieldData('City', 'CHINNA SALEM'),
            ],
            backFields: const [
              FieldData('District', 'KALLAKURICHI'),
              FieldData('State', 'TAMILNADU'),
              FieldData('Country', 'INDIA'),
              FieldData('Pin Code', '606 201'),
            ],
          ).animate(delay: 310.ms).fadeIn(duration: 450.ms).slideY(begin: 0.06, end: 0),

          const SizedBox(height: 16),
          const _AcademicProfileSection(),
          const SizedBox(height: 16),
          const _AcademicDetailsSection(),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  _AcademicProfileSection
// ════════════════════════════════════════════════════════════════════════════
class _AcademicProfileSection extends StatelessWidget {
  const _AcademicProfileSection();

  static const List<PageData> _pages = [
    PageData('Admission Details', [
      FieldData('Date of Admission', '2023-08-23'),
      FieldData('Admission Allotment', 'BC'),
      FieldData('Government / Management', 'COUNSELING'),
      FieldData('Overall Rank', '50721'),
      FieldData('Community Rank', '28304'),
      FieldData('Sports Admission', 'No'),
      FieldData('Game Name', 'NA'),
      FieldData('Medium of Instruction', 'ENGLISH'),
    ]),
    PageData('General Details', [
      FieldData('Date of Birth', '2005-11-04'),
      FieldData('Caste', 'NATTU GOUNDER'),
      FieldData('Parents Annual Income', '84000'),
      FieldData('Religion', 'Hindu'),
      FieldData('Nationality', 'INDIAN'),
      FieldData('Mother Tongue', 'TAMIL'),
      FieldData('Member of (NSS/YRC/NCC/others)', 'NA'),
    ]),
    PageData(
      'Visa Details',
      [
        FieldData('Visa No.', 'NA'),
        FieldData('Type of Visa', 'NA'),
        FieldData('Date of Expiry', 'NA'),
      ],
      secondSection: SectionData('Passport Details', [
        FieldData('Foreign Student', 'NA'),
        FieldData('Passport No.', 'NA'),
        FieldData('Date of Expiry', 'NA'),
      ]),
    ),
    PageData('Other Details (Transferred Student)', [
      FieldData('Transferred From', '12'),
      FieldData('Institution Name', 'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Address', 'V KOOTROOD, NEAR SHIPFARM, PERYERI, SALEM'),
      FieldData('Group', 'MATHS COMPUTER'),
      FieldData('Year and Month of Admission', 'NA'),
      FieldData('Year and Month of Relief', 'NA'),
      FieldData('Course Completed in Time', '2023'),
      FieldData('Board', 'STATE BOARD'),
      FieldData('Medium of Study', 'ENGLISH'),
      FieldData('Reason for Discontinuation', 'NA'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiPageFlipCard(pages: _pages)
        .animate()
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.06, end: 0);
  }
}

// ════════════════════════════════════════════════════════════════════════════
//  _AcademicDetailsSection
// ════════════════════════════════════════════════════════════════════════════
class _AcademicDetailsSection extends StatelessWidget {
  const _AcademicDetailsSection();

  static const List<PageData> _pages = [
    PageData('Academic Details — TENTH', [
      FieldData('10th School', 'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Marks Obtained', 'PASS'),
      FieldData('Board', 'STATE BOARD'),
      FieldData('Medium of Instruction', 'English'),
      FieldData('Year of Passing', '2021'),
    ]),
    PageData('Academic Details — TWELFTH', [
      FieldData('12th School', 'SRM MUTHAMIZHL HIGHER SECONDARY SCHOOL'),
      FieldData('Marks Obtained', '521'),
      FieldData('Board', 'STATE BOARD'),
      FieldData('Medium of Instruction', 'English'),
      FieldData('Year of Passing', '2023'),
    ]),
    PageData('Academic Details — DIPLOMA', [
      FieldData('Diploma College', 'NA'),
      FieldData('Marks Obtained', 'NA'),
      FieldData('Board', 'NA'),
      FieldData('Medium of Instruction', 'NA'),
      FieldData('Year of Passing', 'NA'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiPageFlipCard(pages: _pages)
        .animate(delay: 310.ms)
        .fadeIn(duration: 450.ms)
        .slideY(begin: 0.06, end: 0);
  }
}