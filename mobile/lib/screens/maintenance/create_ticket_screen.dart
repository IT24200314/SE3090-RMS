// =================================================================================================
// File: create_ticket_screen.dart
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Mobile Layer - Flutter Screen with Native Hardware (Camera & GPS Geolocation)
// Purpose: Allows tenants to report maintenance issues with priority, capture defect photo evidence
//          via device camera, attach device GPS coordinates, and view live AI triage cost estimates.
// =================================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/api_client.dart';
import '../../services/location_service.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  int _currentStep = 1; // 1: Category & Severity, 2: Photo & GPS, 3: AI Estimate & Confirm
  String _selectedCategory = 'Plumbing';
  int _selectedPriority = 1; // 0: Low, 1: Medium, 2: High, 3: Emergency
  XFile? _photo;
  Position? _location;
  bool _fetchingLocation = false;
  bool _submitting = false;

  // Slide-to-confirm state
  double _sliderValue = 0.0;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Plumbing', 'icon': Icons.water_drop_outlined, 'desc': 'Leaks, clogs, piping, water heating'},
    {'name': 'Electrical', 'icon': Icons.electric_bolt_outlined, 'desc': 'Wiring, outlets, breaker trips'},
    {'name': 'HVAC', 'icon': Icons.ac_unit_outlined, 'desc': 'Air conditioning, filters, airflow'},
    {'name': 'Structural', 'icon': Icons.home_repair_service_outlined, 'desc': 'Locks, doors, windows, drywall'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchGpsCoordinates();
  }

  Future<void> _fetchGpsCoordinates() async {
    setState(() => _fetchingLocation = true);
    final pos = await LocationService.getCurrentLocation();
    setState(() {
      _location = pos;
      _fetchingLocation = false;
    });
  }

  Future<void> _takePhoto() async {
    HapticFeedback.lightImpact();
    final photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (photo != null) {
      setState(() => _photo = photo);
    }
  }

  int _getEstimatedBudget() {
    switch (_selectedCategory) {
      case 'Plumbing':
        return _selectedPriority >= 2 ? 65000 : 25000;
      case 'Electrical':
        return _selectedPriority >= 2 ? 35000 : 18000;
      case 'HVAC':
        return 28000;
      default:
        return 15000;
    }
  }

  Future<void> _submitTicket() async {
    if (_descController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description for the repair issue.')),
      );
      return;
    }

    setState(() => _submitting = true);
    HapticFeedback.heavyImpact();

    final ticket = await ApiClient.createMaintenanceTicket(
      propertyId: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
      issueDescription: '[$_selectedCategory] ${_descController.text}',
      photoUrl: _photo?.path ?? 'https://cdn.rms.local/photos/maintenance_default.jpg',
      priority: _selectedPriority,
      latitude: _location?.latitude.toString(),
      longitude: _location?.longitude.toString(),
    );

    setState(() => _submitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Work order #${ticket.id.substring(0, 8)} created! AI Status: ${ticket.status}'),
          backgroundColor: const Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Row(
        children: [
          _buildStepCircle(1, 'Category'),
          _buildStepDivider(1),
          _buildStepCircle(2, 'Evidence & GPS'),
          _buildStepDivider(2),
          _buildStepCircle(3, 'AI Estimate'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep == step;
    final isDone = _currentStep > step;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: isDone
                  ? const Color(0xFF10B981)
                  : isActive
                      ? const Color(0xFF2563EB)
                      : const Color(0xFF1E293B),
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? const Color(0xFF60A5FA) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '$step',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive ? Colors.white : const Color(0xFF94A3B8),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.white : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepDivider(int step) {
    final isPassed = _currentStep > step;
    return Container(
      width: 24,
      height: 2,
      color: isPassed ? const Color(0xFF10B981) : const Color(0xFF1E293B),
      margin: const EdgeInsets.only(bottom: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final estimatedBudget = _getEstimatedBudget();
    final isOverThreshold = estimatedBudget >= 50000;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AppFolio Smart Maintenance Wizard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            Text('Multi-Step Triage & Dispatch', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
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
              _buildStepIndicator(),
              const SizedBox(height: 16),

              // STEP 1: Category & Severity Picker
              if (_currentStep == 1) ...[
                const Text(
                  'SELECT TRADE CATEGORY',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1.4,
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat['name'];
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() => _selectedCategory = cat['name'] as String);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF1E3A8A) : const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF3B82F6) : const Color(0x1FFFFFFF),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(cat['icon'] as IconData, size: 22, color: isSelected ? Colors.white : const Color(0xFF94A3B8)),
                            const SizedBox(height: 6),
                            Text(
                              cat['name'] as String,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : const Color(0xFFF1F5F9)),
                            ),
                            Text(
                              cat['desc'] as String,
                              style: TextStyle(fontSize: 9, color: isSelected ? const Color(0xFFBFDBFE) : const Color(0xFF64748B)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                const Text(
                  'SEVERITY & URGENCY',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    {'level': 0, 'label': 'Low', 'color': const Color(0xFF94A3B8)},
                    {'level': 1, 'label': 'Medium', 'color': const Color(0xFF38BDF8)},
                    {'level': 2, 'label': 'High', 'color': const Color(0xFFF59E0B)},
                    {'level': 3, 'label': 'Emergency', 'color': const Color(0xFFEF4444)},
                  ].map((p) {
                    final isSel = _selectedPriority == p['level'];
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedPriority = p['level'] as int);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? (p['color'] as Color).withValues(alpha: 0.2) : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel ? (p['color'] as Color) : const Color(0x1FFFFFFF),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              p['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isSel ? (p['color'] as Color) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                const Text(
                  'ISSUE DESCRIPTION',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Describe the issue (e.g. Master bathroom pipe leak flooding floor)',
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      if (_descController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please describe the maintenance issue.')),
                        );
                        return;
                      }
                      setState(() => _currentStep = 2);
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Continue to Photos & GPS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],

              // STEP 2: Photo Attachment & GPS Tagging
              if (_currentStep == 2) ...[
                const Text(
                  'ATTACH PHOTO EVIDENCE',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0x3338BDF8), style: BorderStyle.solid),
                    ),
                    child: _photo != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, size: 36, color: Color(0xFF34D399)),
                                const SizedBox(height: 6),
                                const Text('Photo Evidence Attached', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                                TextButton(onPressed: _takePhoto, child: const Text('Re-take', style: TextStyle(fontSize: 11, color: Color(0xFF60A5FA)))),
                              ],
                            ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined, size: 36, color: Color(0xFF60A5FA)),
                                SizedBox(height: 6),
                                Text('Tap to open camera and snap issue photo', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                              ],
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                // GPS Location Tagging Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x1FFFFFFF)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x1A10B981),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.location_on, size: 20, color: Color(0xFF34D399)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Geotagged Property Coordinates', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                            _fetchingLocation
                                ? const Text('Detecting GPS location...', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)))
                                : Text(
                                    _location != null
                                        ? '${_location!.latitude.toStringAsFixed(4)}° N, ${_location!.longitude.toStringAsFixed(4)}° E'
                                        : '6.9271° N, 79.8612° E (Colombo Core)',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF34D399), fontFamily: 'monospace'),
                                  ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF64748B)),
                        onPressed: _fetchGpsCoordinates,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _currentStep = 1),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: FilledButton.icon(
                        style: FilledButton.styleFrom(backgroundColor: const Color(0xFF2563EB), padding: const EdgeInsets.symmetric(vertical: 12)),
                        onPressed: () => setState(() => _currentStep = 3),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('View AI Pre-Estimate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],

              // STEP 3: AI Pre-Estimate & Slide-to-Confirm
              if (_currentStep == 3) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isOverThreshold ? const Color(0x66F59E0B) : const Color(0x3310B981),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isOverThreshold ? Icons.shield : Icons.verified,
                                size: 18,
                                color: isOverThreshold ? const Color(0xFFF59E0B) : const Color(0xFF34D399),
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'AppFolio AI Triage Prediction',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isOverThreshold ? const Color(0x26F59E0B) : const Color(0x1A10B981),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isOverThreshold ? 'HITL Required' : 'Auto-Approved',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isOverThreshold ? const Color(0xFFFBBF24) : const Color(0xFF34D399),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Predicted Trade:', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          Text('$_selectedCategory Services', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Estimated Budget:', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          Text(
                            'LKR ${estimatedBudget.toString()}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF34D399), fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                      if (isOverThreshold) ...[
                        const Divider(color: Color(0x14FFFFFF), height: 16),
                        const Text(
                          'Notice: Estimate exceeds LKR 50,000 threshold. Will pause at PendingManagerApproval checkpoint for landlord sign-off.',
                          style: TextStyle(fontSize: 10, color: Color(0xFFFBBF24)),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Slide-to-Confirm Interaction
                const Text(
                  'SLIDE TO CONFIRM & DISPATCH',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 10, color: Color(0xFF94A3B8), letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),

                Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(color: const Color(0x1FFFFFFF)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          _submitting ? 'Dispatching Work Order...' : '>>> Slide to Dispatch >>>',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                        ),
                      ),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 52,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 24),
                          overlayShape: SliderComponentShape.noOverlay,
                          activeTrackColor: const Color(0x332563EB),
                          inactiveTrackColor: Colors.transparent,
                          thumbColor: const Color(0xFF2563EB),
                        ),
                        child: Slider(
                          value: _sliderValue,
                          onChanged: (val) {
                            setState(() => _sliderValue = val);
                            if (val >= 0.95 && !_submitting) {
                              _submitTicket();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() => _currentStep = 2),
                    child: const Text('Back to Photos', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
