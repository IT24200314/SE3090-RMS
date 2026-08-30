// =================================================================================================
// File: PropertyList.jsx
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Frontend Layer - React Component for Property Inventory & Lease Workflows
// Purpose: Displays real-time property inventory with debounced search, status filtering,
//          grid/table toggles, lease agreement generation, and early termination triggers.
// =================================================================================================

import React, { useState, useEffect, useCallback } from 'react';
import { 
  Search, 
  RefreshCw, 
  Building2, 
  LayoutGrid, 
  Table, 
  SlidersHorizontal, 
  Sparkles,
  ArrowUpDown,
  FileText,
  XCircle,
  ExternalLink
} from 'lucide-react';
import { PropertyCard } from './PropertyCard';
import { LeaseModal } from './LeaseModal';
import { AiExecutionTrace } from './AiExecutionTrace';
import { useToast } from '../common/Toast';
import { useTheme } from '../../context/ThemeContext';
import { propertyService } from '../../services/api';

const INITIAL_PROPERTIES = [
  {
    id: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
    title: 'Oceanfront Luxury Suite',
    description: 'Modern 3-bedroom apartment with panoramic views of the Indian Ocean and direct beach access.',
    address: '142 Marine Drive, Colombo 03',
    monthlyRent: 220000,
    securityDeposit: 440000,
    status: 0, // Available
    landlordId: '8f9e0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b'
  },
  {
    id: 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
    title: 'Cinnamon Gardens Townhouse',
    description: 'Colonial style refurbished 4-bedroom villa with private courtyard and solar power system.',
    address: '28 Flower Road, Colombo 07',
    monthlyRent: 350000,
    securityDeposit: 700000,
    status: 1, // Occupied
    landlordId: '9a0b1c2d-3e4f-5a6b-7c8d-9e0f1a2b3c4d'
  },
  {
    id: 'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
    title: 'Havelock City Studio Apartment',
    description: 'Fully furnished studio apartment with swimming pool, gym, and clubhouse access.',
    address: '324 Havelock Road, Colombo 05',
    monthlyRent: 95000,
    securityDeposit: 190000,
    status: 0, // Available
    landlordId: '0b1c2d3e-4f5a-6b7c-8d9e-0f1a2b3c4d5e'
  },
  {
    id: 'b4d6e1f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
    title: 'Rajagiriya Lakeview Condo',
    description: 'Spacious 2-bedroom unit overlooking the Diyawanna lake with secure parking.',
    address: '88 Lake Drive, Rajagiriya',
    monthlyRent: 130000,
    securityDeposit: 260000,
    status: 2, // UnderMaintenance
    landlordId: '1c2d3e4f-5a6b-7c8d-9e0f-1a2b3c4d5e6f'
  }
];

