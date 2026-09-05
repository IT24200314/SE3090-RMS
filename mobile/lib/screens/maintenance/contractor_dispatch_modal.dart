import 'package:flutter/material.dart';

class ContractorDispatchModal extends StatefulWidget {
  final Map<String, dynamic> ticket;
  final Function(String contractorId, String contractorName, double maxBudget) onDispatch;

  const ContractorDispatchModal({
    super.key,
    required this.ticket,
    required this.onDispatch,
  });

  @override
  State<ContractorDispatchModal> createState() => _ContractorDispatchModalState();
}

class _ContractorDispatchModalState extends State<ContractorDispatchModal> {
  late TextEditingController _budgetController;
  String _selectedContractorId = 'c-01';

  final List<Map<String, dynamic>> _contractors = [
    {
      'id': 'c-01',
      'name': 'Lanka QuickPlumb Services',
      'specialty': 'Plumbing & Drainage',
      'rating': 4.9,
      'jobsDone': 142,
      'isAvailable': true,
    },
    {
      'id': 'c-02',
      'name': 'ElectroMaster Pro Engineering',
      'specialty': 'Electrical & High Voltage',
      'rating': 4.8,
      'jobsDone': 98,
      'isAvailable': true,
    },
    {
      'id': 'c-03',
      'name': 'Lanka Cool Air & HVAC Systems',
      'specialty': 'Refrigeration & AC',
      'rating': 4.7,
      'jobsDone': 76,
      'isAvailable': false,
    },
    {
      'id': 'c-04',
      'name': 'All-Fix General Handyman Crew',
      'specialty': 'Carpentry, Locks & Fixtures',
      'rating': 4.9,
      'jobsDone': 210,
      'isAvailable': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    final cost = (widget.ticket['estimatedCost'] as num?)?.toDouble() ?? 25000.0;
    _budgetController = TextEditingController(text: cost.toInt().toString());
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issue = widget.ticket['issueDescription'] ?? 'Maintenance Issue';
    final ticketId = widget.ticket['id']?.toString().substring(0, 8) ?? 'mt-001';

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: Color(0x1FFFFFFF), width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF334155),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dispatch Service Contractor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFFF8FAFC)),
                    ),
                    Text(
                      'Work Order #$ticketId',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontFamily: 'monospace'),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF94A3B8)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0x14FFFFFF), height: 16),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ticket Summary Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x1FFFFFFF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ISSUE REPORTED',
                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8)),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          issue,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFF8FAFC)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Budget Ceiling Input
                  const Text(
                    'AUTHORIZED EXPENDITURE CEILING',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _budgetController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Maximum Budget (LKR)',
                      prefixIcon: Icon(Icons.payments_outlined, color: Color(0xFF94A3B8), size: 18),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Contractor Selection List
                  const Text(
                    'SELECT CERTIFIED SERVICE PARTNER',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 10),
                  ..._contractors.map((c) {
                    final isSelected = _selectedContractorId == c['id'];
                    final isAvail = c['isAvailable'] as bool;
                    return InkWell(
                      onTap: isAvail ? () => setState(() => _selectedContractorId = c['id']) : null,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0x262563EB) : const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0x1FFFFFFF),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF334155),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(Icons.handyman, color: Colors.white, size: 18),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['name'],
                                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFFF8FAFC)),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${c['specialty']} · ⭐ ${c['rating']} (${c['jobsDone']} jobs)',
                                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                            ),
                            if (!isAvail)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0x1AEF4444),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Busy',
                                  style: TextStyle(fontSize: 9, color: Color(0xFFEF4444), fontWeight: FontWeight.w600),
                                ),
                              )
                            else if (isSelected)
                              const Icon(Icons.check_circle, color: Color(0xFF60A5FA), size: 20),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom Action
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF09090B),
              border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF94A3B8),
                      side: const BorderSide(color: Color(0x33FFFFFF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      final selectedC = _contractors.firstWhere((c) => c['id'] == _selectedContractorId);
                      final budget = double.tryParse(_budgetController.text) ?? 25000.0;
                      Navigator.pop(context);
                      widget.onDispatch(selectedC['id'], selectedC['name'], budget);
                    },
                    icon: const Icon(Icons.send_rounded, size: 16),
                    label: const Text('Confirm & Dispatch', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFD97706),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
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
}
