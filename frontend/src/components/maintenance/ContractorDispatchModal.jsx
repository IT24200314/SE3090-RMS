import React, { useState } from 'react';
import { 
  X, 
  Wrench, 
  UserCheck, 
  Star, 
  Phone, 
  ShieldCheck, 
  DollarSign, 
  Sliders, 
  Award,
  Check
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

const LICENSED_CONTRACTORS = [
  { 
    id: '9f8e7d6c-5b4a-3f2e-1d0c-9b8a7f6e5d4c', 
    name: 'Lanka QuickPlumb Services (Pvt) Ltd', 
    trade: 'Plumbing Services', 
    rating: 4.9,
    reviews: 142,
    phone: '+94 11 254 8899',
    badge: 'Preferred Partner'
  },
  { 
    id: '8e7d6c5b-4a3f-2e1d-0c9b-8a7f6e5d4c3b', 
    name: 'ElectroMaster Engineering Works', 
    trade: 'Electrical Engineering', 
    rating: 4.8,
    reviews: 98,
    phone: '+94 11 432 1100',
    badge: 'Certified Master'
  },
  { 
    id: '7d6c5b4a-3f2e-1d0c-9b8a-7f6e5d4c3b2a', 
    name: 'Metro Build & Masonry Specialists', 
    trade: 'Structural / Masonry', 
    rating: 4.7,
    reviews: 64,
    phone: '+94 11 776 5432',
    badge: 'Bonded & Insured'
  },
  { 
    id: '6c5b4a3f-2e1d-0c9b-8a7f-6e5d4c3b2a10', 
    name: 'All-Fix Handyman Crew', 
    trade: 'General Maintenance', 
    rating: 4.6,
    reviews: 87,
    phone: '+94 77 123 4567',
    badge: 'Rapid Response'
  }
];

const ContractorDispatchModalContent = ({ onClose, ticket, onAssign }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [selectedContractorId, setSelectedContractorId] = useState(LICENSED_CONTRACTORS[0].id);
  const [budget, setBudget] = useState(ticket.estimatedCost || 25000);
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    if (e) e.preventDefault();
    setLoading(true);
    try {
      await onAssign(ticket.id, {
        contractorId: selectedContractorId,
        approvedBudget: Number(budget)
      });
      onClose();
    } catch (err) {
      console.error('Failed to assign contractor', err);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-md p-4 animate-in fade-in duration-200">
      <div className={`rounded-2xl w-full max-w-lg overflow-hidden shadow-2xl flex flex-col max-h-[90vh] border ${
        isLight ? 'bg-white border-slate-200' : 'bg-slate-950 border-slate-800'
      }`}>
        {/* Modal Header */}
        <div className={`px-6 py-4 border-b flex items-center justify-between ${
          isLight ? 'bg-slate-50/80 border-slate-200' : 'bg-slate-900/80 border-slate-800/80'
        }`}>
          <div className="flex items-center gap-3">
            <div className={`w-8 h-8 rounded-xl border flex items-center justify-center ${
              isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
            }`}>
              <Wrench className="w-4 h-4" />
            </div>
            <div>
              <h3 className={`text-sm font-bold ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                AppFolio Contractor Dispatch
              </h3>
              <p className={`text-[11px] font-mono ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Order #{ticket.id.slice(0, 8)} • Priority: {ticket.priority}
              </p>
            </div>
          </div>
          <button 
            onClick={onClose} 
            className={`p-1.5 rounded-lg transition-colors cursor-pointer ${
              isLight ? 'text-slate-400 hover:text-slate-700 hover:bg-slate-200' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-800'
            }`}
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Modal Body */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4 overflow-y-auto">
          {/* Issue Summary Pill */}
          <div className={`p-3 rounded-xl border text-xs ${
            isLight ? 'bg-slate-50 border-slate-200 text-slate-700' : 'bg-slate-900 border-slate-800 text-slate-300'
          }`}>
            <span className={`text-[10px] uppercase tracking-wider font-semibold block mb-0.5 ${
              isLight ? 'text-slate-400' : 'text-slate-500'
            }`}>
              Target Repair Scope
            </span>
            <p className={`font-medium ${isLight ? 'text-slate-800' : 'text-slate-200'}`}>{ticket.issueDescription}</p>
          </div>

          {/* Contractor Trade Selector Cards */}
          <div>
            <label className={`block text-xs font-bold uppercase tracking-wider mb-2 ${
              isLight ? 'text-slate-700' : 'text-slate-200'
            }`}>
              Select Licensed Service Partner
            </label>
            <div className="space-y-2">
              {LICENSED_CONTRACTORS.map((c) => {
                const isSelected = selectedContractorId === c.id;
                return (
                  <div
                    key={c.id}
                    onClick={() => setSelectedContractorId(c.id)}
                    className={`p-3.5 rounded-xl border text-xs cursor-pointer transition-all ${
                      isSelected
                        ? isLight
                          ? 'bg-blue-50/90 border-blue-400 ring-2 ring-blue-100 shadow-xs'
                          : 'bg-blue-600/15 border-blue-500/50 shadow-md shadow-blue-500/10'
                        : isLight
                          ? 'bg-white border-slate-200 hover:border-slate-300 shadow-xs'
                          : 'bg-slate-900/60 border-slate-800 hover:border-slate-700'
                    }`}
                  >
                    <div className="flex items-start justify-between">
                      <div>
                        <div className="flex items-center gap-2">
                          <span className={`font-bold text-xs ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                            {c.name}
                          </span>
                          <span className={`text-[9px] px-1.5 py-0.2 rounded border font-medium ${
                            isLight ? 'bg-slate-100 text-blue-700 border-slate-200' : 'bg-slate-800 text-blue-400 border-slate-700'
                          }`}>
                            {c.badge}
                          </span>
                        </div>
                        <span className={`text-[11px] block mt-0.5 ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                          {c.trade}
                        </span>
                      </div>
                      <div className="flex items-center gap-1 text-amber-500 font-bold text-xs">
                        <Star className="w-3.5 h-3.5 fill-amber-400 text-amber-500" />
                        <span>{c.rating}</span>
                        <span className={`text-[10px] font-normal ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
                          ({c.reviews})
                        </span>
                      </div>
                    </div>

                    <div className={`flex items-center justify-between mt-2 pt-2 border-t text-[11px] ${
                      isLight ? 'border-slate-100 text-slate-500' : 'border-slate-800/60 text-slate-400'
                    }`}>
                      <span className="flex items-center gap-1">
                        <Phone className="w-3 h-3 text-slate-400" />
                        {c.phone}
                      </span>
                      {isSelected && (
                        <span className="text-blue-600 font-semibold flex items-center gap-1 text-[10px]">
                          <Check className="w-3 h-3" /> Selected Dispatch
                        </span>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Budget Ceiling Slider & Input */}
          <div className={`p-4 rounded-xl border space-y-2 ${
            isLight ? 'bg-slate-50 border-slate-200' : 'bg-slate-900 border-slate-800'
          }`}>
            <div className="flex items-center justify-between">
              <label className={`text-xs font-semibold flex items-center gap-1.5 ${
                isLight ? 'text-slate-800' : 'text-slate-200'
              }`}>
                <DollarSign className="w-3.5 h-3.5 text-emerald-600" />
                Authorized Budget Ceiling (LKR)
              </label>
              <span className="text-xs font-mono font-bold text-emerald-600">
                LKR {Number(budget).toLocaleString()}
              </span>
            </div>

            <input
              type="range"
              min={10000}
              max={150000}
              step={5000}
              value={budget}
              onChange={(e) => setBudget(e.target.value)}
              className="w-full accent-blue-600 rounded-lg cursor-pointer h-1.5"
            />

            <div className={`flex items-center justify-between text-[10px] font-mono ${
              isLight ? 'text-slate-400' : 'text-slate-500'
            }`}>
              <span>Min: LKR 10k</span>
              <span>Baseline: LKR 50k</span>
              <span>Max: LKR 150k</span>
            </div>
          </div>

          {/* Footer Actions */}
          <div className={`pt-2 flex items-center justify-end gap-2.5 border-t ${
            isLight ? 'border-slate-100' : 'border-slate-800'
          }`}>
            <button
              type="button"
              onClick={onClose}
              className={`px-3.5 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                isLight ? 'text-slate-600 hover:bg-slate-100' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900'
              }`}
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-4 py-2 rounded-xl bg-amber-600 hover:bg-amber-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all disabled:opacity-50 cursor-pointer"
            >
              <UserCheck className="w-3.5 h-3.5" />
              {loading ? 'Dispatching...' : 'Dispatch Contractor to Property'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export const ContractorDispatchModal = (props) => {
  if (!props.isOpen || !props.ticket) return null;
  return <ContractorDispatchModalContent {...props} />;
};
