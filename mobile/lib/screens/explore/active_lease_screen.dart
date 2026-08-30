import 'package:flutter/material.dart';
import '../../services/api_client.dart';

class ActiveLeaseScreen extends StatefulWidget {
  const ActiveLeaseScreen({super.key});

  @override
  State<ActiveLeaseScreen> createState() => _ActiveLeaseScreenState();
}

class _ActiveLeaseScreenState extends State<ActiveLeaseScreen> {
  bool _isTerminated = false;

  void _confirmEarlyTermination() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF121215),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x1FFFFFFF)),
        ),
        title: const Text('Confirm Early Termination', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        content: const Text(
          'Terminating will execute the early exit business rule, release the property back to Available, and update your lease state to Terminated.',
          style: TextStyle(fontSize: 12, color: Color(0xFFA1A1AA), height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF71717A), fontSize: 12)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await ApiClient.terminateLease('e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c', 'Tenant early exit request via mobile app');
              setState(() => _isTerminated = true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Lease terminated. Property released back to Available.')),
                );
              }
            },
            child: const Text('Confirm Exit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Active Lease Contract', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            Text('Component A — Upamada Ekanayake', style: TextStyle(fontSize: 11, color: Color(0xFF818CF8))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Oceanfront Luxury Suite',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Color(0xFFF4F4F5)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: _isTerminated ? const Color(0x1AEF4444) : const Color(0x1A10B981),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _isTerminated ? const Color(0x33EF4444) : const Color(0x3310B981),
                            ),
                          ),
                          child: Text(
                            _isTerminated ? 'Terminated' : 'Active Contract',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _isTerminated ? const Color(0xFFF87171) : const Color(0xFF34D399),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('142 Marine Drive, Colombo 03', style: TextStyle(color: Color(0xFF71717A), fontSize: 11)),
                    const SizedBox(height: 14),

                    // Financial metrics
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF09090B),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0x14FFFFFF)),
                      ),
                      child: const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('AGREED RENT', style: TextStyle(color: Color(0xFF71717A), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                              Text('LKR 220,000 / mo', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'monospace', color: Color(0xFF34D399))),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SECURITY DEPOSIT', style: TextStyle(color: Color(0xFF71717A), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                              Text('LKR 440,000', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12, fontFamily: 'monospace', color: Color(0xFFD4D4D8))),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('VALIDITY TERM', style: TextStyle(color: Color(0xFF71717A), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                              Text('Jan 2026 - Dec 2026', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12, color: Color(0xFFA1A1AA))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('AI Drafted Special Conditions', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFFF4F4F5))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF121215),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x1FFFFFFF)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: Color(0xFF818CF8)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Tenant is entitled to 2 dedicated parking bays. Utility sub-meters shall be settled within 10 days of invoice cycle. 30 days written notice required for early termination.',
                      style: TextStyle(fontSize: 12, height: 1.4, color: Color(0xFFA1A1AA)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (!_isTerminated)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF87171),
                    side: const BorderSide(color: Color(0x33EF4444)),
                    backgroundColor: const Color(0x0DEF4444),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _confirmEarlyTermination,
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('Request Early Lease Termination', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
