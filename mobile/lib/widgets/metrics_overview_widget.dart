import 'package:flutter/material.dart';

class MetricsOverviewWidget extends StatelessWidget {
  final int totalProperties;
  final int occupiedCount;
  final int availableCount;
  final int hitlCount;
  final int pendingKyc;
  final double totalRevenue;

  const MetricsOverviewWidget({
    super.key,
    this.totalProperties = 4,
    this.occupiedCount = 1,
    this.availableCount = 2,
    this.hitlCount = 1,
    this.pendingKyc = 2,
    this.totalRevenue = 795000,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SizedBox(
      height: 110,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildMetricCard(
            context: context,
            label: 'Portfolio Units',
            value: '$totalProperties',
            subValue: '$occupiedCount Occupied · $availableCount Ready',
            icon: Icons.apartment,
            iconColor: isLight ? const Color(0xFF2563EB) : const Color(0xFF60A5FA),
            borderColor: isLight ? const Color(0xFFE2E8F0) : const Color(0x333B82F6),
            bgGlow: isLight ? const Color(0xFFEFF6FF) : const Color(0x1A3B82F6),
          ),
          const SizedBox(width: 10),
          _buildMetricCard(
            context: context,
            label: 'Monthly Revenue',
            value: 'LKR ${(totalRevenue / 1000).toStringAsFixed(0)}k',
            subValue: '98.2% Collection Rate',
            icon: Icons.trending_up,
            iconColor: isLight ? const Color(0xFF059669) : const Color(0xFF34D399),
            borderColor: isLight ? const Color(0xFFE2E8F0) : const Color(0x3310B981),
            bgGlow: isLight ? const Color(0xFFECFDF5) : const Color(0x1A10B981),
          ),
          const SizedBox(width: 10),
          _buildMetricCard(
            context: context,
            label: 'Screening Pipeline',
            value: '$pendingKyc In Review',
            subValue: 'Automated 0-100 Risk AI',
            icon: Icons.people_outline,
            iconColor: isLight ? const Color(0xFF7C3AED) : const Color(0xFFA78BFA),
            borderColor: isLight ? const Color(0xFFE2E8F0) : const Color(0x338B5CF6),
            bgGlow: isLight ? const Color(0xFFF5F3FF) : const Color(0x1A8B5CF6),
          ),
          const SizedBox(width: 10),
          _buildMetricCard(
            context: context,
            label: 'HITL Review Guard',
            value: hitlCount > 0 ? '$hitlCount Actions' : 'Active (Ceiling 50K)',
            subValue: 'Zero Policy Violations',
            icon: Icons.shield_outlined,
            iconColor: isLight ? const Color(0xFFD97706) : const Color(0xFFFBBF24),
            borderColor: isLight ? const Color(0xFFFDE68A) : const Color(0x33F59E0B),
            bgGlow: isLight ? const Color(0xFFFFFBEB) : const Color(0x1AF59E0B),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String label,
    required String value,
    required String subValue,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required Color bgGlow,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final cardBg = isLight ? const Color(0xFFFFFFFF) : const Color(0xFF0F172A);
    final textTitleColor = isLight ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final textSubColor = isLight ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

    return Container(
      width: 175,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: isLight ? const Color(0x0A0F172A) : const Color(0x1A000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: textSubColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: bgGlow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: textTitleColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'monospace',
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subValue,
                style: TextStyle(
                  color: textSubColor,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
