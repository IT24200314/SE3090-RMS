import React, { useState, useEffect } from 'react';
import { 
  Building2, 
  Search, 
  Sparkles, 
  Activity, 
  CheckCircle2, 
  AlertTriangle, 
  Users, 
  ChevronDown, 
  SlidersHorizontal,
  Command,
  Sun,
  Moon
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

export const Header = ({ currentTitle, subtitle, onSelectProperty, selectedPropertyFilter }) => {
  const { theme, toggleTheme } = useTheme();
  const [isSearchFocused, setIsSearchFocused] = useState(false);
  const [searchValue, setSearchValue] = useState('');
  const [showPropertyDropdown, setShowPropertyDropdown] = useState(false);
  const [selectedProperty, setSelectedProperty] = useState(selectedPropertyFilter || 'All Properties (Portfolio)');

  // Global Ctrl+K / Cmd+K listener
  useEffect(() => {
    const handleKeyDown = (e) => {
      if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
        e.preventDefault();
        const searchInput = document.getElementById('global-search-input');
        if (searchInput) {
          searchInput.focus();
        }
      }
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, []);

  const propertiesList = [
    'All Properties (Portfolio)',
    '142 Marine Drive, Colombo 03',
    '28 Flower Road, Colombo 07',
    '324 Havelock Road, Colombo 05',
    '88 Lake Drive, Rajagiriya'
  ];

  const handleSelectProp = (prop) => {
    setSelectedProperty(prop);
    setShowPropertyDropdown(false);
    if (onSelectProperty) {
      onSelectProperty(prop);
    }
  };

  const isLight = theme === 'light';

  return (
    <header className={`px-6 py-2.5 sticky top-0 z-30 flex flex-col md:flex-row md:items-center md:justify-between gap-3 transition-colors duration-200 ${
      isLight 
        ? 'bg-white/90 backdrop-blur-md border-b border-slate-200/90 shadow-xs' 
        : 'bg-slate-950/90 backdrop-blur-md border-b border-slate-800/80 shadow-sm'
    }`}>
      {/* Left: Title & Property Selector */}
      <div className="flex items-center gap-4 min-w-0">
        <div>
          <div className="flex items-center gap-2">
            <h1 className={`text-sm font-bold tracking-tight ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
              {currentTitle}
            </h1>
            <span className={`hidden sm:inline-flex items-center gap-1 text-[10px] font-semibold px-2 py-0.5 rounded-full border ${
              isLight 
                ? 'bg-blue-50 text-blue-700 border-blue-200' 
                : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
            }`}>
              AppFolio Pro
            </span>
          </div>
          <p className={`text-[11px] font-normal truncate ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
            {subtitle}
          </p>
        </div>

        {/* Active Property Dropdown */}
        <div className="relative hidden xl:block">
          <button
            onClick={() => setShowPropertyDropdown(!showPropertyDropdown)}
            className={`flex items-center gap-2 px-3 py-1.5 rounded-lg border text-xs transition-all cursor-pointer font-medium ${
              isLight 
                ? 'bg-slate-50 border-slate-200 text-slate-800 hover:bg-slate-100' 
                : 'bg-slate-900 border-slate-800 text-slate-200 hover:border-slate-700 hover:bg-slate-800/80'
            }`}
          >
            <Building2 className="w-3.5 h-3.5 text-blue-600" />
            <span className="max-w-[160px] truncate">{selectedProperty}</span>
            <ChevronDown className={`w-3 h-3 ${isLight ? 'text-slate-400' : 'text-slate-500'}`} />
          </button>

          {showPropertyDropdown && (
            <div className={`absolute left-0 mt-1.5 w-64 rounded-xl shadow-xl py-1 z-40 text-xs border ${
              isLight 
                ? 'bg-white border-slate-200 text-slate-800' 
                : 'bg-slate-900 border-slate-800 text-slate-200'
            }`}>
              <div className={`px-3 py-1.5 text-[10px] font-semibold uppercase tracking-wider border-b ${
                isLight ? 'text-slate-400 border-slate-100' : 'text-slate-400 border-slate-800/80'
              }`}>
                Filter by Property Asset
              </div>
              {propertiesList.map((p) => (
                <button
                  key={p}
                  onClick={() => handleSelectProp(p)}
                  className={`w-full text-left px-3 py-2 text-xs transition-colors flex items-center justify-between ${
                    selectedProperty === p 
                      ? 'text-blue-600 font-semibold bg-blue-50' 
                      : isLight ? 'text-slate-700 hover:bg-slate-50' : 'text-slate-300 hover:bg-slate-800'
                  }`}
                >
                  <span className="truncate">{p}</span>
                  {selectedProperty === p && <CheckCircle2 className="w-3.5 h-3.5 text-blue-600 flex-shrink-0" />}
                </button>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Center: Global Search Bar with Hotkey */}
      <div className="relative flex-1 max-w-md mx-0 md:mx-4">
        <div className={`relative flex items-center w-full rounded-lg border transition-all ${
          isLight
            ? isSearchFocused 
                ? 'bg-white border-blue-500 ring-2 ring-blue-100 shadow-sm' 
                : 'bg-slate-100/90 border-slate-200 hover:border-slate-300'
            : isSearchFocused 
                ? 'bg-slate-900 border-blue-500 shadow-[0_0_0_2px_rgba(37,99,235,0.2)]' 
                : 'bg-slate-900 border-slate-800 hover:border-slate-700'
        }`}>
          <Search className={`w-3.5 h-3.5 ml-3 flex-shrink-0 ${isLight ? 'text-slate-400' : 'text-slate-400'}`} />
          <input
            id="global-search-input"
            type="text"
            placeholder="Search leases, tenants, work orders, units..."
            value={searchValue}
            onChange={(e) => setSearchValue(e.target.value)}
            onFocus={() => setIsSearchFocused(true)}
            onBlur={() => setIsSearchFocused(false)}
            className={`w-full bg-transparent px-3 py-1.5 text-xs focus:outline-none ${
              isLight ? 'text-slate-900 placeholder-slate-400' : 'text-slate-100 placeholder-slate-500'
            }`}
          />
          <div className={`flex items-center gap-1 mr-2 px-1.5 py-0.5 rounded border text-[10px] font-mono select-none ${
            isLight ? 'bg-slate-200/80 border-slate-300 text-slate-500' : 'bg-slate-800 border-slate-700/60 text-slate-400'
          }`}>
            <Command className="w-2.5 h-2.5" />
            <span>K</span>
          </div>
        </div>
      </div>

      {/* Right: Quick KPI Pills, Theme Switcher & System Health */}
      <div className="flex items-center gap-2.5 flex-shrink-0">
        {/* Quick KPI Pills */}
        <div className="hidden lg:flex items-center gap-2">
          {/* Occupancy Rate */}
          <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg border text-xs ${
            isLight ? 'bg-emerald-50/80 border-emerald-200 text-emerald-800' : 'bg-slate-900 border-slate-800'
          }`}>
            <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
            <span className={`text-[11px] ${isLight ? 'text-slate-600' : 'text-slate-400'}`}>Occupancy:</span>
            <span className="font-semibold text-emerald-600 font-mono text-[11px]">75%</span>
          </div>

          {/* Pending Applications */}
          <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg border text-xs ${
            isLight ? 'bg-blue-50/80 border-blue-200 text-blue-800' : 'bg-slate-900 border-slate-800'
          }`}>
            <Users className="w-3 h-3 text-blue-600" />
            <span className={`text-[11px] ${isLight ? 'text-slate-600' : 'text-slate-400'}`}>Screening:</span>
            <span className="font-semibold text-blue-600 font-mono text-[11px]">2 Pending</span>
          </div>

          {/* Urgent Repairs */}
          <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-lg border text-xs ${
            isLight ? 'bg-amber-50/80 border-amber-200 text-amber-900' : 'bg-amber-500/10 border-amber-500/20'
          }`}>
            <AlertTriangle className="w-3 h-3 text-amber-500" />
            <span className={`text-[11px] ${isLight ? 'text-amber-800' : 'text-amber-300'}`}>Repairs:</span>
            <span className="font-semibold text-amber-600 font-mono text-[11px]">1 Urgent</span>
          </div>
        </div>

        {/* Backend Health Indicator */}
        <div className={`flex items-center gap-1.5 px-2.5 py-1 rounded-full border text-[11px] ${
          isLight ? 'bg-slate-100 border-slate-200' : 'bg-slate-900 border-slate-800'
        }`}>
          <span className="relative flex h-2 w-2">
            <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
            <span className="relative inline-flex rounded-full h-2 w-2 bg-emerald-500"></span>
          </span>
          <span className={`font-medium hidden sm:inline ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>API</span>
          <span className="text-emerald-600 font-mono text-[10px] font-semibold">24ms</span>
        </div>

        {/* Theme Mode Switcher (Light / Dark) */}
        <button
          onClick={toggleTheme}
          title={isLight ? 'Switch to Dark Mode' : 'Switch to Light Mode'}
          className={`flex items-center justify-center w-8 h-8 rounded-lg border transition-all cursor-pointer ${
            isLight 
              ? 'bg-slate-100 hover:bg-slate-200 border-slate-200 text-slate-700' 
              : 'bg-slate-900 hover:bg-slate-800 border-slate-800 text-amber-400'
          }`}
        >
          {isLight ? <Moon className="w-4 h-4 text-slate-600" /> : <Sun className="w-4 h-4 text-amber-400" />}
        </button>
      </div>
    </header>
  );
};
