import React from 'react';
import { Building2, Users, ShieldAlert, TrendingUp } from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

export const MetricsOverview = ({ stats }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const cards = [
    {
      label: 'Portfolio Units',
      value: stats.totalProperties || 4,
      subValue: `${stats.occupiedCount || 1} Occupied · ${stats.availableCount || 2} Available`,
      icon: Building2,
      color: isLight ? 'text-blue-600' : 'text-indigo-400',
      borderColor: isLight ? 'border-slate-200 hover:border-blue-300' : 'border-indigo-500/20',
      bgGlow: isLight ? 'bg-blue-50/50' : 'bg-indigo-500/5'
    },
    {
      label: 'Monthly Revenue',
      value: `LKR ${(stats.totalRevenue || 795000).toLocaleString()}`,
      subValue: '98.2% Collection Rate',
      icon: TrendingUp,
      color: isLight ? 'text-emerald-600' : 'text-emerald-400',
      borderColor: isLight ? 'border-slate-200 hover:border-emerald-300' : 'border-emerald-500/20',
      bgGlow: isLight ? 'bg-emerald-50/50' : 'bg-emerald-500/5'
    },
    {
      label: 'Screening Pipeline',
      value: `${stats.pendingKyc || 2} In Review`,
      subValue: 'Automated 0-100 Risk AI',
      icon: Users,
      color: isLight ? 'text-violet-600' : 'text-violet-400',
      borderColor: isLight ? 'border-slate-200 hover:border-violet-300' : 'border-violet-500/20',
      bgGlow: isLight ? 'bg-violet-50/50' : 'bg-violet-500/5'
    },
    {
      label: 'HITL Review Guard',
      value: stats.hitlCount ? `${stats.hitlCount} Actions` : 'Active (Ceiling 50K)',
      subValue: 'Zero Policy Violations',
      icon: ShieldAlert,
      color: stats.hitlCount ? (isLight ? 'text-amber-600' : 'text-amber-400') : (isLight ? 'text-slate-500' : 'text-zinc-400'),
      borderColor: stats.hitlCount 
        ? (isLight ? 'border-amber-300' : 'border-amber-500/30') 
        : (isLight ? 'border-slate-200' : 'border-white/[0.06]'),
      bgGlow: stats.hitlCount 
        ? (isLight ? 'bg-amber-50/50' : 'bg-amber-500/5') 
        : (isLight ? 'bg-slate-50/50' : 'bg-transparent')
    }
  ];

  return (
    <div className="grid grid-cols-2 lg:grid-cols-4 gap-3.5 mb-5">
      {cards.map((card, idx) => {
        const Icon = card.icon;
        return (
          <div
            key={idx}
            className={`rounded-xl border p-4 flex flex-col justify-between transition-all duration-200 cursor-default ${
              isLight 
                ? `bg-white shadow-[0_1px_3px_rgba(15,23,42,0.04),0_1px_2px_rgba(15,23,42,0.02)] hover:shadow-md ${card.borderColor}`
                : `bg-zinc-900/60 shadow-[inset_0_1px_0_0_rgba(255,255,255,0.05)] ${card.borderColor}`
            }`}
          >
            <div className="flex items-center justify-between gap-2 mb-2">
              <span className={`text-[11px] font-semibold uppercase tracking-wider ${
                isLight ? 'text-slate-500' : 'text-zinc-400'
              }`}>
                {card.label}
              </span>
              <div className={`p-1.5 rounded-lg ${card.bgGlow}`}>
                <Icon className={`w-3.5 h-3.5 ${card.color}`} />
              </div>
            </div>
            <div>
              <div className={`text-lg font-bold font-mono tracking-tight ${
                isLight ? 'text-slate-900' : 'text-zinc-100'
              }`}>
                {card.value}
              </div>
              <div className={`text-[11px] font-medium mt-0.5 ${
                isLight ? 'text-slate-500' : 'text-zinc-500'
              }`}>
                {card.subValue}
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};
