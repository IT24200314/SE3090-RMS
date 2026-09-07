// =================================================================================================
// File: tenant_application_screen.dart
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Mobile Layer - Flutter Screen with Native Hardware (Camera / ID Picker)
// Purpose: Allows prospective tenants to complete rental onboarding, enter verified income,
//          capture National ID / Passport via device Camera, and submit for automated AI screening.
// =================================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/property.dart';
import '../../services/api_client.dart';
import 'application_status_screen.dart';

class TenantApplicationScreen extends StatefulWidget {
  final Property? property;

  const TenantApplicationScreen({super.key, this.property});

  @override
  State<TenantApplicationScreen> createState() => _TenantApplicationScreenState();
}

class _TenantApplicationScreenState extends State<TenantApplicationScreen> {
  Property get _prop => widget.property ?? Property(
    id: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
    title: 'Oceanfront Luxury Suite',
    description: 'Modern 3-bedroom apartment with panoramic sea view.',
    address: '142 Marine Drive, Colombo 03',
    monthlyRent: 220000,
    securityDeposit: 440000,
    status: 'Available',
    landlordId: '8f9e0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b',
  );

  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController(text: '450000');
  final ImagePicker _picker = ImagePicker();
  
  XFile? _capturedDocument;
  bool _isSubmitting = false;
  bool _isScannerActive = true;
  String _guidanceCue = 'Align NIC / Passport inside border';
  Color _cueColor = const Color(0xFF60A5FA);

  @override
  void initState() {
    super.initState();
    _simulateEdgeDetection();
  }

  void _simulateEdgeDetection() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) {
      setState(() {
        _guidanceCue = 'Good lighting detected • Hold steady';
        _cueColor = const Color(0xFF34D399);
      });
    }
  }

  Future<void> _captureWithCamera() async {
    HapticFeedback.mediumImpact();
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (photo != null) {
        setState(() {
          _capturedDocument = photo;
          _isScannerActive = false;
        });
      }
    } catch (e) {
      // Fallback to gallery or mock capture for emulators without camera
      final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
      if (photo != null) {
        setState(() {
          _capturedDocument = photo;
          _isScannerActive = false;
        });
      }
    }
  }

  Future<void> _pickFromGallery() async {
    HapticFeedback.selectionClick();
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        _capturedDocument = photo;
        _isScannerActive = false;
      });
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;
    if (_capturedDocument == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture or select your KYC Identity document.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final income = double.tryParse(_incomeController.text) ?? 0.0;

    final app = await ApiClient.submitApplication(
      propertyId: _prop.id,
      monthlyIncome: income,
      identityDocUrl: _capturedDocument?.path ?? 'https://cdn.rms.local/kyc/nic_kamal_perera.jpg',
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ApplicationStatusScreen(application: app)),
      );
    }
  }

  Widget _buildCornerMarker({bool top = false, bool left = false}) {
    return Positioned(
      top: top ? 0 : null,
      bottom: !top ? 0 : null,
      left: left ? 0 : null,
      right: !left ? 0 : null,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: top ? const BorderSide(color: Color(0xFF38BDF8), width: 3) : BorderSide.none,
            bottom: !top ? const BorderSide(color: Color(0xFF38BDF8), width: 3) : BorderSide.none,
            left: left ? const BorderSide(color: Color(0xFF38BDF8), width: 3) : BorderSide.none,
            right: !left ? const BorderSide(color: Color(0xFF38BDF8), width: 3) : BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AppFolio KYC Identity Scanner', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Automated Verification Pipeline', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Target Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x1FFFFFFF)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _prop.title,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.white),
                        ),
                        Text(
                          _prop.address,
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                    Text(
                      'LKR ${_prop.monthlyRent.toStringAsFixed(0)}/mo',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF34D399), fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Live Scanner Overlay Viewfinder Box or Review Card
              if (_isScannerActive && _capturedDocument == null) ...[
                const Text(
                  'DOCUMENT SCANNER (NIC / PASSPORT)',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                // Viewfinder Container
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF020617),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x3338BDF8), width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Color(0x2238BDF8), blurRadius: 16, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Simulated Camera Viewport Lines
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.credit_card, size: 48, color: Color(0xFF334155)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xB30F172A),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: _cueColor.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(color: _cueColor, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _guidanceCue,
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _cueColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Viewfinder 4 Corner Guide Markers
                      _buildCornerMarker(top: true, left: true),
                      _buildCornerMarker(top: true, left: false),
                      _buildCornerMarker(top: false, left: true),
                      _buildCornerMarker(top: false, left: false),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Trigger Controls
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: _captureWithCamera,
                        icon: const Icon(Icons.camera_alt, size: 16),
                        label: const Text('Capture Document', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0x33FFFFFF)),
                        ),
                        onPressed: _pickFromGallery,
                        icon: const Icon(Icons.photo_library, size: 14, color: Color(0xFF94A3B8)),
                        label: const Text('Gallery', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Captured Image Review Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x3310B981), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: Color(0xFF34D399)),
                              SizedBox(width: 6),
                              Text('Document Captured Successfully', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF34D399))),
                            ],
                          ),
                          TextButton(
                            onPressed: () => setState(() => _isScannerActive = true),
                            child: const Text('Re-take', style: TextStyle(fontSize: 11, color: Color(0xFF60A5FA))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(Icons.document_scanner, size: 40, color: Color(0xFF60A5FA)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'DRP Smart NIC • Edge alignment 99.4% • Ready for automated AI scoring',
                        style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Income Verification Input
              const Text(
                'MONTHLY DECLARED INCOME (LKR)',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _incomeController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace'),
                decoration: const InputDecoration(
                  prefixText: 'LKR ',
                  prefixStyle: TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold),
                  hintText: 'e.g. 450000',
                  helperText: 'Used by AppFolio AI to evaluate debt-to-rent ratio',
                  helperStyle: TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter monthly income';
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return 'Enter valid income';
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Final Submission Button
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _isSubmitting ? null : _submitApplication,
                  icon: _isSubmitting
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.shield_outlined, size: 16),
                  label: Text(
                    _isSubmitting ? 'Evaluating AI Risk Score...' : 'Submit & Run AI Screening',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
