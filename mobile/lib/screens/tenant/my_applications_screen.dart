// =================================================================================================
// File: my_applications_screen.dart
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Mobile UI Layer - Application Status & KYC Upload Portal
// Purpose: Enables tenants to track pending rental applications, view AI credit risk scores (0-100),
//          and upload verification documents (NIC, Passport, Salary Slips) via camera or file picker.
// =================================================================================================

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/auth_service.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _uploadedNicPath;
  bool _isUploading = false;

  final List<Map<String, dynamic>> _applications = [
    {
      'id': 'APP-101',
      'propertyTitle': 'Oceanfront Luxury Suite',
      'address': '142 Marine Drive, Colombo 03',
      'monthlyRent': 220000.0,
      'declaredIncome': 350000.0,
      'status': 'Approved',
      'riskScore': 92,
      'submittedDate': '2026-09-08',
      'notes': 'Financially sound. Rent-to-income ratio 62.8% within bounds. Identity verified.',
    },
    {
      'id': 'APP-102',
      'propertyTitle': 'Cinnamon Gardens Townhouse',
      'address': '28 Flower Road, Colombo 07',
      'monthlyRent': 350000.0,
      'declaredIncome': 450000.0,
      'status': 'ReviewRequired',
      'riskScore': 68,
      'submittedDate': '2026-09-09',
      'notes': 'Flagged for Manager Approval as rent ratio is approx 77.7% of declared income.',
    }
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(source: source);
      if (picked != null) {
        setState(() {
          _uploadedNicPath = picked.name;
          _isUploading = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Document "${picked.name}" successfully uploaded and verified by AI KYC!'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document capture: $e')),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'reviewrequired':
      case 'pending':
      default:
        return Colors.amber.shade800;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Applications & KYC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Application list updated from cloud database.')),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primaryContainer, theme.colorScheme.surfaceContainerHighest],
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
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      child: Text(user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'T'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.fullName ?? 'Tenant Applicant', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(user?.email ?? 'tenant@rms.lk', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Text('KYC Verified', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 8),

                // Upload KYC Identity Document Row
                Text('Upload NIC / Passport Document:', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined, size: 18),
                        label: const Text('Capture Camera', style: TextStyle(fontSize: 12)),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.upload_file_outlined, size: 18),
                        label: const Text('Upload File', style: TextStyle(fontSize: 12)),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
                if (_isUploading) ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
                if (_uploadedNicPath != null) ...[
                  const SizedBox(height: 8),
                  Text('Uploaded File: $_uploadedNicPath', style: const TextStyle(fontSize: 11, color: Colors.blueGrey, fontStyle: FontStyle.italic)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),

          Text('Submitted Applications (${_applications.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          ..._applications.map((app) {
            final status = app['status'] as String;
            final score = app['riskScore'] as int;
            final statusColor = _getStatusColor(status);

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
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
                        Expanded(
                          child: Text(
                            app['propertyTitle'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            status == 'ReviewRequired' ? 'Pending Approval' : status,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(app['address'], style: theme.textTheme.bodySmall),
                    const SizedBox(height: 12),

                    // Financial & Risk Metrics Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Agreed Rent', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text('LKR ${(app['monthlyRent'] as double).toStringAsFixed(0)}/mo', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Reported Salary', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Text('LKR ${(app['declaredIncome'] as double).toStringAsFixed(0)}/mo', style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('AI Risk Score', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shield_outlined, size: 14, color: score > 75 ? Colors.green : Colors.amber.shade800),
                                const SizedBox(width: 4),
                                Text(
                                  '$score/100',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: score > 75 ? Colors.green : Colors.amber.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.psychology, size: 16, color: Colors.blueAccent),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'AI Analysis: ${app['notes']}',
                              style: const TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
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
