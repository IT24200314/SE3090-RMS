import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import 'explore/property_list_screen.dart';
import 'onboarding/tenant_review_portal_screen.dart';
import 'maintenance/maintenance_board_screen.dart';
import 'ai_telemetry/ai_execution_trace_screen.dart';

class HomeNavScreen extends StatefulWidget {
  const HomeNavScreen({super.key});

  @override
  State<HomeNavScreen> createState() => _HomeNavScreenState();
}

class _HomeNavScreenState extends State<HomeNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PropertyListScreen(),         // Component A (Upamada)
    TenantReviewPortalScreen(),   // Component B (Nethmi)
    MaintenanceBoardScreen(),     // Component C (Hashini)
    AiExecutionTraceScreen(),     // Agentic AI LangGraph StateGraph
  ];

  String _getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Property & Lease Management';
      case 1:
        return 'Tenant Screening & KYC';
      case 2:
        return 'Maintenance & Dispatch';
      case 3:
        return 'Agentic AI Execution Telemetry';
      default:
        return 'Rental Management System';
    }
  }

  String _getSubtitle() {
    switch (_currentIndex) {
      case 0:
        return 'Component A (Upamada) — Inventory & Leases';
      case 1:
        return 'Component B (Nethmi) — Risk Scoring & KYC';
      case 2:
        return 'Component C (Hashini) — Triage & HITL';
      case 3:
        return 'Multi-Agent LangGraph StateGraph';
      default:
        return 'Staff & Tenant Operations Nexus';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final headerBg = isLight ? const Color(0xFFFFFFFF) : const Color(0xFF09090B);
    final headerBorder = isLight ? const Color(0xFFE2E8F0) : const Color(0x14FFFFFF);
    final textColor = isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final subtextColor = isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            color: headerBg,
            border: Border(
              bottom: BorderSide(color: headerBorder, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(color: Color(0x332563EB), blurRadius: 8, offset: Offset(0, 2)),
                          ],
                        ),
                        child: const Center(
                          child: Icon(Icons.apartment, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text(
                                _getTitle(),
                                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: textColor, letterSpacing: -0.2),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: isLight ? const Color(0x1A2563EB) : const Color(0x262563EB),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: const Color(0x4D2563EB)),
                                ),
                                child: const Text(
                                  'PRO',
                                  style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF2563EB), fontFamily: 'monospace'),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _getSubtitle(),
                            style: TextStyle(fontSize: 10, color: subtextColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Theme Toggle Button (Light/Dark mode)
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          themeNotifier.value = themeNotifier.value == ThemeMode.dark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isLight ? const Color(0xFFF1F5F9) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isLight ? const Color(0xFFCBD5E1) : const Color(0x33FFFFFF)),
                          ),
                          child: Icon(
                            isLight ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                            size: 16,
                            color: isLight ? const Color(0xFF475569) : const Color(0xFFFBBF24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // System Online Status Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0x1A10B981),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0x3310B981)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'net10.0',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF10B981)),
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
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: headerBg,
          border: Border(
            top: BorderSide(color: headerBorder, width: 1),
          ),
        ),
        child: NavigationBar(
          height: 64,
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            HapticFeedback.selectionClick();
            setState(() => _currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.apartment_outlined),
              selectedIcon: Icon(Icons.apartment),
              label: 'Properties',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Screening',
            ),
            NavigationDestination(
              icon: Icon(Icons.handyman_outlined),
              selectedIcon: Icon(Icons.handyman),
              label: 'Maintenance',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined),
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'AI Telemetry',
            ),
          ],
        ),
      ),
    );
  }
}
