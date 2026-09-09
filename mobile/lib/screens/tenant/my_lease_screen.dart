// =================================================================================================
// File: my_lease_screen.dart
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Mobile UI Layer - Active Tenancy & Lease Agreement Viewer
// Purpose: Enables current tenants to inspect executed residential lease agreements, review contractual
//          covenants, download PDF copies, and submit early lease termination requests.
// =================================================================================================

import 'package:flutter/material.dart';
import '../../services/api_client.dart';

class MyLeaseScreen extends StatefulWidget {
  const MyLeaseScreen({super.key});

  @override
  State<MyLeaseScreen> createState() => _MyLeaseScreenState();
}

class _MyLeaseScreenState extends State<MyLeaseScreen> {
  bool _isTerminated = false;
  bool _isSubmitting = false;

  void _requestTermination() {
    showDialog(
      context: context,
      builder: (ctx) {
        final reasonController = TextEditingController(text: 'Relocating for employment overseas');
        return AlertDialog(
          title: const Text('Request Early Lease Termination'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Submitting this request alerts the property manager and invokes early termination covenants as defined in clause 8.2.',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  labelText: 'Reason for early termination',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                setState(() => _isSubmitting = true);
                await ApiClient.terminateLease(
                  'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
                  reasonController.text.trim(),
                );
                if (!mounted) return;
                setState(() {
                  _isSubmitting = false;
                  _isTerminated = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Early termination request logged in system audit trail!'),
                    backgroundColor: Colors.amber,
                  ),
                );
              },
              child: const Text('Confirm Request'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Active Tenancy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Active Lease Status Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isTerminated ? Colors.amber.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _isTerminated ? Colors.amber : Colors.green),
                        ),
                        child: Text(
                          _isTerminated ? 'Termination Requested' : 'Active Tenancy (Signed)',
                          style: TextStyle(
                            color: _isTerminated ? Colors.amber.shade900 : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text('Lease #LS-2026-08', style: theme.textTheme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    'Oceanfront Luxury Suite',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('142 Marine Drive, Colombo 03', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn('Monthly Rent', 'LKR 220,000', colorScheme.primary),
                      _buildInfoColumn('Deposit Held', 'LKR 440,000', null),
                      _buildInfoColumn('Term Duration', '12 Months', null),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Lease Effective:', style: theme.textTheme.bodySmall),
                      const Text('2026-03-01 to 2027-02-28', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Contract Clauses & Terms Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: colorScheme.outlineVariant),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.gavel_outlined, size: 20, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      const Text('Contract Terms & Covenants', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildClauseItem('1. Rent Due Date', 'Rent is due on or before the 1st day of every calendar month via bank transfer.'),
                  _buildClauseItem('2. Maintenance & Repairs', 'Repairs below LKR 50,000 are triaged automatically. Emergency repairs dispatched immediately.'),
                  _buildClauseItem('3. Security Deposit', 'Deposit is held in escrow and refundable within 14 days following move-out inspection.'),
                  _buildClauseItem('4. Early Termination', 'Requires 30-day written notice and mutual landlord approval as tracked in system audit log.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: const Text('Download Agreement PDF'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading certified lease agreement: Lease_LS202608.pdf')),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (!_isTerminated)
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    icon: const Icon(Icons.exit_to_app, color: Colors.red),
                    label: const Text('Request Early Lease Termination', style: TextStyle(color: Colors.red)),
                    onPressed: _isSubmitting ? null : _requestTermination,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, Color? valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: valueColor)),
      ],
    );
  }

  Widget _buildClauseItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 2),
          Text(description, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ],
      ),
    );
  }
}
