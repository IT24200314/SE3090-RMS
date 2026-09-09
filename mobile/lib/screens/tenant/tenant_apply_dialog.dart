// =================================================================================================
// File: tenant_apply_dialog.dart
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Mobile UI Layer - Interactive Rental Application Form
// Purpose: Collects prospective tenant declared monthly income, employment details, and KYC doc upload,
//          submitting to POST /api/tenants/applications to trigger AI credit & risk scoring.
// =================================================================================================

import 'package:flutter/material.dart';
import '../../models/property.dart';
import '../../services/api_client.dart';
import '../../services/auth_service.dart';

class TenantApplyDialog extends StatefulWidget {
  final Property property;
  final VoidCallback onApplied;

  const TenantApplyDialog({super.key, required this.property, required this.onApplied});

  @override
  State<TenantApplyDialog> createState() => _TenantApplyDialogState();
}

class _TenantApplyDialogState extends State<TenantApplyDialog> {
  final _incomeController = TextEditingController(text: '350000');
  final _employerController = TextEditingController(text: 'Virtusa / Software Engineer');
  bool _isDocSelected = true;
  String _docName = 'NIC_Front_Back_Scan.pdf';
  bool _isSubmitting = false;

  void _submit() async {
    final income = double.tryParse(_incomeController.text.trim()) ?? 0;
    if (income <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid declared gross monthly income.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ApiClient.submitApplication(
        propertyId: widget.property.id,
        monthlyIncome: income,
        identityDocUrl: 'https://storage.rms.lk/kyc/$_docName',
      );

      if (!mounted) return;
      Navigator.of(context).pop();
      widget.onApplied();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Application for "${widget.property.title}" submitted successfully! AI evaluation underway.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.description_outlined, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          const Expanded(child: Text('Rental Application Form', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.property.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(widget.property.address, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text('Rent: LKR ${widget.property.monthlyRent.toStringAsFixed(0)}/mo', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text('Applicant: ${user?.fullName ?? "Prospective Tenant"} (${user?.email ?? ""})', style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),

            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Declared Gross Monthly Income (LKR)',
                prefixText: 'LKR ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _employerController,
              decoration: const InputDecoration(
                labelText: 'Employer & Job Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),

            // KYC Upload Simulator
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.attach_file, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(_isDocSelected ? _docName : 'No identity document attached', style: const TextStyle(fontSize: 12)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isDocSelected = true;
                        _docName = 'NIC_Verified_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
                      });
                    },
                    child: const Text('Change', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSubmitting ? null : _submit,
          child: _isSubmitting
              ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : const Text('Submit Application'),
        ),
      ],
    );
  }
}
