import React from 'react';
import { 
  Building2, 
  Users, 
  Wrench, 
  Sparkles, 
  Layers, 
  ShieldCheck, 
  ChevronRight,
  Activity
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

export const Sidebar = ({ activeTab, setActiveTab }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const menuItems = [
    {
      id: 'properties',
      label: 'Properties & Leases',
      icon: Building2,
      badge: 'Upamada',
      badgeColorLight: 'bg-blue-50 text-blue-700 border-blue-200',
      badgeColorDark: 'bg-blue-500/10 text-blue-400 border-blue-500/20'
    },
    {
      id: 'tenants',
      label: 'Tenant Screening & KYC',
      icon: Users,
      badge: 'Nethmi',
      badgeColorLight: 'bg-emerald-50 text-emerald-700 border-emerald-200',
      badgeColorDark: 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
    },
    {
      id: 'maintenance',
      label: 'Maintenance & Dispatch',
      icon: Wrench,
      badge: 'Hashini',
      badgeColorLight: 'bg-amber-50 text-amber-700 border-amber-200',
      badgeColorDark: 'bg-amber-500/10 text-amber-400 border-amber-500/20'
    },
    {
      id: 'ai-trace',
      label: 'Agentic AI Telemetry',
      icon: Sparkles,
      badge: 'StateGraph',
      badgeColorLight: 'bg-indigo-50 text-indigo-700 border-indigo-200',
      badgeColorDark: 'bg-indigo-500/10 text-indigo-400 border-indigo-500/20'
    }
  ];

  return (
    <aside className={`w-64 flex flex-col flex-shrink-0 min-h-screen select-none transition-colors duration-200 ${
      isLight 
        ? 'bg-white border-r border-slate-200/90 text-slate-800' 
        : 'bg-slate-950 border-r border-slate-800/80 text-slate-200'
    }`}>
      {/* AppFolio Style Brand Header */}
      <div className={`h-14 px-5 border-b flex items-center justify-between ${
        isLight ? 'border-slate-100' : 'border-slate-800/80'
      }`}>
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-blue-600 via-indigo-600 to-slate-900 flex items-center justify-center shadow-md shadow-blue-500/20 border border-blue-400/30">
            <Building2 className="w-4 h-4 text-white" />
          </div>
          <div>
            <div className="flex items-center gap-1.5">
              <span className={`font-bold text-sm tracking-tight ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                RMS Nexus
              </span>
              <span className={`text-[9px] font-mono font-bold px-1.5 py-0.2 rounded border ${
                isLight ? 'bg-blue-50 text-blue-700 border-blue-200' : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
              }`}>
                PRO
              </span>
            </div>
            <span className={`text-[10px] block leading-tight ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
              PropTech Enterprise
            </span>
          </div>
        </div>
      </div>

      {/* Navigation Links */}
      <nav className="flex-1 px-3 py-4 space-y-1.5 overflow-y-auto">
        <div className={`px-2 pb-1 text-[10px] font-bold uppercase tracking-wider ${
          isLight ? 'text-slate-400' : 'text-slate-400'
        }`}>
          Management Modules
        </div>
        {menuItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`w-full flex items-center justify-between px-3 py-2.5 rounded-xl text-xs font-semibold transition-all duration-150 cursor-pointer ${
                isActive
                  ? isLight
                    ? 'bg-blue-50 text-blue-700 border border-blue-200/80 shadow-xs'
                    : 'bg-blue-600/15 text-blue-400 border border-blue-500/30 shadow-[0_2px_10px_-2px_rgba(37,99,235,0.25)]'
                  : isLight
                    ? 'text-slate-600 hover:bg-slate-50 hover:text-slate-900 border border-transparent'
                    : 'text-slate-400 hover:bg-slate-900 hover:text-slate-200 border border-transparent'
              }`}
            >
              <div className="flex items-center gap-2.5">
                <Icon className={`w-4 h-4 transition-colors ${
                  isActive ? (isLight ? 'text-blue-600' : 'text-blue-400') : (isLight ? 'text-slate-400' : 'text-slate-500')
                }`} />
                <span>{item.label}</span>
              </div>
              <div className="flex items-center gap-1.5">
                <span className={`text-[10px] font-medium px-2 py-0.5 rounded-full border ${
                  isLight ? item.badgeColorLight : item.badgeColorDark
                }`}>
                  {item.badge}
                </span>
                {isActive && (
                  <ChevronRight className={`w-3 h-3 ${isLight ? 'text-blue-600' : 'text-blue-400'}`} />
                )}
              </div>
            </button>
          );
        })}
      </nav>

      {/* Footer System Status */}
      <div className={`p-3 border-t ${isLight ? 'border-slate-100 bg-slate-50/50' : 'border-slate-800/80 bg-slate-950'}`}>
        <div className={`rounded-xl p-3 border space-y-1.5 ${
          isLight ? 'bg-white border-slate-200/80 shadow-xs' : 'bg-slate-900/90 border-slate-800'
        }`}>
          <div className="flex items-center justify-between text-xs">
            <span className={`text-[11px] font-medium flex items-center gap-1.5 ${isLight ? 'text-slate-600' : 'text-slate-300'}`}>
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-500" />
              HITL Guard
            </span>
            <span className={`font-mono text-[10px] px-1.5 py-0.5 rounded border ${
              isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
            }`}>
              Active
            </span>
          </div>
          <div className="flex items-center justify-between text-xs pt-1">
            <span className={`text-[11px] font-medium flex items-center gap-1.5 ${isLight ? 'text-slate-600' : 'text-slate-300'}`}>
              <Activity className="w-3.5 h-3.5 text-blue-500" />
              LangGraph
            </span>
            <span className={`text-[10px] font-mono ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
              Checkpoint v2
            </span>
          </div>
        </div>
      </div>
    </aside>
  );
};
