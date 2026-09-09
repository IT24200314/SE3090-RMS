// =================================================================================================
// File: contractor_orders_screen.dart
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Mobile UI Layer - Contractor Field Work-Order & Dispatch Screen
// Purpose: Enables certified field trade contractors to inspect assigned repair jobs, view property
//          GPS coordinates, toggle job status (InProgress -> Resolved), and file repair completion quotes.
// =================================================================================================

import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ContractorOrdersScreen extends StatefulWidget {
  const ContractorOrdersScreen({super.key});

  @override
  State<ContractorOrdersScreen> createState() => _ContractorOrdersScreenState();
}

class _ContractorOrdersScreenState extends State<ContractorOrdersScreen> {
  final List<Map<String, dynamic>> _workOrders = [
    {
      'id': 'WO-2026-88',
      'tradeCategory': 'Plumbing Services',
      'propertyTitle': 'Oceanfront Luxury Suite',
      'address': '142 Marine Drive, Colombo 03',
      'gps': '6.90421 N, 79.85412 E',
      'description': 'Water pipe leak burst under bathroom sink. Pressure loss reported.',
      'priority': 'High',
      'estimatedCost': 38000.0,
      'status': 'Assigned',
      'slaHours': '4 Hours',
    },
    {
      'id': 'WO-2026-92',
      'tradeCategory': 'Electrical Works',
      'propertyTitle': 'Cinnamon Gardens Townhouse',
      'address': '28 Flower Road, Colombo 07',
      'gps': '6.91230 N, 79.86540 E',
      'description': 'Main distribution board breaker tripping intermittently.',
      'priority': 'Emergency',
      'estimatedCost': 65000.0,
      'status': 'InProgress',
      'slaHours': '2 Hours',
    }
  ];

  void _updateStatus(int index, String newStatus) {
    setState(() {
      _workOrders[index]['status'] = newStatus;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Work Order ${_workOrders[index]['id']} updated to "$newStatus"! Synced to API.'),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  void _submitInvoice(int index) {
    final costController = TextEditingController(text: _workOrders[index]['estimatedCost'].toString());
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Submit Completion Invoice (${_workOrders[index]['id']})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter final certified invoice amount for ${_workOrders[index]['tradeCategory']}:', style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Total Labor & Materials (LKR)',
                prefixText: 'LKR ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _updateStatus(index, 'Resolved');
            },
            child: const Text('Confirm Settlement'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contractor Work Orders'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Contractor Header Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.amber.shade900, Colors.amber.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                      child: Icon(Icons.handyman, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.fullName ?? 'Certified Trade Contractor', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          Text(user?.email ?? 'contractor@rms.lk', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('Active SLA', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white24),
                const SizedBox(height: 4),
                const Text(
                  'Jobs dispatched automatically via LangGraph AI Maintenance Subsystem (Hashini)',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Assigned Service Orders (${_workOrders.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ..._workOrders.asMap().entries.map((entry) {
            final idx = entry.key;
            final wo = entry.value;
            final status = wo['status'] as String;
            final isResolved = status == 'Resolved';
            final isInProgress = status == 'InProgress';

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(wo['tradeCategory'], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isResolved
                                ? Colors.green.withValues(alpha: 0.15)
                                : isInProgress
                                    ? Colors.amber.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(
                              color: isResolved ? Colors.green : isInProgress ? Colors.amber.shade900 : Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Text(wo['description'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: Colors.red),
                        const SizedBox(width: 4),
                        Expanded(child: Text('${wo['address']} (${wo['gps']})', style: theme.textTheme.bodySmall)),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Budget: LKR ${(wo['estimatedCost'] as double).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('SLA: ${wo['slaHours']}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Actions
                    Row(
                      children: [
                        if (!isInProgress && !isResolved)
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.play_arrow, size: 16),
                              label: const Text('Start Work', style: TextStyle(fontSize: 12)),
                              onPressed: () => _updateStatus(idx, 'InProgress'),
                            ),
                          ),
                        if (isInProgress) ...[
                          Expanded(
                            child: FilledButton.icon(
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Finish & Invoice', style: TextStyle(fontSize: 12)),
                              onPressed: () => _submitInvoice(idx),
                            ),
                          ),
                        ],
                        if (isResolved)
                          const Expanded(
                            child: Center(
                              child: Text('Completed & Settled', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
