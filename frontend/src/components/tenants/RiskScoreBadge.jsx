import React from 'react';
import { ShieldCheck, ShieldAlert, AlertOctagon, Sparkles } from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

export const RiskScoreGauge = ({ score = 85, size = 68, showLabel = true }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  // Score bounds 0-100
  const clampedScore = Math.min(Math.max(Number(score) || 0, 0), 100);
  
  // Calculate SVG arc parameters
  const strokeWidth = 6;
  const radius = (size - strokeWidth * 2) / 2;
  const circumference = 2 * Math.PI * radius;
  const strokeDashoffset = circumference - (clampedScore / 100) * circumference;

  let colorClass = '#10B981'; // Emerald
  let glowColor = 'rgba(16, 185, 129, 0.25)';
  let ratingText = 'Low Risk';
  let badgeBg = isLight 
    ? 'bg-emerald-50 text-emerald-700 border-emerald-200' 
    : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/25';

  if (clampedScore < 50) {
    colorClass = '#EF4444'; // Crimson
    glowColor = 'rgba(239, 68, 68, 0.25)';
    ratingText = 'High Risk';
    badgeBg = isLight 
      ? 'bg-rose-50 text-rose-700 border-rose-200' 
      : 'bg-rose-500/10 text-rose-400 border-rose-500/25';
  } else if (clampedScore < 80) {
    colorClass = '#F59E0B'; // Amber
    glowColor = 'rgba(245, 158, 11, 0.25)';
    ratingText = 'Moderate';
    badgeBg = isLight 
      ? 'bg-amber-50 text-amber-700 border-amber-200' 
      : 'bg-amber-500/10 text-amber-400 border-amber-500/25';
  }

  return (
    <div className="flex flex-col items-center justify-center">
      <div className="relative flex items-center justify-center" style={{ width: size, height: size }}>
        <svg className="w-full h-full -rotate-90">
          {/* Background Track */}
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            stroke={isLight ? '#E2E8F0' : '#1E293B'}
            strokeWidth={strokeWidth}
            fill="transparent"
          />
          {/* Animated Value Stroke */}
          <circle
            cx={size / 2}
            cy={size / 2}
            r={radius}
            stroke={colorClass}
            strokeWidth={strokeWidth}
            fill="transparent"
            strokeDasharray={circumference}
            strokeDashoffset={strokeDashoffset}
            strokeLinecap="round"
            style={{
              transition: 'stroke-dashoffset 0.8s ease-in-out',
              filter: `drop-shadow(0 0 6px ${glowColor})`
            }}
          />
        </svg>

        {/* Center Score Number */}
        <div className="absolute inset-0 flex flex-col items-center justify-center leading-none">
          <span className={`text-sm font-black font-mono tracking-tight ${
            isLight ? 'text-slate-900' : 'text-slate-100'
          }`}>
            {clampedScore}
          </span>
          <span className={`text-[8px] font-mono font-medium ${
            isLight ? 'text-slate-400' : 'text-slate-500'
          }`}>
            /100
          </span>
        </div>
      </div>

      {showLabel && (
        <span className={`mt-1 text-[10px] font-semibold px-2 py-0.5 rounded-full border ${badgeBg}`}>
          {ratingText}
        </span>
      )}
    </div>
  );
};

export const RiskScoreBadge = ({ score = 85, status }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  if (score >= 80 || status === 'Approved' || status === 1) {
    return (
      <div className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold border shadow-xs ${
        isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
      }`}>
        <ShieldCheck className="w-3 h-3 text-emerald-600" />
        <span>Low Risk ({score}/100)</span>
      </div>
    );
  }

  if (score >= 50 || status === 'ReviewRequired' || status === 3) {
    return (
      <div className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold border shadow-xs ${
        isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
      }`}>
        <ShieldAlert className="w-3 h-3 text-amber-600" />
        <span>Review Required ({score}/100)</span>
      </div>
    );
  }

  return (
    <div className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-[11px] font-semibold border shadow-xs ${
      isLight ? 'bg-rose-50 text-rose-700 border-rose-200' : 'bg-rose-500/10 text-rose-400 border-rose-500/20'
    }`}>
      <AlertOctagon className="w-3 h-3 text-rose-600" />
      <span>High Risk ({score}/100)</span>
    </div>
  );
};
