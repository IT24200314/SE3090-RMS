import 'package:flutter/material.dart';
import '../../models/tenant_application.dart';

class ApplicationStatusScreen extends StatelessWidget {
  final TenantApplication application;

  const ApplicationStatusScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final isApproved = application.status == 'Approved';
    final isReview = application.status == 'ReviewRequired';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Status', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isApproved
                    ? const Color(0x1A10B981)
                    : isReview
                        ? const Color(0x1AF59E0B)
                        : const Color(0x1A6366F1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isApproved ? Icons.verified_outlined : isReview ? Icons.pending_actions_outlined : Icons.hourglass_top_outlined,
                color: isApproved ? const Color(0xFF34D399) : isReview ? const Color(0xFFFBBF24) : const Color(0xFF818CF8),
                size: 48,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              isApproved ? 'Application Approved' : isReview ? 'Manager Review in Progress' : 'Application Submitted',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Color(0xFFF4F4F5)),
            ),
            const SizedBox(height: 4),
            Text(
              'Application ID: ${application.id.length > 12 ? application.id.substring(0, 12) : application.id}...',
              style: const TextStyle(color: Color(0xFF71717A), fontSize: 11, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 20),

            // AI Risk Evaluation Breakdown Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('AI Risk Analysis', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFFF4F4F5))),
                        Icon(Icons.auto_awesome, color: Color(0xFF818CF8), size: 16),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF09090B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0x14FFFFFF)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('CALCULATED RISK SCORE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF71717A), letterSpacing: 0.5)),
                              Text(
                                '${application.aiRiskScore} / 100',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  fontFamily: 'monospace',
                                  color: application.aiRiskScore >= 80
                                      ? const Color(0xFF34D399)
                                      : application.aiRiskScore >= 50
                                          ? const Color(0xFFFBBF24)
                                          : const Color(0xFFF87171),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('VERIFIED INCOME', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF71717A), letterSpacing: 0.5)),
                              Text(
                                'LKR ${application.monthlyIncome.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'monospace', color: Color(0xFFF4F4F5)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (application.aiScreeningNotes != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF18181B),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0x14FFFFFF)),
                        ),
                        child: Text(
                          application.aiScreeningNotes!,
                          style: const TextStyle(fontSize: 11, height: 1.4, color: Color(0xFFA1A1AA)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF18181B),
                  foregroundColor: const Color(0xFFF4F4F5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0x1FFFFFFF)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to Listings', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
