import React, { useState } from 'react';
import { 
  X, 
  FileText, 
  AlertTriangle, 
  Sparkles, 
  Calendar, 
  DollarSign, 
  Check, 
  ChevronRight, 
  ChevronLeft,
  ShieldCheck,
  Plus
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

const LeaseModalContent = ({ onClose, mode, property, onSubmitDraft, onSubmitTerminate }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [currentStep, setCurrentStep] = useState(1);
  const [tenantId, setTenantId] = useState('3fa85f64-5717-4562-b3fc-2c963f66afa6');
  const [startDate, setStartDate] = useState(new Date().toISOString().split('T')[0]);
  const [endDate, setEndDate] = useState(
    new Date(new Date().setFullYear(new Date().getFullYear() + 1)).toISOString().split('T')[0]
  );
  const [agreedRent, setAgreedRent] = useState(property.monthlyRent);
  const [securityDeposit, setSecurityDeposit] = useState(property.securityDeposit || property.monthlyRent * 2);
  const [aiClauses, setAiClauses] = useState(
    'Standard residential agreement with 30-day notice clause and utility allocation breakdown as per Colombo Municipal Council guidelines.'
  );
  const [selectedClauses, setSelectedClauses] = useState([
    'CMC Utility Allocation',
    '30-Day Written Notice',
    'Standard Wear & Tear Maintenance'
  ]);
  const [terminationReason, setTerminationReason] = useState('Tenant requested early relocation.');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const clauseTemplates = [
    { title: 'CMC Utility Allocation', text: 'Tenant is liable for individual electricity and water sub-meter invoicing billed on the 1st of each calendar month.' },
    { title: '30-Day Written Notice', text: 'Either party may initiate termination prior to lease maturity by providing 30 days verified written notice.' },
    { title: 'Standard Wear & Tear Maintenance', text: 'Lessor will cover structural repairs, while tenant handles day-to-day consumable maintenance under LKR 10,000.' },
    { title: 'Pet & Alteration Addendum', text: 'Pets permitted subject to refundable pet bond; interior wall alterations require written authorization.' }
  ];

  const toggleClause = (template) => {
    if (selectedClauses.includes(template.title)) {
      setSelectedClauses(selectedClauses.filter(c => c !== template.title));
      setAiClauses(prev => prev.replace(template.text, '').trim());
    } else {
      setSelectedClauses([...selectedClauses, template.title]);
      setAiClauses(prev => (prev ? `${prev} ${template.text}` : template.text));
    }
  };

  const handleDraftSubmit = async (e) => {
    if (e) e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await onSubmitDraft({
        propertyId: property.id,
        tenantId,
        startDate: new Date(startDate).toISOString(),
        endDate: new Date(endDate).toISOString(),
        agreedRent: Number(agreedRent),
        aiDraftedClauses: aiClauses
      });
      onClose();
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Failed to draft lease.');
    } finally {
      setLoading(false);
    }
  };

  const handleTerminateSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      await onSubmitTerminate(property.id, terminationReason);
      onClose();
    } catch (err) {
      setError(err.response?.data?.message || err.message || 'Failed to terminate lease.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div role="dialog" aria-label="Lease Agreement Modal" className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-sm p-4 animate-in fade-in duration-150">
      <div className={`rounded-2xl w-full max-w-lg overflow-hidden shadow-2xl border ${
        isLight ? 'bg-white border-slate-200' : 'bg-slate-950 border-slate-800'
      }`}>
        {/* Header */}
        <div className={`px-6 py-4 border-b flex items-center justify-between ${
          isLight ? 'bg-slate-50/80 border-slate-200' : 'bg-slate-900/60 border-slate-800/80'
        }`}>
          <div className="flex items-center gap-3">
            <div className={`w-8 h-8 rounded-xl flex items-center justify-center border ${
              mode === 'draft' 
                ? (isLight ? 'bg-blue-50 text-blue-700 border-blue-200' : 'bg-blue-600/10 text-blue-400 border-blue-500/20')
                : (isLight ? 'bg-rose-50 text-rose-700 border-rose-200' : 'bg-rose-500/10 text-rose-400 border-rose-500/20')
            }`}>
              {mode === 'draft' ? <FileText className="w-4 h-4" /> : <AlertTriangle className="w-4 h-4" />}
            </div>
            <div>
              <h3 className={`text-sm font-bold ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                {mode === 'draft' ? 'AppFolio Lease Contract Builder' : 'Early Lease Termination Notice'}
              </h3>
              <p className={`text-[11px] truncate max-w-xs ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                {property.title} • {property.address}
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

        {/* Wizard Step Progress (only in draft mode) */}
        {mode === 'draft' && (
          <div className={`px-6 py-3 border-b flex items-center justify-between ${
            isLight ? 'bg-slate-50/50 border-slate-200' : 'bg-slate-950/80 border-slate-800/60'
          }`}>
            <div className="flex items-center gap-2">
              <span className={`w-6 h-6 rounded-full text-xs font-semibold flex items-center justify-center ${
                currentStep === 1 
                  ? 'bg-blue-600 text-white shadow-xs' 
                  : currentStep > 1 ? 'bg-emerald-600 text-white' : (isLight ? 'bg-slate-200 text-slate-500' : 'bg-slate-800 text-slate-400')
              }`}>
                {currentStep > 1 ? <Check className="w-3 h-3" /> : '1'}
              </span>
              <span className={`text-xs ${currentStep === 1 ? 'text-blue-600 font-bold' : isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Term & Dates
              </span>
            </div>
            <div className={`w-8 h-[1px] ${isLight ? 'bg-slate-200' : 'bg-slate-800'}`}></div>
            <div className="flex items-center gap-2">
              <span className={`w-6 h-6 rounded-full text-xs font-semibold flex items-center justify-center ${
                currentStep === 2 
                  ? 'bg-blue-600 text-white shadow-xs' 
                  : currentStep > 2 ? 'bg-emerald-600 text-white' : (isLight ? 'bg-slate-200 text-slate-500' : 'bg-slate-800 text-slate-400')
              }`}>
                {currentStep > 2 ? <Check className="w-3 h-3" /> : '2'}
              </span>
              <span className={`text-xs ${currentStep === 2 ? 'text-blue-600 font-bold' : isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Financials
              </span>
            </div>
            <div className={`w-8 h-[1px] ${isLight ? 'bg-slate-200' : 'bg-slate-800'}`}></div>
            <div className="flex items-center gap-2">
              <span className={`w-6 h-6 rounded-full text-xs font-semibold flex items-center justify-center ${
                currentStep === 3 
                  ? 'bg-blue-600 text-white shadow-xs' 
                  : (isLight ? 'bg-slate-200 text-slate-500' : 'bg-slate-800 text-slate-400')
              }`}>
                3
              </span>
              <span className={`text-xs ${currentStep === 3 ? 'text-blue-600 font-bold' : isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                AI Clauses
              </span>
            </div>
          </div>
        )}

        {/* Error notification */}
        {error && (
          <div className="mx-6 mt-4 p-3 rounded-xl bg-rose-50 border border-rose-200 text-rose-800 text-xs flex items-center gap-2.5">
            <AlertTriangle className="w-4 h-4 text-rose-600 flex-shrink-0" />
            <span>{error}</span>
          </div>
        )}

        {/* Body Content */}
        {mode === 'draft' ? (
          <div className="p-6">
            {/* Step 1: Term & Dates */}
            {currentStep === 1 && (
              <div className="space-y-4 animate-in fade-in">
                <div className={`p-3 rounded-xl border text-xs ${
                  isLight ? 'bg-slate-50 border-slate-200 text-slate-700' : 'bg-slate-900 border-slate-800 text-slate-300'
                }`}>
                  <div className="flex items-center gap-2 text-blue-600 font-semibold mb-1">
                    <Calendar className="w-4 h-4" />
                    <span>Lease Term Specification</span>
                  </div>
                  <p className={`text-[11px] leading-relaxed ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                    Set effective commencement and maturity dates. RMS automatically initializes billing schedules and inspection cycles.
                  </p>
                </div>

                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                      Commencement Date
                    </label>
                    <input
                      type="date"
                      name="startDate"
                      value={startDate}
                      onChange={(e) => setStartDate(e.target.value)}
                      className={`w-full border rounded-lg px-3 py-2 text-xs focus:outline-none focus:border-blue-600 font-mono ${
                        isLight ? 'bg-slate-50 border-slate-200 text-slate-900' : 'bg-slate-900 border-slate-800 text-slate-100'
                      }`}
                      required
                    />
                  </div>
                  <div>
                    <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                      Maturity / End Date
                    </label>
                    <input
                      type="date"
                      name="endDate"
                      value={endDate}
                      onChange={(e) => setEndDate(e.target.value)}
                      className={`w-full border rounded-lg px-3 py-2 text-xs focus:outline-none focus:border-blue-600 font-mono ${
                        isLight ? 'bg-slate-50 border-slate-200 text-slate-900' : 'bg-slate-900 border-slate-800 text-slate-100'
                      }`}
                      required
                    />
                  </div>
                </div>

                <div>
                  <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                    Assigned Tenant Identifier
                  </label>
                  <input
                    type="text"
                    value={tenantId}
                    onChange={(e) => setTenantId(e.target.value)}
                    className={`w-full border rounded-lg px-3 py-2 text-xs focus:outline-none focus:border-blue-600 font-mono ${
                      isLight ? 'bg-slate-50 border-slate-200 text-slate-700' : 'bg-slate-900 border-slate-800 text-slate-400'
                    }`}
                  />
                  <span className={`text-[10px] mt-1 block ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
                    Verified through Component B KYC Screening
                  </span>
                </div>
              </div>
            )}

            {/* Step 2: Financial Terms */}
            {currentStep === 2 && (
              <div className="space-y-4 animate-in fade-in">
                <div className={`p-3 rounded-xl border text-xs ${
                  isLight ? 'bg-slate-50 border-slate-200 text-slate-700' : 'bg-slate-900 border-slate-800 text-slate-300'
                }`}>
                  <div className="flex items-center gap-2 text-emerald-600 font-semibold mb-1">
                    <DollarSign className="w-4 h-4" />
                    <span>Financial Schedule</span>
                  </div>
                  <p className={`text-[11px] leading-relaxed ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                    Set monthly rent and security deposits. Standard security deposit is 2 months rent.
                  </p>
                </div>

                <div>
                  <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                    Agreed Monthly Rent (LKR)
                  </label>
                  <input
                    type="number"
                    name="monthlyRent"
                    value={agreedRent}
                    onChange={(e) => {
                      setAgreedRent(e.target.value);
                      setSecurityDeposit(Number(e.target.value) * 2);
                    }}
                    className={`w-full border rounded-lg px-3 py-2 text-sm text-emerald-600 font-bold focus:outline-none focus:border-blue-600 font-mono ${
                      isLight ? 'bg-slate-50 border-slate-200' : 'bg-slate-900 border-slate-800'
                    }`}
                    required
                  />
                </div>

                <div>
                  <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                    Security Deposit Bond (LKR)
                  </label>
                  <input
                    type="number"
                    value={securityDeposit}
                    onChange={(e) => setSecurityDeposit(e.target.value)}
                    className={`w-full border rounded-lg px-3 py-2 text-xs focus:outline-none focus:border-blue-600 font-mono ${
                      isLight ? 'bg-slate-50 border-slate-200 text-slate-800' : 'bg-slate-900 border-slate-800 text-slate-200'
                    }`}
                  />
                  <span className={`text-[10px] mt-1 block ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
                    Held in designated escrow account
                  </span>
                </div>
              </div>
            )}

            {/* Step 3: Clause Builder */}
            {currentStep === 3 && (
              <div className="space-y-3.5 animate-in fade-in">
                <div className="flex items-center justify-between">
                  <span className={`text-xs font-semibold ${isLight ? 'text-slate-800' : 'text-slate-200'}`}>
                    Select Standard Addenda:
                  </span>
                  <span className="text-[10px] text-indigo-600 flex items-center gap-1 font-semibold">
                    <Sparkles className="w-3 h-3" /> AI Assisted
                  </span>
                </div>

                <div className="grid grid-cols-2 gap-2">
                  {clauseTemplates.map((t) => {
                    const isSelected = selectedClauses.includes(t.title);
                    return (
                      <button
                        type="button"
                        key={t.title}
                        onClick={() => toggleClause(t)}
                        className={`text-left p-2.5 rounded-xl border text-xs transition-all cursor-pointer ${
                          isSelected
                            ? isLight 
                              ? 'bg-blue-50/90 border-blue-300 text-blue-800 shadow-xs' 
                              : 'bg-blue-600/15 border-blue-500/40 text-blue-300'
                            : isLight 
                              ? 'bg-slate-50 border-slate-200 text-slate-600 hover:border-slate-300' 
                              : 'bg-slate-900 border-slate-800 text-slate-400 hover:border-slate-700'
                        }`}
                      >
                        <div className="flex items-center justify-between font-semibold text-[11px] mb-1">
                          <span>{t.title}</span>
                          {isSelected && <Check className="w-3 h-3 text-blue-600 flex-shrink-0" />}
                        </div>
                        <p className={`text-[10px] line-clamp-2 ${isLight ? 'text-slate-400' : 'text-slate-500'}`}>
                          {t.text}
                        </p>
                      </button>
                    );
                  })}
                </div>

                <div>
                  <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                    Full Legal Terms & Clauses
                  </label>
                  <textarea
                    rows="3"
                    name="aiClauses"
                    value={aiClauses}
                    onChange={(e) => setAiClauses(e.target.value)}
                    className={`w-full border rounded-lg p-3 text-xs focus:outline-none focus:border-blue-600 leading-relaxed font-sans ${
                      isLight ? 'bg-slate-50 border-slate-200 text-slate-800' : 'bg-slate-900 border-slate-800 text-slate-200'
                    }`}
                  />
                </div>
              </div>
            )}

            {/* Step Navigation Footer */}
            <div className={`pt-5 border-t flex items-center justify-between mt-4 ${
              isLight ? 'border-slate-100' : 'border-slate-800/80'
            }`}>
              {currentStep > 1 ? (
                <button
                  type="button"
                  onClick={() => setCurrentStep(currentStep - 1)}
                  className={`px-3.5 py-2 rounded-xl text-xs font-semibold border flex items-center gap-1 transition-colors cursor-pointer ${
                    isLight ? 'text-slate-700 hover:bg-slate-100 border-slate-200' : 'text-slate-300 hover:bg-slate-900 border-slate-800'
                  }`}
                >
                  <ChevronLeft className="w-3.5 h-3.5" /> Back
                </button>
              ) : (
                <button
                  type="button"
                  onClick={onClose}
                  className={`px-3.5 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                    isLight ? 'text-slate-600 hover:bg-slate-100' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900'
                  }`}
                >
                  Cancel
                </button>
              )}

              {currentStep < 3 ? (
                <button
                  type="button"
                  onClick={() => setCurrentStep(currentStep + 1)}
                  className="px-4 py-2 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all cursor-pointer"
                >
                  Next Step <ChevronRight className="w-3.5 h-3.5" />
                </button>
              ) : (
                <button
                  type="button"
                  onClick={handleDraftSubmit}
                  disabled={loading}
                  className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all disabled:opacity-50 cursor-pointer"
                >
                  {loading ? 'Drafting Contract...' : 'Generate Legal Contract'}
                </button>
              )}
            </div>
          </div>
        ) : (
          /* Termination Confirmation View */
          <form onSubmit={handleTerminateSubmit} className="p-6 space-y-4">
            <div className="p-4 rounded-xl bg-rose-50 border border-rose-200 text-xs text-rose-800 leading-relaxed space-y-2">
              <div className="flex items-center gap-2 font-bold text-rose-700">
                <AlertTriangle className="w-4 h-4" />
                <span>Execute Early Termination Protocol</span>
              </div>
              <p>
                Terminating will conclude the active contract, compute any early exit penalties according to Sri Lanka tenancy rules, and instantly release <strong>{property.title}</strong> back to <span className="text-emerald-600 font-mono font-bold">Available</span> status.
              </p>
            </div>

            <div>
              <label className={`block text-[11px] font-semibold mb-1 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                Audit Logged Termination Reason
              </label>
              <textarea
                rows="3"
                name="terminationReason"
                value={terminationReason}
                onChange={(e) => setTerminationReason(e.target.value)}
                placeholder="Reason for early exit..."
                className={`w-full border rounded-lg p-3 text-xs focus:outline-none focus:border-rose-500 leading-relaxed ${
                  isLight ? 'bg-slate-50 border-slate-200 text-slate-800' : 'bg-slate-900 border-slate-800 text-slate-200'
                }`}
                required
              />
            </div>

            <div className={`pt-3 border-t flex items-center justify-end gap-2.5 ${
              isLight ? 'border-slate-100' : 'border-slate-800/80'
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
                className="px-4 py-2 rounded-xl bg-rose-600 hover:bg-rose-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all disabled:opacity-50 cursor-pointer"
              >
                {loading ? 'Terminating...' : 'Confirm Termination & Release'}
              </button>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};

export const LeaseModal = (props) => {
  if (!props.isOpen || !props.property) return null;
  return <LeaseModalContent {...props} />;
};