export const PropertyList = () => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [properties, setProperties] = useState(INITIAL_PROPERTIES);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('ALL');
  const [viewMode, setViewMode] = useState('grid'); // 'grid' | 'table'
  const [showAiTrace, setShowAiTrace] = useState(false);
  const [loading, setLoading] = useState(false);
  const [selectedProperty, setSelectedProperty] = useState(null);
  const [modalMode, setModalMode] = useState(null); // 'draft' | 'terminate'
  const { addToast } = useToast();

  const fetchProperties = useCallback(async () => {
    setLoading(true);
    try {
      const res = await propertyService.getProperties(searchTerm);
      if (res.data && res.data.length > 0) {
        setProperties(res.data);
      }
    } catch (err) {
      console.warn('Backend connection unavailable, using localized state:', err.message);
    } finally {
      setLoading(false);
    }
  }, [searchTerm]);

  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      fetchProperties();
    }, 400);

    return () => clearTimeout(delayDebounceFn);
  }, [fetchProperties]);

  const handleDraftLease = (property) => {
    setSelectedProperty(property);
    setModalMode('draft');
  };

  const handleTerminateLease = (property) => {
    setSelectedProperty(property);
    setModalMode('terminate');
  };

  const submitDraft = (leaseData) => {
    setProperties(prev => prev.map(p => {
      if (p.id === selectedProperty.id) {
        return { ...p, status: 1 }; // Move to Occupied
      }
      return p;
    }));
    addToast(`Lease executed successfully for ${selectedProperty.title}!`, 'success');
    setModalMode(null);
  };

  const submitTerminate = (terminationData) => {
    setProperties(prev => prev.map(p => {
      if (p.id === selectedProperty.id) {
        return { ...p, status: 0 }; // Return to Available
      }
      return p;
    }));
    addToast(`Early termination recorded for ${selectedProperty.title}.`, 'info');
    setModalMode(null);
  };

  const filteredProperties = properties.filter((p) => {
    const matchesSearch = p.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
                          p.address.toLowerCase().includes(searchTerm.toLowerCase());
    if (statusFilter === 'ALL') return matchesSearch;
    if (statusFilter === 'AVAILABLE') return matchesSearch && (p.status === 0 || p.status === 'Available');
    if (statusFilter === 'OCCUPIED') return matchesSearch && (p.status === 1 || p.status === 'Occupied');
    if (statusFilter === 'MAINTENANCE') return matchesSearch && (p.status === 2 || p.status === 'UnderMaintenance');
    return matchesSearch;
  });

  const totalRentRoll = properties.reduce((acc, curr) => acc + Number(curr.monthlyRent || 0), 0);
  const occupiedCount = properties.filter(p => p.status === 1 || p.status === 'Occupied').length;
  const occupancyRate = properties.length > 0 ? Math.round((occupiedCount / properties.length) * 100) : 0;

  return (
    <div className="space-y-4">
      {/* AppFolio Portfolio Overview Metric Strip */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3.5">
        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight 
            ? 'bg-white border-slate-200/90 shadow-xs' 
            : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Portfolio Units
            </span>
            <span className={`text-base font-bold font-mono ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
              {properties.length} Units
            </span>
          </div>
          <div className={`p-2 rounded-lg ${isLight ? 'bg-blue-50' : 'bg-blue-500/10'}`}>
            <Building2 className={`w-4 h-4 ${isLight ? 'text-blue-600' : 'text-blue-400'}`} />
          </div>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight 
            ? 'bg-white border-slate-200/90 shadow-xs' 
            : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Occupancy Rate
            </span>
            <span className="text-base font-bold text-emerald-600 font-mono">{occupancyRate}%</span>
          </div>
          <span className={`text-[10px] px-2 py-0.5 rounded-full font-semibold border ${
            isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
          }`}>
            Healthy
          </span>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight 
            ? 'bg-white border-slate-200/90 shadow-xs' 
            : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Monthly Rent Roll
            </span>
            <span className={`text-base font-bold font-mono ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
              LKR {(totalRentRoll / 1000).toFixed(0)}k
            </span>
          </div>
          <span className={`text-[10px] font-mono ${isLight ? 'text-slate-400' : 'text-slate-400'}`}>
            Gross Target
          </span>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight 
            ? 'bg-white border-slate-200/90 shadow-xs' 
            : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Available for Lease
            </span>
            <span className="text-base font-bold text-blue-600 font-mono">
              {properties.filter(p => p.status === 0 || p.status === 'Available').length} Ready
            </span>
          </div>
          <button
            onClick={() => setShowAiTrace(!showAiTrace)}
            className={`flex items-center gap-1 text-[11px] font-semibold px-2.5 py-1 rounded-lg border transition-all cursor-pointer ${
              isLight 
                ? 'bg-indigo-50 text-indigo-700 border-indigo-200 hover:bg-indigo-100' 
                : 'bg-indigo-500/10 text-indigo-400 border-indigo-500/20 hover:text-indigo-300'
            }`}
          >
            <Sparkles className="w-3 h-3" />
            AI Trace
          </button>
        </div>
      </div>

      {/* AI Telemetry Drawer (collapsible) */}
      {showAiTrace && (
        <div className={`p-4 rounded-xl border shadow-xl relative animate-in fade-in ${
          isLight ? 'bg-white border-indigo-200' : 'bg-slate-950 border-indigo-500/30'
        }`}>
          <div className={`flex items-center justify-between mb-3 border-b pb-2 ${
            isLight ? 'border-slate-100' : 'border-slate-800/80'
          }`}>
            <div className="flex items-center gap-2">
              <Sparkles className="w-4 h-4 text-indigo-600" />
              <span className={`text-xs font-bold ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                Live Agentic StateGraph Execution Telemetry
              </span>
            </div>
            <button
              onClick={() => setShowAiTrace(false)}
              className={`text-xs font-medium cursor-pointer ${
                isLight ? 'text-slate-500 hover:text-slate-800' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              Close Panel
            </button>
          </div>
          <AiExecutionTrace />
        </div>
      )}

      {/* Action & Filter Bar with Dual View Toggle */}
      <div className={`rounded-xl border p-3 flex flex-col md:flex-row items-center justify-between gap-3 shadow-xs ${
        isLight ? 'bg-white border-slate-200/90' : 'bg-slate-900/90 border-slate-800/80'
      }`}>
        {/* Search Input */}
        <div className="relative w-full md:w-80">
          <Search className="w-3.5 h-3.5 text-slate-400 absolute left-3 top-1/2 -translate-y-1/2" />
          <input
            type="text"
            placeholder="Search listings, road, district..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            className={`w-full border rounded-lg pl-8 pr-3 py-1.5 text-xs focus:outline-none focus:border-blue-600 transition-colors ${
              isLight 
                ? 'bg-slate-50 border-slate-200 text-slate-900 placeholder-slate-400' 
                : 'bg-slate-950 border-slate-800 text-slate-100 placeholder-slate-500'
            }`}
          />
        </div>

        {/* Status Filters & View Toggle */}
        <div className="flex items-center gap-2 w-full md:w-auto justify-between md:justify-end">
          {/* Status Filter Tabs */}
          <div className={`flex p-1 rounded-lg border ${
            isLight ? 'bg-slate-100 border-slate-200' : 'bg-slate-950 border-slate-800'
          }`}>
            {[
              { key: 'ALL', label: 'All' },
              { key: 'AVAILABLE', label: 'Available' },
              { key: 'OCCUPIED', label: 'Occupied' },
              { key: 'MAINTENANCE', label: 'Maintenance' }
            ].map(({ key, label }) => (
              <button
                key={key}
                onClick={() => setStatusFilter(key)}
                className={`px-2.5 py-1 rounded-md text-[11px] font-semibold transition-all cursor-pointer ${
                  statusFilter === key
                    ? 'bg-blue-600 text-white shadow-xs'
                    : isLight ? 'text-slate-600 hover:text-slate-900' : 'text-slate-400 hover:text-slate-200'
                }`}
              >
                {label}
              </button>
            ))}
          </div>

          {/* Dual View Toggle: Grid vs Table */}
          <div className={`flex p-1 rounded-lg border ${
            isLight ? 'bg-slate-100 border-slate-200' : 'bg-slate-950 border-slate-800'
          }`}>
            <button
              onClick={() => setViewMode('grid')}
              className={`p-1.5 rounded-md transition-all cursor-pointer ${
                viewMode === 'grid' 
                  ? (isLight ? 'bg-white text-blue-600 shadow-xs' : 'bg-slate-800 text-blue-400') 
                  : 'text-slate-400 hover:text-slate-600'
              }`}
              title="Visual Grid Cards"
            >
              <LayoutGrid className="w-3.5 h-3.5" />
            </button>
            <button
              onClick={() => setViewMode('table')}
              className={`p-1.5 rounded-md transition-all cursor-pointer ${
                viewMode === 'table' 
                  ? (isLight ? 'bg-white text-blue-600 shadow-xs' : 'bg-slate-800 text-blue-400') 
                  : 'text-slate-400 hover:text-slate-600'
              }`}
              title="Compact Enterprise Table"
            >
              <Table className="w-3.5 h-3.5" />
            </button>
          </div>

          {/* Refresh Button */}
          <button
            onClick={fetchProperties}
            className={`p-1.5 rounded-lg border transition-colors cursor-pointer ${
              isLight 
                ? 'bg-slate-50 border-slate-200 hover:bg-slate-100 text-slate-600' 
                : 'bg-slate-950 border-slate-800 hover:bg-slate-800 text-slate-400 hover:text-slate-200'
            }`}
            title="Refresh Listings"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin text-blue-600' : ''}`} />
          </button>
        </div>
      </div>

      {/* View Mode 1: Visual Grid Cards */}
      {viewMode === 'grid' ? (
        filteredProperties.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredProperties.map((property) => (
              <PropertyCard
                key={property.id}
                property={property}
                onDraftLease={handleDraftLease}
                onTerminateLease={handleTerminateLease}
              />
            ))}
          </div>
        ) : (
          <div className={`rounded-xl border p-12 text-center ${
            isLight ? 'bg-white border-slate-200' : 'bg-slate-900/50 border-slate-800'
          }`}>
            <Building2 className={`w-8 h-8 mx-auto mb-2 ${isLight ? 'text-slate-300' : 'text-slate-600'}`} />
            <h4 className={`text-xs font-semibold ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
              No properties match your filter
            </h4>
            <p className={`text-[11px] mt-0.5 mb-3 ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
              Try adjusting your search criteria or resetting filters.
            </p>
            <button
              onClick={() => { setSearchTerm(''); setStatusFilter('ALL'); }}
              className="px-3 py-1.5 rounded-lg bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold transition-colors cursor-pointer shadow-xs"
            >
              Reset Filters
            </button>
          </div>
        )
      ) : (
        /* View Mode 2: Compact Enterprise Table View */
        <div className={`rounded-2xl border overflow-hidden shadow-xs ${
          isLight ? 'bg-white border-slate-200' : 'bg-slate-900/90 border-slate-800/80 shadow-lg'
        }`}>
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse">
              <thead>
                <tr className={`border-b text-[10px] font-semibold uppercase tracking-wider ${
                  isLight 
                    ? 'border-slate-200 bg-slate-50 text-slate-500' 
                    : 'border-slate-800/80 bg-slate-950/70 text-slate-400'
                }`}>
                  <th className="px-4 py-3">Property Unit</th>
                  <th className="px-4 py-3">Location</th>
                  <th className="px-4 py-3">Status</th>
                  <th className="px-4 py-3 text-right">Monthly Rent</th>
                  <th className="px-4 py-3 text-right">Deposit</th>
                  <th className="px-4 py-3">Term Status</th>
                  <th className="px-4 py-3 text-right">Action</th>
                </tr>
              </thead>
              <tbody className={`divide-y text-xs ${
                isLight ? 'divide-slate-100' : 'divide-slate-800/60'
              }`}>
                {filteredProperties.map((p) => {
                  const isAvail = p.status === 0 || p.status === 'Available';
                  const isOcc = p.status === 1 || p.status === 'Occupied';
                  return (
                    <tr key={p.id} className={`transition-colors ${
                      isLight ? 'hover:bg-slate-50/80' : 'hover:bg-slate-800/40'
                    }`}>
                      <td className={`px-4 py-3 font-semibold flex items-center gap-2 ${
                        isLight ? 'text-slate-900' : 'text-slate-100'
                      }`}>
                        <Building2 className="w-3.5 h-3.5 text-blue-600 flex-shrink-0" />
                        <span className="truncate max-w-[180px]">{p.title}</span>
                      </td>
                      <td className={`px-4 py-3 max-w-[200px] truncate text-[11px] ${
                        isLight ? 'text-slate-500' : 'text-slate-400'
                      }`}>
                        {p.address}
                      </td>
                      <td className="px-4 py-3">
                        {isAvail ? (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                            isLight 
                              ? 'bg-emerald-50 text-emerald-700 border-emerald-200' 
                              : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
                          }`}>
                            Available
                          </span>
                        ) : isOcc ? (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                            isLight 
                              ? 'bg-blue-50 text-blue-700 border-blue-200' 
                              : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
                          }`}>
                            Occupied
                          </span>
                        ) : (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                            isLight 
                              ? 'bg-amber-50 text-amber-700 border-amber-200' 
                              : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
                          }`}>
                            Maintenance
                          </span>
                        )}
                      </td>
                      <td className="px-4 py-3 text-right font-mono font-bold text-emerald-600">
                        LKR {Number(p.monthlyRent).toLocaleString()}
                      </td>
                      <td className={`px-4 py-3 text-right font-mono text-[11px] ${
                        isLight ? 'text-slate-600' : 'text-slate-300'
                      }`}>
                        LKR {Number(p.securityDeposit).toLocaleString()}
                      </td>
                      <td className={`px-4 py-3 text-[11px] font-mono ${
                        isLight ? 'text-slate-500' : 'text-slate-400'
                      }`}>
                        {isOcc ? 'Active (118d)' : isAvail ? 'Immediate' : 'Under Review'}
                      </td>
                      <td className="px-4 py-3 text-right">
                        {isAvail ? (
                          <button
                            onClick={() => handleDraftLease(p)}
                            className="px-2.5 py-1 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-semibold text-[11px] inline-flex items-center gap-1 transition-colors cursor-pointer shadow-xs"
                          >
                            <FileText className="w-3 h-3" /> Draft
                          </button>
                        ) : isOcc ? (
                          <button
                            onClick={() => handleTerminateLease(p)}
                            className={`px-2.5 py-1 rounded-lg font-semibold text-[11px] inline-flex items-center gap-1 transition-colors cursor-pointer border ${
                              isLight 
                                ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border-rose-200' 
                                : 'bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border-rose-500/30'
                            }`}
                          >
                            <XCircle className="w-3 h-3" /> Terminate
                          </button>
                        ) : (
                          <span className={`text-[11px] ${isLight ? 'text-slate-400' : 'text-slate-600'}`}>—</span>
                        )}
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {/* Modal for Drafting or Terminating */}
      <LeaseModal
        isOpen={modalMode !== null}
        onClose={() => setModalMode(null)}
        mode={modalMode}
        property={selectedProperty}
        onSubmitDraft={submitDraft}
        onSubmitTerminate={submitTerminate}
      />
    </div>
  );
};
