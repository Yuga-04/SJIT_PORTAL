import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

// ── Models ────────────────────────────────────────────────────────────────────
class FeeItem {
  final String particular;
  final int amount;
  const FeeItem(this.particular, this.amount);
}

class PaidRecord {
  final int sNo;
  final String rollNo;
  final String sem;
  final String txnDate;
  const PaidRecord({
    required this.sNo,
    required this.rollNo,
    required this.sem,
    required this.txnDate,
  });
}

class FeeSection {
  final String title;
  final String sectionLabel;
  final List<FeeItem> items;
  final List<PaidRecord> paidRecords;
  final bool showPayment;

  const FeeSection({
    required this.title,
    required this.sectionLabel,
    required this.items,
    required this.paidRecords,
    this.showPayment = false,
  });
}

// ── Shared text styles ────────────────────────────────────────────────────────
TextStyle _headerStyle() => GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

TextStyle _cellStyle({bool bold = false}) => GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: AppTheme.primaryDark,
    );

// ─────────────────────────────────────────────────────────────────────────────
class FeeContent extends StatelessWidget {
  const FeeContent({super.key});

  static const List<FeeSection> _sections = [
    FeeSection(
      title: 'Academic Fee [ 2026-2027 ]',
      sectionLabel: 'Fee Structure',
      showPayment: true,
      items: [
        FeeItem('Tution Fee', 145000),
        FeeItem('Development Fee', 5000),
        FeeItem('Placement & Training Fee', 47000),
        FeeItem('Other Amenities & Facilities Fee', 115000),
        FeeItem(
            'Additional Training for Personality & Career Development Fee',
            20000),
        FeeItem('Total Payable', 332000),
      ],
      paidRecords: [],
    ),
    FeeSection(
      title: 'POP-II Fee - SEM 05',
      sectionLabel: 'Already Paid',
      items: [],
      paidRecords: [
        PaidRecord(
            sNo: 1,
            rollNo: '23IT1143',
            sem: '05',
            txnDate: '17/11/2025 11:54:18'),
      ],
    ),
    FeeSection(
      title: 'Hostel Fee - SEM 07',
      sectionLabel: 'Already Paid',
      items: [],
      paidRecords: [
        PaidRecord(
            sNo: 1,
            rollNo: '23IT1143',
            sem: '07',
            txnDate: '23/02/2026 15:19:11'),
      ],
    ),
    FeeSection(
      title: 'Exam Fee - SEM 07',
      sectionLabel: 'Already Paid',
      items: [],
      paidRecords: [
        PaidRecord(
            sNo: 1,
            rollNo: '23IT1143',
            sem: '07',
            txnDate: '10/01/2026 09:45:00'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _sections.map((s) => _buildCard(context, s)).toList(),
      ),
    );
  }

  // ── White card wrapper ─────────────────────────────────────────────────────
  Widget _buildCard(BuildContext context, FeeSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              section.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppTheme.primaryDark,
              ),
            ),
            const SizedBox(height: 16),

