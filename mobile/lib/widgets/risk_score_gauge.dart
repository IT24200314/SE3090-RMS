import 'package:flutter/material.dart';

class RiskScoreGauge extends StatelessWidget {
  final int score;
  final double size;
  final bool showLabel;

  const RiskScoreGauge({
    super.key,
    required this.score,
    this.size = 54,
    this.showLabel = false,
  });

  Color get _scoreColor {
    if (score >= 80) return const Color(0xFF10B981); // Emerald Mint
    if (score >= 60) return const Color(0xFFF59E0B); // Amber
    return const Color(0xFFEF4444); // Rose
  }

  Color get _scoreBgColor {
    if (score >= 80) return const Color(0x2610B981);
    if (score >= 60) return const Color(0x26F59E0B);
    return const Color(0x26EF4444);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: (score.clamp(0, 100)) / 100,
            strokeWidth: 4.5,
            backgroundColor: _scoreBgColor,
            valueColor: AlwaysStoppedAnimation<Color>(_scoreColor),
            strokeCap: StrokeCap.round,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: size * 0.32,
                  fontWeight: FontWeight.w800,
                  color: _scoreColor,
                  fontFamily: 'monospace',
                ),
              ),
              if (showLabel)
                Text(
                  'SCORE',
                  style: TextStyle(
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
