// =================================================================================================
// File: property_list_screen.dart
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Mobile Layer - Flutter Screen for Property Exploration & Tenancy Status
// Purpose: Presents real-estate property cards with interactive search, filters, pricing details,
//          direct application triggers, and lease lifecycle status tracking.
// =================================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/property.dart';
import '../../services/api_client.dart';
import '../../widgets/metrics_overview_widget.dart';
import '../onboarding/tenant_application_screen.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  List<Property> _properties = [
    Property(
      id: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
      title: 'Oceanfront Luxury Suite',
      description: 'Modern 3-bedroom apartment with panoramic views of the Indian Ocean and direct beach access.',
      address: '142 Marine Drive, Colombo 03',
      monthlyRent: 220000,
      securityDeposit: 440000,
      status: 'Available',
      landlordId: '8f9e0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b',
    ),
    Property(
      id: 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
      title: 'Cinnamon Gardens Townhouse',
      description: 'Colonial style refurbished 4-bedroom villa with private courtyard and solar power system.',
      address: '28 Flower Road, Colombo 07',
      monthlyRent: 350000,
      securityDeposit: 700000,
      status: 'Occupied',
      landlordId: '9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d',
    ),
    Property(
      id: 'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
      title: 'Havelock City Studio Apartment',
      description: 'Fully furnished studio apartment with swimming pool, gym, and clubhouse access.',
      address: '324 Havelock Road, Colombo 05',
      monthlyRent: 95000,
      securityDeposit: 190000,
      status: 'Available',
      landlordId: '0b1c2d3e-4f5a-6b7c-8d9e-0f1a2b3c4d5e',
    ),
    Property(
      id: 'b4d6e1f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
      title: 'Rajagiriya Lakeview Condo',
      description: 'Spacious 2-bedroom unit overlooking the Diyawanna lake with secure parking.',
      address: '88 Lake Drive, Rajagiriya',
      monthlyRent: 130000,
      securityDeposit: 260000,
      status: 'UnderMaintenance',
      landlordId: '1c2d3e4f-5a6b-7c8d-9e0f-1a2b3c4d5e6f',
    ),
  ];

  bool _isLoading = false;
  String _searchQuery = '';
  String _statusFilter = 'ALL';
  bool _isTableView = false;
  final Set<String> _favoriteIds = {};

  final Map<String, String> _propertyPhotos = {
    'Oceanfront': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
    'Cinnamon': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
    'Havelock': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
    'Rajagiriya': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80',
  };

  @override
  void initState() {
    super.initState();
    _loadProperties();
  }

  Future<void> _loadProperties() async {
    if (_properties.isEmpty) {
      setState(() => _isLoading = true);
    }
    try {
      final list = await ApiClient.getProperties(search: _searchQuery);
      if (list.isNotEmpty && mounted) {
        setState(() => _properties = list);
      }
    } catch (_) {}
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _getPhotoForProperty(String title) {
    for (var key in _propertyPhotos.keys) {
      if (title.contains(key)) return _propertyPhotos[key]!;
    }
    return 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80';
  }

  List<Property> get _filteredProperties {
    return _properties.where((p) {
      final matchesSearch = p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.address.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_statusFilter == 'ALL') return matchesSearch;
      if (_statusFilter == 'AVAILABLE') return matchesSearch && (p.status == 'Available' || p.status == '0');
      if (_statusFilter == 'OCCUPIED') return matchesSearch && (p.status == 'Occupied' || p.status == '1');
      if (_statusFilter == 'MAINTENANCE') return matchesSearch && (p.status == 'UnderMaintenance' || p.status == '2');
      return matchesSearch;
    }).toList();
  }

  void _showDraftLeaseModal(Property property) {
    HapticFeedback.mediumImpact();
    final isLight = Theme.of(context).brightness == Brightness.light;
    final tenantController = TextEditingController(text: 'Kamal Perera (NIC: 199238401923)');
    final rentController = TextEditingController(text: property.monthlyRent.toInt().toString());
    final depositController = TextEditingController(text: property.securityDeposit.toInt().toString());
    final termController = TextEditingController(text: '12 Months (Fixed Contract)');
    const generatedClauses = '• Standard 30-day early termination clause.\n• Refundable deposit subject to checkout inventory audit.\n• Maintenance ceiling policy enforced.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Draft & Execute Lease',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      ),
                      Text(
                        property.title,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0x1A2563EB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x332563EB)),
                    ),
                    child: const Text(
                      'Component A',
                      style: TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tenantController,
                style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Selected Tenant',
                  prefixIcon: Icon(Icons.person_outline, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: rentController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Agreed Rent (LKR)',
                        prefixIcon: Icon(Icons.payments_outlined, size: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: depositController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 13),
                      decoration: const InputDecoration(
                        labelText: 'Deposit (LKR)',
                        prefixIcon: Icon(Icons.security, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: termController,
                style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 13),
                decoration: const InputDecoration(
                  labelText: 'Lease Duration',
                  prefixIcon: Icon(Icons.calendar_today_outlined, size: 18),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFF8FAFC) : const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Agentic Lease Clauses',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED)),
                        ),
                        Text(
                          'AI Generated',
                          style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      generatedClauses,
                      style: TextStyle(fontSize: 11, color: isLight ? const Color(0xFF475569) : const Color(0xFF94A3B8), height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        side: BorderSide(color: isLight ? const Color(0xFFCBD5E1) : const Color(0x33FFFFFF)),
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
                        setState(() {
                          final idx = _properties.indexWhere((p) => p.id == property.id);
                          if (idx != -1) {
                            _properties[idx] = Property(
                              id: property.id,
                              title: property.title,
                              description: property.description,
                              address: property.address,
                              monthlyRent: double.tryParse(rentController.text) ?? property.monthlyRent,
                              securityDeposit: double.tryParse(depositController.text) ?? property.securityDeposit,
                              status: 'Occupied',
                              landlordId: property.landlordId,
                            );
                          }
                        });
                        Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lease executed successfully for ${property.title}!'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.verified, size: 16),
                      label: const Text('Execute & Occupy', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTerminateLeaseModal(Property property) {
    HapticFeedback.mediumImpact();
    final isLight = Theme.of(context).brightness == Brightness.light;
    final reasonController = TextEditingController(text: 'Mutual agreement - tenant relocation');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        side: BorderSide(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isLight ? const Color(0xFFCBD5E1) : const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Early Lease Termination',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Property: ${property.title}',
              style: TextStyle(fontSize: 12, color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 12),
              decoration: const InputDecoration(
                labelText: 'Termination Reason & Exit Protocol',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                      side: BorderSide(color: isLight ? const Color(0xFFCBD5E1) : const Color(0x33FFFFFF)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: const Text('Dismiss', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    onPressed: () {
                      setState(() {
                        final idx = _properties.indexWhere((p) => p.id == property.id);
                        if (idx != -1) {
                          _properties[idx] = Property(
                            id: property.id,
                            title: property.title,
                            description: property.description,
                            address: property.address,
                            monthlyRent: property.monthlyRent,
                            securityDeposit: property.securityDeposit,
                            status: 'Available',
                            landlordId: property.landlordId,
                          );
                        }
                      });
                      Navigator.pop(ctx);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Early termination recorded. ${property.title} is now Available.'),
                            backgroundColor: const Color(0xFFEF4444),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.cancel_outlined, size: 16),
                    label: const Text('Confirm Termination', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final occupied = _properties.where((p) => p.status == 'Occupied' || p.status == '1').length;
    final available = _properties.where((p) => p.status == 'Available' || p.status == '0').length;
    final totalRent = _properties.fold<double>(0, (sum, p) => sum + p.monthlyRent);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadProperties,
        color: const Color(0xFF2563EB),
        backgroundColor: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            // Top Metrics Overview Ribbon
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 10),
                child: MetricsOverviewWidget(
                  totalProperties: _properties.length,
                  occupiedCount: occupied,
                  availableCount: available,
                  hitlCount: 1,
                  pendingKyc: 2,
                  totalRevenue: totalRent,
                ),
              ),
            ),

            // Search Bar & Filter Strip with View Toggle
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(fontSize: 12.5, color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                      decoration: InputDecoration(
                        hintText: 'Search listings, road, district...',
                        prefixIcon: Icon(Icons.search, size: 18, color: isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, size: 16, color: isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                onPressed: () => setState(() => _searchQuery = ''),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Filter Chips & Dual View Toggle
                    Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildFilterChip('ALL', 'All Units'),
                                _buildFilterChip('AVAILABLE', 'Available'),
                                _buildFilterChip('OCCUPIED', 'Occupied'),
                                _buildFilterChip('MAINTENANCE', 'Maintenance'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.grid_view_rounded,
                                  size: 18,
                                  color: !_isTableView ? const Color(0xFF2563EB) : (isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                                onPressed: () => setState(() => _isTableView = false),
                                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                                padding: EdgeInsets.zero,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.view_list_rounded,
                                  size: 20,
                                  color: _isTableView ? const Color(0xFF2563EB) : (isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                ),
                                onPressed: () => setState(() => _isTableView = true),
                                constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Content: Grid Cards OR Compact Table List
            _isLoading
                ? const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFF2563EB)),
                    ),
                  )
                : _filteredProperties.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apartment_outlined, size: 48, color: isLight ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
                              const SizedBox(height: 12),
                              Text(
                                'No properties match your filter',
                                style: TextStyle(color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 6),
                              TextButton(
                                onPressed: () => setState(() {
                                  _searchQuery = '';
                                  _statusFilter = 'ALL';
                                }),
                                child: const Text('Reset Filters', style: TextStyle(color: Color(0xFF2563EB))),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _isTableView
                        ? SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final p = _filteredProperties[index];
                                  return _buildCompactListTile(p);
                                },
                                childCount: _filteredProperties.length,
                              ),
                            ),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final p = _filteredProperties[index];
                                  return _buildPropertyCard(p);
                                },
                                childCount: _filteredProperties.length,
                              ),
                            ),
                          ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterId, String label) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isSelected = _statusFilter == filterId;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _statusFilter = filterId);
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF2563EB)
                : isLight
                    ? const Color(0xFFFFFFFF)
                    : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF2563EB)
                  : isLight
                      ? const Color(0xFFE2E8F0)
                      : const Color(0x1FFFFFFF),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : isLight
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCard(Property p) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final photo = _getPhotoForProperty(p.title);
    final isAvail = p.status == 'Available' || p.status == '0';
    final isOcc = p.status == 'Occupied' || p.status == '1';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF), width: 1),
      ),
      elevation: isLight ? 1 : 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.network(
                photo,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                  child: Center(child: Icon(Icons.apartment, color: isLight ? const Color(0xFF94A3B8) : const Color(0xFF64748B), size: 40)),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x66000000), Color(0x00000000), Color(0xCC09090B)],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAvail
                        ? const Color(0xE6059669)
                        : isOcc
                            ? const Color(0xE62563EB)
                            : const Color(0xE6D97706),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6)],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isAvail ? 'Available' : isOcc ? 'Occupied' : 'Maintenance',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    _favoriteIds.contains(p.id) ? Icons.favorite : Icons.favorite_border,
                    color: _favoriteIds.contains(p.id) ? const Color(0xFFEF4444) : Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      if (_favoriteIds.contains(p.id)) {
                        _favoriteIds.remove(p.id);
                      } else {
                        _favoriteIds.add(p.id);
                      }
                    });
                  },
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LKR ${(p.monthlyRent / 1000).toStringAsFixed(0)}k / mo',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        fontFamily: 'monospace',
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Deposit: LKR ${(p.securityDeposit / 1000).toStringAsFixed(0)}k',
                      style: const TextStyle(fontSize: 10, color: Color(0xFFCBD5E1), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 13, color: Color(0xFF2563EB)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        p.address,
                        style: TextStyle(fontSize: 11, color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  p.description,
                  style: TextStyle(fontSize: 11, color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8), height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (isAvail) ...[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _showDraftLeaseModal(p),
                          icon: const Icon(Icons.edit_document, size: 14),
                          label: const Text('Draft Lease', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TenantApplicationScreen(property: p),
                              ),
                            );
                          },
                          icon: const Icon(Icons.camera_alt_outlined, size: 14),
                          label: const Text('Apply (KYC)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2563EB),
                            side: const BorderSide(color: Color(0x332563EB)),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ] else if (isOcc) ...[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _showTerminateLeaseModal(p),
                          icon: const Icon(Icons.cancel_outlined, size: 14),
                          label: const Text('Terminate Lease', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0x1AD97706),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0x33D97706)),
                          ),
                          child: const Text(
                            'Unit Under Maintenance Inspection',
                            style: TextStyle(color: Color(0xFFD97706), fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactListTile(Property p) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final isAvail = p.status == 'Available' || p.status == '0';
    final isOcc = p.status == 'Occupied' || p.status == '1';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isLight ? const Color(0xFFE2E8F0) : const Color(0x1FFFFFFF)),
        boxShadow: isLight
            ? const [BoxShadow(color: Color(0x080F172A), blurRadius: 4, offset: Offset(0, 1))]
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0x1A2563EB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.apartment, color: Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: TextStyle(color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), fontSize: 12.5, fontWeight: FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  p.address,
                  style: TextStyle(color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8), fontSize: 10.5),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'LKR ${(p.monthlyRent / 1000).toStringAsFixed(0)}k',
                      style: const TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: isAvail
                            ? const Color(0x1A10B981)
                            : isOcc
                                ? const Color(0x1A2563EB)
                                : const Color(0x1AF59E0B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isAvail ? 'Available' : isOcc ? 'Occupied' : 'Maintenance',
                        style: TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w700,
                          color: isAvail
                              ? const Color(0xFF059669)
                              : isOcc
                                  ? const Color(0xFF2563EB)
                                  : const Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isAvail)
            IconButton(
              icon: const Icon(Icons.edit_document, color: Color(0xFF2563EB), size: 20),
              onPressed: () => _showDraftLeaseModal(p),
              tooltip: 'Draft Lease',
            )
          else if (isOcc)
            IconButton(
              icon: const Icon(Icons.cancel_outlined, color: Color(0xFFEF4444), size: 20),
              onPressed: () => _showTerminateLeaseModal(p),
              tooltip: 'Terminate Lease',
            ),
        ],
      ),
    );
  }
}