            // Fee structure
            if (section.items.isNotEmpty) ...[
              Text(section.sectionLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark)),
              const SizedBox(height: 12),
              _buildFeeTable(section.items),
            ],

            // Payment methods
            if (section.showPayment) ...[
              const SizedBox(height: 24),
              Text('Payment Methods',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryDark)),
              const SizedBox(height: 10),
              Text(
                'Important Note: Once a payment mode is chosen and initiated or partially paid, it cannot be changed later.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade600,
                ),
              ),
              const SizedBox(height: 12),
              _buildPaymentBlock(),
            ],

            // Already paid
            if (section.paidRecords.isNotEmpty) ...[
              Text(section.sectionLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark)),
              const SizedBox(height: 10),
              _buildPaidTable(section.paidRecords),
            ],
          ],
        ),
      ),
    );
  }

  // ── Fee structure: 2-col table, Amount col fixed, Particular col flex ──────
  Widget _buildFeeTable(List<FeeItem> items) {
    const borderColor = Color(0xFFD1D5DB);
    const border      = BorderSide(color: borderColor, width: 0.8);

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Column(
        children: [
          // Header row
          Container(
            color: AppTheme.primaryDark,
            child: Row(
              children: [
                Expanded(
                  child: _fCell('Particulars',
                      isHeader: true, align: TextAlign.center),
                ),
                Container(width: 0.8, color: borderColor),
                SizedBox(
                  width: 90,
                  child: _fCell('Amount(Rs.)',
                      isHeader: true, align: TextAlign.center),
                ),
              ],
            ),
          ),
          // Data rows
          ...items.map((item) {
            final isTotal = item.particular == 'Total Payable';
            return Container(
              decoration: BoxDecoration(
                color: isTotal ? const Color(0xFFF0F0F0) : Colors.white,
                border: const Border(bottom: border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _fCell(item.particular,
                        bold: isTotal, align: TextAlign.left),
                  ),
                  Container(width: 0.8, color: borderColor),
                  SizedBox(
                    width: 90,
                    child: _fCell(item.amount.toString(),
                        bold: isTotal, align: TextAlign.right),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── Payment block: stacked on mobile ──────────────────────────────────────
  Widget _buildPaymentBlock() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Column(
        children: [
          // Header
          Container(
            color: AppTheme.primaryDark,
            child: Row(
              children: [
                Expanded(
                  child: _fCell('Payment Methods',
                      isHeader: true, align: TextAlign.center),
                ),
                Container(
                    width: 0.8, color: const Color(0xFFD1D5DB)),
                SizedBox(
                  width: 110,
                  child: _fCell('Payment',
                      isHeader: true, align: TextAlign.center),
                ),
              ],
            ),
          ),
          // Body row
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD1D5DB), width: 0.8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Text info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Pay via Netbanking/Debit Card/\nCredit Card/Other',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '(The entire amount is paid in a single transaction.)',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.red.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Divider
                Container(
                    height: 80,
                    width: 0.8,
                    color: const Color(0xFFD1D5DB)),
                // Button
                SizedBox(
                  width: 110,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: payment gateway
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentBlue,
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'CLICK TO PAY',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
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

  // ── Already paid: no scroll, all columns fit, download icon top-right ──────
  Widget _buildPaidTable(List<PaidRecord> records) {
    const borderColor = Color(0xFFD1D5DB);
    const vDivider    = VerticalDivider(
        width: 1, thickness: 0.8, color: borderColor);

    // flex weights: S.No=2, RollNo=3, Sem=2, TxnDate=4, Receipt=2
    Widget hCell(String text, {int flex = 2}) => Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );

    Widget dCell(String text, {int flex = 2}) => Expanded(
          flex: flex,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Text(
              text,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppTheme.primaryDark,
              ),
            ),
          ),
        );

    // Receipt cell — file-arrow-down style icon, centered
    Widget receiptDataCell() => Expanded(
          flex: 2,
          child: Center(
            child: GestureDetector(
              onTap: () {
                // TODO: download receipt
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: AppTheme.accentBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  size: 18,
                  color: AppTheme.accentBlue,
                ),
              ),
            ),
          ),
        );

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Container(
            color: AppTheme.primaryDark,
            child: IntrinsicHeight(
              child: Row(children: [
                hCell('S.No',     flex: 2),
                vDivider,
                hCell('Roll No',  flex: 3),
                vDivider,
                hCell('Sem',      flex: 2),
                vDivider,
                hCell('Txn Date', flex: 4),
                vDivider,
                hCell('Receipt',  flex: 2),
              ]),
            ),
          ),
          // Data rows
          ...records.asMap().entries.map((entry) {
            final i  = entry.key;
            final r  = entry.value;
            final bg = i % 2 == 0 ? Colors.white : const Color(0xFFF8F9FF);
            return Container(
              decoration: BoxDecoration(
                color: bg,
                border: const Border(
                  top:   BorderSide(color: borderColor, width: 0.8),
                  left:  BorderSide(color: borderColor, width: 0.8),
                  right: BorderSide(color: borderColor, width: 0.8),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(children: [
                  dCell('${r.sNo}', flex: 2),
                  vDivider,
                  dCell(r.rollNo,   flex: 3),
                  vDivider,
                  dCell(r.sem,      flex: 2),
                  vDivider,
                  dCell(r.txnDate,  flex: 4),
                  vDivider,
                  receiptDataCell(),
                ]),
              ),
            );
          }),
          // Bottom border
          Container(height: 0.8, color: borderColor),
        ],
      ),
    );
  }

  // ── Generic cell for fee/payment tables ───────────────────────────────────
  Widget _fCell(
    String text, {
    bool isHeader = false,
    bool bold     = false,
    TextAlign align = TextAlign.left,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Text(
        text,
        textAlign: align,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: isHeader || bold ? FontWeight.w700 : FontWeight.w400,
          color: isHeader ? Colors.white : AppTheme.primaryDark,
        ),
      ),
    );
  }
}