import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'contractor_dispatch_modal.dart';
import 'create_ticket_screen.dart';

class MaintenanceBoardScreen extends StatefulWidget {
  const MaintenanceBoardScreen({super.key});

  @override
  State<MaintenanceBoardScreen> createState() => _MaintenanceBoardScreenState();
}

class _MaintenanceBoardScreenState extends State<MaintenanceBoardScreen> {
  int _selectedKanbanColumn = 0; // 0: Unassigned, 1: Dispatched, 2: In-Progress, 3: Resolved
  String? _triagingId;

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': 'm1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c',
      'propertyTitle': 'Oceanfront Luxury Suite',
      'issueDescription': 'Major burst pipe in master bathroom causing rapid water leakage on floor.',
      'priority': 3, // Emergency
      'status': 2, // PendingManagerApproval ( >= 50k )
      'estimatedCost': 65000.0,
      'aiTriageSummary': "Classified under 'Plumbing Services'. Estimated budget: LKR 65,000.00. [FLAGGED] Exceeds LKR 50K ceiling. Paused at PendingManagerApproval node.",
      'contractorName': null,
      'createdAtUtc': DateTime.now(),
    },
    {
      'id': 'm2b3c4d5-e6f7-8a9b-0c1d-2e3f4a5b6c7d',
      'propertyTitle': 'Cinnamon Gardens Townhouse',
      'issueDescription': 'Kitchen main power outlet sparking when high load appliance is connected.',
      'priority': 2, // High
      'status': 0, // Unassigned / Open
      'estimatedCost': 22000.0,
      'aiTriageSummary': "Classified under 'Electrical Engineering'. Estimated budget: LKR 22,000.00. [APPROVED] Within auto-approval bounds.",
      'contractorName': null,
      'createdAtUtc': DateTime.now(),
    },
    {
      'id': 'm3c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e',
      'propertyTitle': 'Havelock City Studio Apartment',
      'issueDescription': 'HVAC Air conditioning condenser leaking refrigerant water onto balcony.',
      'priority': 1, // Medium
      'status': 1, // Dispatched
      'estimatedCost': 28000.0,
      'aiTriageSummary': "Classified under 'HVAC Services'. Lanka Cool Air dispatched.",
      'contractorName': 'Lanka QuickPlumb Services',
      'createdAtUtc': DateTime.now(),
    },
    {
      'id': 'm4d5e6f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
      'propertyTitle': 'Rajagiriya Lakeview Condo',
      'issueDescription': 'Replaced main front biometric lock sensor battery and recalibrated bolt.',
      'priority': 0, // Low
      'status': 4, // Resolved
      'estimatedCost': 12000.0,
      'aiTriageSummary': 'General Handyman resolved. Invoiced settled.',
      'contractorName': 'All-Fix Handyman Crew',
      'createdAtUtc': DateTime.now(),
    },
  ];

  List<Map<String, dynamic>> get _pendingApprovalTickets {
    return _tickets.where((t) => t['status'] == 2).toList();
  }

  List<Map<String, dynamic>> get _unassignedTickets {
    return _tickets.where((t) => t['status'] == 0 || t['status'] == 2).toList();
  }

  List<Map<String, dynamic>> get _dispatchedTickets {
    return _tickets.where((t) => t['status'] == 1).toList();
  }

  List<Map<String, dynamic>> get _inProgressTickets {
    return _tickets.where((t) => t['status'] == 3).toList();
  }

  List<Map<String, dynamic>> get _resolvedTickets {
    return _tickets.where((t) => t['status'] == 4).toList();
  }

  List<Map<String, dynamic>> get _currentColumnTickets {
    switch (_selectedKanbanColumn) {
      case 0:
        return _unassignedTickets;
      case 1:
        return _dispatchedTickets;
      case 2:
        return _inProgressTickets;
      case 3:
        return _resolvedTickets;
      default:
        return _tickets;
    }
  }

  void _runAiTriage(String ticketId) {
    HapticFeedback.mediumImpact();
    setState(() => _triagingId = ticketId);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
          if (idx != -1) {
            final priority = _tickets[idx]['priority'] as int;
            final cost = priority >= 2 ? 65000.0 : 25000.0;
            final status = cost >= 50000.0 ? 2 : 0;
            _tickets[idx]['estimatedCost'] = cost;
            _tickets[idx]['status'] = status;
            _tickets[idx]['aiTriageSummary'] = cost >= 50000.0
                ? '[FLAGGED] AI estimate LKR ${cost.toStringAsFixed(0)} exceeds 50k ceiling. Paused for HITL approval.'
                : '[APPROVED] AI estimate LKR ${cost.toStringAsFixed(0)} within standard threshold.';
          }
          _triagingId = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AI Triage completed & budget calculated!'),
            backgroundColor: Color(0xFF6366F1),
          ),
        );
      }
    });
  }

  void _approveHighCost(String ticketId) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
      if (idx != -1) {
        _tickets[idx]['status'] = 0; // Move to Unassigned / Authorized
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Financial approval granted! Ticket unlocked for contractor dispatch.'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _rejectHighCost(String ticketId) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
      if (idx != -1) {
        _tickets[idx]['status'] = 4; // Archived
        _tickets[idx]['aiTriageSummary'] = 'Declined by Property Manager during HITL authorization.';
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Repair authorization declined. Ticket archived.'),
        backgroundColor: Color(0xFFEF4444),
      ),
    );
  }

  void _showDispatchModal(Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ContractorDispatchModal(
        ticket: ticket,
        onDispatch: (contractorId, contractorName, maxBudget) {
          setState(() {
            final idx = _tickets.indexWhere((t) => t['id'] == ticket['id']);
            if (idx != -1) {
              _tickets[idx]['status'] = 1; // Dispatched
              _tickets[idx]['contractorName'] = contractorName;
              _tickets[idx]['estimatedCost'] = maxBudget;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dispatched to $contractorName with budget ceiling LKR ${maxBudget.toStringAsFixed(0)}!'),
              backgroundColor: const Color(0xFFD97706),
            ),
          );
        },
      ),
    );
  }

  void _advanceTicketStatus(String ticketId, int nextStatus) {
    HapticFeedback.lightImpact();
    setState(() {
      final idx = _tickets.indexWhere((t) => t['id'] == ticketId);
      if (idx != -1) {
        _tickets[idx]['status'] = nextStatus;
      }
    });
    final statusLabels = {3: 'In-Progress', 4: 'Resolved'};
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ticket status advanced to ${statusLabels[nextStatus] ?? 'Next Stage'}!'),
        backgroundColor: nextStatus == 4 ? const Color(0xFF10B981) : const Color(0xFF2563EB),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeOrders = _tickets.where((t) => t['status'] != 4).length;
    final emergencyOrders = _tickets.where((t) => t['priority'] == 3).length;
    final resolvedOrders = _tickets.where((t) => t['status'] == 4).length;
    final pendingHitl = _pendingApprovalTickets.length;

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateTicketScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add_a_photo_outlined, size: 18),
        label: const Text('Report Issue (GPS)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // Maintenance Ribbon KPIs
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
                    _buildRibbonCard(context, 'Open Orders', '$activeOrders Active', Icons.handyman_outlined, const Color(0xFF60A5FA), const Color(0x333B82F6)),
                    const SizedBox(width: 10),
                    _buildRibbonCard(context, 'HITL Threshold', '$pendingHitl Pending', Icons.shield_outlined, const Color(0xFFFBBF24), const Color(0x33F59E0B)),
                    const SizedBox(width: 10),
                    _buildRibbonCard(context, 'Emergency', '$emergencyOrders Urgent', Icons.local_fire_department_outlined, const Color(0xFFEF4444), const Color(0x33EF4444)),
                    const SizedBox(width: 10),
                    _buildRibbonCard(context, 'Resolved', '$resolvedOrders Closed', Icons.task_alt, const Color(0xFF34D399), const Color(0x3310B981)),
                  ],
                ),
              ),
            ),
          ),

          // High Cost HITL Approval Banner (Orders >= LKR 50K)
          if (_pendingApprovalTickets.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF59E0B),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'IMMEDIATE FINANCIAL REVIEW QUEUE (≥ LKR 50K)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFFBBF24),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ..._pendingApprovalTickets.map((t) => _buildHitlApprovalCard(context, t)),
                  ],
                ),
              ),
            ),

          // 4-Column Segmented Kanban Navigator
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.white : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Theme.of(context).brightness == Brightness.light ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF),
                  ),
                  boxShadow: Theme.of(context).brightness == Brightness.light
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 4, offset: const Offset(0, 1))]
                      : null,
                ),
                child: Row(
                  children: [
                    _buildKanbanTab(context, 0, 'Triage', _unassignedTickets.length),
                    _buildKanbanTab(context, 1, 'Dispatched', _dispatchedTickets.length),
                    _buildKanbanTab(context, 2, 'In-Progress', _inProgressTickets.length),
                    _buildKanbanTab(context, 3, 'Resolved', _resolvedTickets.length),
                  ],
                ),
              ),
            ),
          ),

          // Ticket List in Current Column
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            sliver: _currentColumnTickets.isEmpty
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No tickets in this stage',
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final t = _currentColumnTickets[index];
                        return _buildKanbanTicketCard(context, t);
                      },
                      childCount: _currentColumnTickets.length,
                    ),
                  ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildRibbonCard(BuildContext context, String label, String value, IconData icon, Color color, Color borderColor) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: 140,
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

  Widget _buildHitlApprovalCard(BuildContext context, Map<String, dynamic> t) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cost = (t['estimatedCost'] as num?)?.toDouble() ?? 65000.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFFFFBEB) : const Color(0x1AF59E0B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isLight ? const Color(0xFFFDE68A) : const Color(0x66F59E0B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFFEE2E2) : const Color(0x33EF4444),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Color(0xFFEF4444), size: 12),
                    const SizedBox(width: 4),
                    Text(
                      'Emergency Order',
                      style: TextStyle(
                        color: isLight ? const Color(0xFFB91C1C) : const Color(0xFFEF4444),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'LKR ${cost.toStringAsFixed(0)}',
                style: const TextStyle(color: Color(0xFFD97706), fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'monospace'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t['issueDescription'] ?? '',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Policy: Repair budget exceeds 50K ceiling. Manager review required before dispatch.',
            style: TextStyle(fontSize: 10.5, color: isLight ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _approveHighCost(t['id']),
                  icon: const Icon(Icons.check, size: 14),
                  label: const Text('Authorize Repair', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _rejectHighCost(t['id']),
                  icon: const Icon(Icons.close, size: 14),
                  label: const Text('Decline', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFEF4444),
                    side: const BorderSide(color: Color(0x33EF4444)),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanTab(BuildContext context, int index, String title, int count) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isSelected = _selectedKanbanColumn == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedKanbanColumn = index);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected ? Colors.white : (isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0x33FFFFFF)
                      : (isLight ? const Color(0xFFF1F5F9) : const Color(0x1FFFFFFF)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isSelected
                        ? Colors.white
                        : (isLight ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKanbanTicketCard(BuildContext context, Map<String, dynamic> t) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isTriaging = _triagingId == t['id'];
    final priority = t['priority'] as int;
    final status = t['status'] as int;
    final cost = (t['estimatedCost'] as num?)?.toDouble() ?? 20000.0;
    final isHitl = status == 2;

    Color priorityColor = const Color(0xFF64748B);
    String priorityName = 'Low';
    if (priority == 3) {
      priorityColor = const Color(0xFFEF4444);
      priorityName = 'Emergency';
    } else if (priority == 2) {
      priorityColor = const Color(0xFFF59E0B);
      priorityName = 'High';
    } else if (priority == 1) {
      priorityColor = const Color(0xFF38BDF8);
      priorityName = 'Medium';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${t['id'].toString().substring(0, 8)}',
                  style: TextStyle(
                    fontSize: 10,
                    color: isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: priorityColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    priorityName,
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: priorityColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              t['issueDescription'] ?? '',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Property: ${t['propertyTitle'] ?? 'Colpetty Unit'}',
              style: const TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Est: LKR ${cost.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF10B981), fontFamily: 'monospace'),
                ),
                if (t['contractorName'] != null)
                  Text(
                    t['contractorName'],
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isLight ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
            if (t['aiTriageSummary'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : Colors.transparent),
                ),
                child: Text(
                  t['aiTriageSummary'],
                  style: TextStyle(
                    fontSize: 10,
                    color: isLight ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                    height: 1.3,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),

            // Stage Action Buttons
            if (status == 0 || isHitl) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isTriaging ? null : () => _runAiTriage(t['id']),
                      icon: isTriaging
                          ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.auto_awesome, size: 14),
                      label: Text(isTriaging ? 'Triaging...' : 'AI Triage', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFA78BFA),
                        side: const BorderSide(color: Color(0x338B5CF6)),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  if (!isHitl) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _showDispatchModal(t),
                        icon: const Icon(Icons.person_add_alt_1_outlined, size: 14),
                        label: const Text('Dispatch', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD97706),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ] else if (status == 1) ...[
              FilledButton.icon(
                onPressed: () => _advanceTicketStatus(t['id'], 3),
                icon: const Icon(Icons.arrow_forward, size: 14),
                label: const Text('Move to In-Progress', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  minimumSize: const Size(double.infinity, 38),
                ),
              ),
            ] else if (status == 3) ...[
              FilledButton.icon(
                onPressed: () => _advanceTicketStatus(t['id'], 4),
                icon: const Icon(Icons.check_circle_outline, size: 14),
                label: const Text('Complete & Close Order', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  minimumSize: const Size(double.infinity, 38),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0x1A10B981),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified, color: Color(0xFF34D399), size: 14),
                    SizedBox(width: 4),
                    Text('Order Settled & Closed', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF34D399))),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
