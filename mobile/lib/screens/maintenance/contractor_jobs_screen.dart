import 'package:flutter/material.dart';
import '../../models/maintenance_ticket.dart';
import 'create_ticket_screen.dart';

class ContractorJobsScreen extends StatefulWidget {
  const ContractorJobsScreen({super.key});

  @override
  State<ContractorJobsScreen> createState() => _ContractorJobsScreenState();
}

class _ContractorJobsScreenState extends State<ContractorJobsScreen> {
  final List<MaintenanceTicket> _tickets = [
    MaintenanceTicket(
      id: 'm-001',
      propertyId: 'p-101',
      tenantId: 't-201',
      issueDescription: 'Major burst pipe in bathroom flooding floor',
      photoUrl: 'https://cdn.rms.local/photos/burst.jpg',
      priority: 'Emergency',
      status: 'PendingManagerApproval',
      estimatedCost: 65000,
      aiTriageSummary: "Classified: Plumbing Services. Paused at PendingManagerApproval (Exceeds LKR 50K ceiling).",
      createdAtUtc: DateTime.now(),
    ),
    MaintenanceTicket(
      id: 'm-002',
      propertyId: 'p-102',
      tenantId: 't-202',
      issueDescription: 'Living room power socket sparking',
      photoUrl: 'https://cdn.rms.local/photos/spark.jpg',
      priority: 'High',
      status: 'Assigned',
      estimatedCost: 22000,
      aiTriageSummary: 'Classified: Electrical Engineering. Assigned to ElectroMaster Works.',
      assignedContractorId: 'c-301',
      createdAtUtc: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maintenance & Work Orders', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            Text('Component C — Hashini Wicramathilake', style: TextStyle(fontSize: 11, color: Color(0xFFFBBF24), fontWeight: FontWeight.w500)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTicketScreen()),
          );
        },
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Report Issue', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tickets.length,
        itemBuilder: (context, index) {
          final t = _tickets[index];
          final isPendingHitl = t.status == 'PendingManagerApproval';

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TICKET: ${t.id}', style: const TextStyle(color: Color(0xFF71717A), fontSize: 10, fontWeight: FontWeight.w600, fontFamily: 'monospace')),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: isPendingHitl ? const Color(0x1AF59E0B) : const Color(0x1A6366F1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isPendingHitl ? const Color(0x33F59E0B) : const Color(0x336366F1),
                          ),
                        ),
                        child: Text(
                          isPendingHitl ? 'Manager Review (HITL)' : t.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isPendingHitl ? const Color(0xFFFBBF24) : const Color(0xFF818CF8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    t.issueDescription,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFFF4F4F5)),
                  ),
                  const SizedBox(height: 10),

                  // Priority and Budget Row
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: t.priority == 'Emergency' ? const Color(0x1AEF4444) : const Color(0x1AF59E0B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: t.priority == 'Emergency' ? const Color(0x33EF4444) : const Color(0x33F59E0B),
                          ),
                        ),
                        child: Text(
                          t.priority,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: t.priority == 'Emergency' ? const Color(0xFFF87171) : const Color(0xFFFBBF24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Budget: LKR ${t.estimatedCost.toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF34D399), fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ],
                  ),

                  if (t.aiTriageSummary != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF09090B),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0x14FFFFFF)),
                      ),
                      child: Text(
                        t.aiTriageSummary!,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFA1A1AA), height: 1.3),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
