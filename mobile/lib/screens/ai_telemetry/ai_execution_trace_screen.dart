import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/ai_trace.dart';

class AiExecutionTraceScreen extends StatefulWidget {
  const AiExecutionTraceScreen({super.key});

  @override
  State<AiExecutionTraceScreen> createState() => _AiExecutionTraceScreenState();
}

class _AiExecutionTraceScreenState extends State<AiExecutionTraceScreen> {
  bool _isExecuting = false;
  late AiTrace _selectedTrace;

  final List<AiTrace> _traces = [
    AiTrace(
      id: 'TRC-1049',
      timestamp: 'Just now',
      agent: 'Upamada (Planning Agent)',
      action: 'Generate Lease Clauses & Schedule Inspection',
      state: 'SUCCESS',
      duration: '320ms',
      details: 'Verified Colombo rental index, applied standard 30-day termination policy, generated contract clauses.',
    ),
    AiTrace(
      id: 'TRC-1048',
      timestamp: '2 mins ago',
      agent: 'Nethmi (Risk Scoring Agent)',
      action: 'Evaluate Rent-to-Income & ID Validation',
      state: 'SUCCESS',
      duration: '540ms',
      details: 'Calculated 20% rent ratio, generated 92/100 risk score. Identity card verified against registry.',
    ),
    AiTrace(
      id: 'TRC-1047',
      timestamp: '5 mins ago',
      agent: 'Hashini (Triage & Validation Agent)',
      action: 'Maintenance Cost Estimation & Policy Audit',
      state: 'HITL_PAUSE',
      duration: '410ms',
      details: 'Burst pipe repair estimated at LKR 65,000. Exceeds LKR 50,000 threshold. Paused at PendingManagerApproval node.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedTrace = _traces.first;
  }

  void _simulateAgentRun() {
    HapticFeedback.mediumImpact();
    setState(() => _isExecuting = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      final randomNum = 1050 + (DateTime.now().millisecondsSinceEpoch % 800);
      final newTrace = AiTrace(
        id: 'TRC-$randomNum',
        timestamp: 'Just now',
        agent: 'Upamada (Planning Agent)',
        action: 'Dynamic Lease Renewal & Market Rate Calibration',
        state: 'SUCCESS',
        duration: '${280 + (randomNum % 150)}ms',
        details: 'Evaluated property occupancy rates in Colombo 03, calibrated recommended agreed rent at LKR 225,000.',
      );

      if (mounted) {
        setState(() {
          _traces.insert(0, newTrace);
          _selectedTrace = newTrace;
          _isExecuting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agent simulation completed: ${newTrace.id} checkpoint recorded.'),
            backgroundColor: const Color(0xFF6366F1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          // Top Controller Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isLight ? Colors.white : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: isLight ? const Color(0xFFC7D2FE) : const Color(0x336366F1)),
                  boxShadow: isLight
                      ? [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 3))]
                      : const [
                          BoxShadow(color: Color(0x1A6366F1), blurRadius: 10, offset: Offset(0, 3)),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isLight ? const Color(0xFFEEF2FF) : const Color(0x266366F1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: isLight ? const Color(0xFFC7D2FE) : const Color(0x4D6366F1)),
                              ),
                              child: Icon(Icons.auto_awesome, color: isLight ? const Color(0xFF4F46E5) : const Color(0xFFA78BFA), size: 16),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'LangGraph Telemetry',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF10B981),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'StateGraph Active',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        FilledButton.icon(
                          onPressed: _isExecuting ? null : _simulateAgentRun,
                          icon: _isExecuting
                              ? const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.play_arrow, size: 16),
                          label: Text(_isExecuting ? 'Orchestrating...' : 'Simulate Run', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF6366F1),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Multi-agent state checkpoints & Human-in-the-Loop policy nodes.',
                      style: TextStyle(fontSize: 11, color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Node Inspector Selected Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isLight ? Colors.white : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isLight ? const Color(0xFFBAE6FD) : const Color(0x3338BDF8)),
                  boxShadow: isLight
                      ? [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.terminal, color: isLight ? const Color(0xFF0284C7) : const Color(0xFF38BDF8), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'NODE INSPECTOR: ${_selectedTrace.id}',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: isLight ? const Color(0xFF0284C7) : const Color(0xFF38BDF8),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          _selectedTrace.duration,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'AGENT NODE',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: isLight ? const Color(0xFF64748B) : Colors.grey.shade400, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedTrace.agent,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLight ? const Color(0xFF4F46E5) : const Color(0xFFA78BFA),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'OBJECTIVE TARGET',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: isLight ? const Color(0xFF64748B) : Colors.grey.shade400, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _selectedTrace.action,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'STATE PAYLOAD',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: isLight ? const Color(0xFF64748B) : Colors.grey.shade400, letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF09090B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
                      ),
                      child: Text(
                        _selectedTrace.details,
                        style: TextStyle(
                          fontSize: 11,
                          color: isLight ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          fontFamily: 'monospace',
                          height: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.verified, color: Color(0xFF10B981), size: 14),
                        SizedBox(width: 6),
                        Text(
                          'Deterministic rule bounds validated',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF10B981)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Execution Log Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Text(
                'EXECUTION LOG & STATE CHECKPOINTS',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Trace Checkpoints List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final trace = _traces[index];
                  final isSelected = _selectedTrace.id == trace.id;
                  final isHitl = trace.state == 'HITL_PAUSE';

                  return InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedTrace = trace);
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isLight ? const Color(0xFFEEF2FF) : const Color(0x266366F1))
                            : (isLight ? Colors.white : const Color(0xFF0F172A)),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6366F1)
                              : (isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
                          width: isSelected ? 1.5 : 1,
                        ),
                        boxShadow: isLight
                            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4, offset: const Offset(0, 1))]
                            : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.memory, color: isLight ? const Color(0xFF4F46E5) : const Color(0xFFA78BFA), size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    trace.agent,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w700,
                                      color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isHitl
                                      ? (isLight ? const Color(0xFFFEF3C7) : const Color(0x26F59E0B))
                                      : (isLight ? const Color(0xFFD1FAE5) : const Color(0x2610B981)),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: isHitl
                                        ? (isLight ? const Color(0xFFFDE68A) : const Color(0x66F59E0B))
                                        : (isLight ? const Color(0xFFA7F3D0) : const Color(0x6610B981)),
                                  ),
                                ),
                                child: Text(
                                  isHitl ? 'HITL PAUSE' : 'SUCCESS',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: isHitl
                                        ? (isLight ? const Color(0xFFD97706) : const Color(0xFFFBBF24))
                                        : (isLight ? const Color(0xFF059669) : const Color(0xFF34D399)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            trace.action,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isLight ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            trace.details,
                            style: TextStyle(
                              fontSize: 10.5,
                              color: isLight ? const Color(0xFF64748B) : const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: _traces.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
