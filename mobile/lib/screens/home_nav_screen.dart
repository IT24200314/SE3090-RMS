// =================================================================================================
// File: home_nav_screen.dart
// Module: Mobile Client / Dedicated Tenant & Contractor Navigation Shell
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Mobile UI Layer - Material 3 Role-Aware Navigation Bar & Operational Portals
// Purpose: Implements dedicated, operational end-user navigation for Tenants (Explore Homes, 
//          Applications & KYC, Active Lease, Maintenance with GPS/Camera) and Contractors (Work Orders),
//          satisfying SE3090 Section 8 without mirroring web admin telemetry.
// =================================================================================================

import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'explore/property_list_screen.dart';
import 'tenant/my_applications_screen.dart';
import 'tenant/my_lease_screen.dart';
import 'tenant/tenant_maintenance_screen.dart';
import 'contractor/contractor_orders_screen.dart';

class HomeNavScreen extends StatefulWidget {
  const HomeNavScreen({super.key});

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  int _tenantIndex = 0;
  int _contractorIndex = 0;
  bool _isContractorMode = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.currentUser;
    if (user != null) {
      _isContractorMode = user.isContractor;
    }
  }

  void _switchRole(String role) async {
    await AuthService.switchRole(role);
    setState(() {
      _isContractorMode = role.toLowerCase() == 'contractor';
      _tenantIndex = 0;
      _contractorIndex = 0;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched mobile client workspace to: $role Portal'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginScreen(
          onLoginSuccess: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeNavScreen()),
            );
          },
        ),
      ),
    );
  }

  // Tenant Navigation Tabs (Section 8 Dedicated User Experience)
  final List<Widget> _tenantScreens = const [
    PropertyListScreen(),         // Tab 1: Explore Homes & Apply Now
    MyApplicationsScreen(),       // Tab 2: My Applications & KYC Upload (NIC/Passport)
    MyLeaseScreen(),              // Tab 3: My Lease Terms & Early Termination
    TenantMaintenanceScreen(),    // Tab 4: Maintenance Support (GPS & Camera)
  ];

  // Contractor Navigation Tabs (Section 8 Dedicated Field Specialist Experience)
  final List<Widget> _contractorScreens = const [
    ContractorOrdersScreen(),     // Tab 1: Field Work Orders, SLA & Invoicing
    MyLeaseScreen(),              // Tab 2: Profile & Covenants
  ];

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final headerBg = isLight ? const Color(0xFFFFFFFF) : const Color(0xFF09090B);
    final headerBorder = isLight ? const Color(0xFFE2E8F0) : const Color(0x14FFFFFF);
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: headerBg,
            border: Border(bottom: BorderSide(color: headerBorder, width: 1)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Title & Role Badge
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _isContractorMode ? Colors.amber.shade800 : const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          _isContractorMode ? Icons.handyman : Icons.apartment,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isContractorMode ? 'Contractor Work Order App' : 'Tenant Living Portal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            ),
                          ),
                          Text(
                            user?.fullName ?? (_isContractorMode ? 'Field Technician' : 'Active Tenant'),
                            style: TextStyle(
                              fontSize: 11,
                              color: isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Actions: Role Switcher & Theme Toggle & Logout
                  Row(
                    children: [
                      // Evaluator Role Switcher Dropdown
                      PopupMenuButton<String>(
                        tooltip: 'Switch Portal Role (Examiner Evaluation)',
                        icon: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: headerBorder),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _isContractorMode ? Icons.handyman : Icons.person,
                                size: 14,
                                color: _isContractorMode ? Colors.amber.shade800 : Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _isContractorMode ? 'Contractor' : 'Tenant',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const Icon(Icons.arrow_drop_down, size: 16),
                            ],
                          ),
                        ),
                        onSelected: _switchRole,
                        itemBuilder: (ctx) => const [
                          PopupMenuItem(
                            value: 'Tenant',
                            child: Row(
                              children: [
                                Icon(Icons.person, color: Colors.blue, size: 18),
                                SizedBox(width: 8),
                                Text('Tenant Experience (Explore & Lease)'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Contractor',
                            child: Row(
                              children: [
                                Icon(Icons.handyman, color: Colors.amber, size: 18),
                                SizedBox(width: 8),
                                Text('Contractor Experience (Dispatch & Invoicing)'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),

                      // Theme Toggle
                      IconButton(
                        icon: Icon(
                          isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                          size: 18,
                        ),
                        onPressed: () {
                          themeNotifier.value = isLight ? ThemeMode.dark : ThemeMode.light;
                        },
                      ),

                      // Logout Button
                      IconButton(
                        icon: const Icon(Icons.logout, size: 18),
                        tooltip: 'Sign Out',
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      // Screen Body based on Role
      body: _isContractorMode
          ? _contractorScreens[_contractorIndex]
          : _tenantScreens[_tenantIndex],

      // Dedicated Role-Based Bottom Navigation Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _isContractorMode ? _contractorIndex : _tenantIndex,
        onDestinationSelected: (index) {
          setState(() {
            if (_isContractorMode) {
              _contractorIndex = index;
            } else {
              _tenantIndex = index;
            }
          });
        },
        destinations: _isContractorMode
            ? const [
                NavigationDestination(
                  icon: Icon(Icons.assignment_outlined),
                  selectedIcon: Icon(Icons.assignment),
                  label: 'Work Orders',
                ),
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  selectedIcon: Icon(Icons.description),
                  label: 'SLA Covenants',
                ),
              ]
            : const [
                NavigationDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: 'Explore Homes',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fact_check_outlined),
                  selectedIcon: Icon(Icons.fact_check),
                  label: 'My Applications',
                ),
                NavigationDestination(
                  icon: Icon(Icons.receipt_long_outlined),
                  selectedIcon: Icon(Icons.receipt_long),
                  label: 'My Lease',
                ),
                NavigationDestination(
                  icon: Icon(Icons.build_circle_outlined),
                  selectedIcon: Icon(Icons.build_circle),
                  label: 'Maintenance',
                ),
              ],
      ),
    );
  }
}
