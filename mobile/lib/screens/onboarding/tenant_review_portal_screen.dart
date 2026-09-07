import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/risk_score_gauge.dart';
import 'identity_verification_modal.dart';
import 'tenant_application_screen.dart';

class TenantReviewPortalScreen extends StatefulWidget {
  const TenantReviewPortalScreen({super.key});

  @override
  State<TenantReviewPortalScreen> createState() => _TenantReviewPortalScreenState();
}

class _TenantReviewPortalScreenState extends State<TenantReviewPortalScreen> {
  String _activeTab = 'ALL';
  String? _evaluatingId;

  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'c1d2e3f4-a5b6-7c8d-9e0f-1a2b3c4d5e6f',
      'applicantName': 'Kamal Perera',
      'applicantAvatar': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      'tenantId': 't1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6',
      'propertyId': 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
      'propertyTitle': 'Oceanfront Luxury Suite',
      'monthlyRent': 220000.0,
      'monthlyIncome': 650000.0,
      'identityDocUrl': 'https://cdn.rms.local/kyc/nic_kamal_perera.pdf',
      'status': 'Approved', // 1
      'aiRiskScore': 92,
      'aiScreeningNotes': 'Low risk profile: Tenant income securely covers rent (33.8% debt-to-income ratio). Identity verified against National Registry.',
      'createdAtUtc': DateTime.now(),
    },
    {
      'id': 'd2e3f4a5-b6c7-8d9e-0f1a-2b3c4d5e6f7a',
      'applicantName': 'Anura De Silva',
      'applicantAvatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
      'tenantId': 't2b3c4d5-e6f7-a8b9-c0d1-e2f3a4b5c6d7',
      'propertyId': 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
      'propertyTitle': 'Cinnamon Gardens Townhouse',
      'monthlyRent': 350000.0,
      'monthlyIncome': 750000.0,
      'identityDocUrl': 'https://cdn.rms.local/kyc/nic_anura_silva.pdf',
      'status': 'ReviewRequired', // 3 (HITL)
      'aiRiskScore': 68,
      'aiScreeningNotes': 'Moderate risk: Rent accounts for 46.7% of monthly income (exceeds 40% optimal ceiling). Flagged for HITL Manager Approval.',
      'createdAtUtc': DateTime.now(),
    },
    {
      'id': 'e3f4a5b6-c7d8-9e0f-1a2b-3c4d5e6f7a8b',
      'applicantName': 'Ruwan Fernando',
      'applicantAvatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
      'tenantId': 't3c4d5e6-f7a8-b9c0-d1e2-f3a4b5c6d7e8',
      'propertyId': 'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
      'propertyTitle': 'Havelock City Studio Apartment',
      'monthlyRent': 95000.0,
      'monthlyIncome': 175000.0,
      'identityDocUrl': 'https://cdn.rms.local/kyc/nic_ruwan_fernando.pdf',
      'status': 'Pending', // 0
      'aiRiskScore': 54,
      'aiScreeningNotes': 'Debt-to-income ratio at 54.2% (> 50% high threshold). Requires secondary guarantor or risk bond.',
      'createdAtUtc': DateTime.now(),
    }
  ];

  List<Map<String, dynamic>> get _filteredApplications {
    return _applications.where((app) {
      if (_activeTab == 'ALL') return true;
      if (_activeTab == 'HITL') return app['status'] == 'ReviewRequired' || app['status'] == 3;
      if (_activeTab == 'APPROVED') return app['status'] == 'Approved' || app['status'] == 1;
      if (_activeTab == 'PENDING') return app['status'] == 'Pending' || app['status'] == 0;
      return true;
    }).toList();
  }

  void _runRiskAi(String id) {
    HapticFeedback.mediumImpact();
    setState(() => _evaluatingId = id);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          final idx = _applications.indexWhere((a) => a['id'] == id);
          if (idx != -1) {
            final rent = _applications[idx]['monthlyRent'] as double;
            final income = _applications[idx]['monthlyIncome'] as double;
            final ratio = rent / (income > 0 ? income : 1);
            int score = 88;
            String status = 'Approved';
            String notes = 'AI Validated: Optimal rent-to-income ratio. High confidence rating.';
            if (ratio > 0.45) {
              score = 62;
              status = 'ReviewRequired';
              notes = 'Moderate debt ratio (> 45%). Requires HITL Manager Approval.';
            }
            _applications[idx]['aiRiskScore'] = score;
            _applications[idx]['status'] = status;
            _applications[idx]['aiScreeningNotes'] = notes;
          }
          _evaluatingId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI Risk Score evaluated & state updated!'),
            backgroundColor: Color(0xFF6366F1),
          ),
        );
      }
    });
  }

  void _reviewDecision(String id, String status, String message) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _applications.indexWhere((a) => a['id'] == id);
      if (idx != -1) {
        _applications[idx]['status'] = status;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application $message'),
        backgroundColor: status == 'Approved' ? const Color(0xFF10B981) : const Color(0xFFEF4444),
      ),
    );
  }

  void _showKycModal(Map<String, dynamic> app) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => IdentityVerificationModal(
        application: app,
        onVerifyAndApprove: () {
          setState(() {
            final idx = _applications.indexWhere((a) => a['id'] == app['id']);
            if (idx != -1) {
              _applications[idx]['status'] = 'Approved';
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('KYC Identity Document Verified & Approved!'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hitlCount = _applications.where((a) => a['status'] == 'ReviewRequired' || a['status'] == 3).length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TenantApplicationScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.camera_alt_outlined, size: 18),
        label: const Text('New Application', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // KPI Ribbon for Screening
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 8),
              child: SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildKpiCard(context, 'Total Applicants', '${_applications.length} Candidates', Icons.people_outline, const Color(0xFF60A5FA), const Color(0x333B82F6)),
                    const SizedBox(width: 10),
                    _buildKpiCard(context, 'HITL Queue', '$hitlCount Actions', Icons.shield_outlined, const Color(0xFFFBBF24), const Color(0x33F59E0B)),
                    const SizedBox(width: 10),
                    _buildKpiCard(context, 'Auto-Approval Rate', '67%', Icons.check_circle_outline, const Color(0xFF34D399), const Color(0x3310B981)),
                    const SizedBox(width: 10),
                    _buildKpiCard(context, 'Average Risk AI', '71 / 100', Icons.auto_awesome_outlined, const Color(0xFFA78BFA), const Color(0x338B5CF6)),
                  ],
                ),
              ),
            ),
          ),

          // Filter Tab Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _buildTabChip(context, 'ALL', 'All (${_applications.length})'),
                    _buildTabChip(context, 'HITL', 'HITL Queue ($hitlCount)'),
                    _buildTabChip(context, 'APPROVED', 'Approved'),
                    _buildTabChip(context, 'PENDING', 'Pending AI'),
                  ],
                ),
              ),
            ),
          ),

          // Candidate Scorecards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final app = _filteredApplications[index];
                  return _buildApplicantCard(context, app);
                },
                childCount: _filteredApplications.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildKpiCard(BuildContext context, String label, String value, IconData icon, Color color, Color borderColor) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: 145,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : borderColor),
        boxShadow: isLight
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(icon, color: color, size: 14),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabChip(BuildContext context, String id, String label) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isSelected = _activeTab == id;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _activeTab = id);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : (isLight ? Colors.white : const Color(0xFF0F172A)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B82F6)
                  : (isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicantCard(BuildContext context, Map<String, dynamic> app) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isEvaluating = _evaluatingId == app['id'];
    final rent = (app['monthlyRent'] as double?) ?? 200000;
    final income = (app['monthlyIncome'] as double?) ?? 450000;
    final debtRatio = ((rent / (income > 0 ? income : 1)) * 100).round();

    final isReviewRequired = app['status'] == 'ReviewRequired' || app['status'] == 3;
    final isApproved = app['status'] == 'Approved' || app['status'] == 1;

    Color ratioColor = const Color(0xFF10B981);
    String ratioText = 'Optimal (≤ 35%)';
    if (debtRatio > 50) {
      ratioColor = const Color(0xFFEF4444);
      ratioText = 'High Risk (> 50%)';
    } else if (debtRatio > 35) {
      ratioColor = const Color(0xFFF59E0B);
      ratioText = 'Moderate (35-50%)';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Score Gauge, Avatar, Name & Status
            Row(
              children: [
                RiskScoreGauge(
                  score: (app['aiRiskScore'] as int?) ?? 50,
                  size: 52,
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(app['applicantAvatar'] ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              app['applicantName'] ?? 'Applicant',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isApproved
                                  ? const Color(0x1A10B981)
                                  : isReviewRequired
                                      ? const Color(0x1AF59E0B)
                                      : (isLight ? const Color(0xFFF1F5F9) : const Color(0x1A64748B)),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isApproved
                                    ? const Color(0x3310B981)
                                    : isReviewRequired
                                        ? const Color(0x33F59E0B)
                                        : (isLight ? const Color(0xFFCBD5E1) : const Color(0x3364748B)),
                              ),
                            ),
                            child: Text(
                              isApproved
                                  ? 'Approved'
                                  : isReviewRequired
                                      ? 'HITL Review'
                                      : 'Pending AI',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: isApproved
                                    ? const Color(0xFF10B981)
                                    : isReviewRequired
                                        ? const Color(0xFFD97706)
                                        : (isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        app['propertyTitle'] ?? 'Property Unit',
                        style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Debt Ratio Visualization Bar
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Income vs. Rent Debt Ratio',
                        style: TextStyle(
                          fontSize: 10,
                          color: isLight ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '$debtRatio% ($ratioText)',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: ratioColor, fontFamily: 'monospace'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (debtRatio.clamp(0, 100)) / 100,
                      backgroundColor: isLight ? const Color(0xFFE2E8F0) : const Color(0xFF334155),
                      valueColor: AlwaysStoppedAnimation<Color>(ratioColor),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Income: LKR ${(income / 1000).toStringAsFixed(0)}k',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: isLight ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          fontFamily: 'monospace',
                        ),
                      ),
                      Text(
                        'Rent: LKR ${(rent / 1000).toStringAsFixed(0)}k',
                        style: TextStyle(
                          fontSize: 9.5,
                          color: isLight ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // AI Screening Notes
            if (app['aiScreeningNotes'] != null)
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFEEF2FF) : const Color(0x1A6366F1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isLight ? const Color(0xFFC7D2FE) : const Color(0x336366F1)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.auto_awesome, color: isLight ? const Color(0xFF4F46E5) : const Color(0xFFA78BFA), size: 13),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        app['aiScreeningNotes'],
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isLight ? const Color(0xFF3730A3) : const Color(0xFFCBD5E1),
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Action Buttons Strip
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showKycModal(app),
                  icon: const Icon(Icons.badge_outlined, size: 14),
                  label: const Text('Inspect KYC', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF60A5FA),
                    side: const BorderSide(color: Color(0x333B82F6)),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: isReviewRequired
                      ? Row(
                          children: [
                            Expanded(
                              child: FilledButton(
                                onPressed: () => _reviewDecision(app['id'], 'Approved', 'Approved!'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: const Color(0xFF10B981),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _reviewDecision(app['id'], 'Rejected', 'Rejected.'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFFEF4444),
                                  side: const BorderSide(color: Color(0x33EF4444)),
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Reject', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                              ),
                            ),
                          ],
                        )
                      : FilledButton.icon(
                          onPressed: isEvaluating ? null : () => _runRiskAi(app['id']),
                          icon: isEvaluating
                              ? const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.auto_awesome, size: 13),
                          label: Text(
                            isEvaluating ? 'Evaluating...' : 'Run Risk AI',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
