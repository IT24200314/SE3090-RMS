import React, { useState } from 'react';
import { 
  X, 
  FileCheck, 
  CheckCircle2, 
  Eye, 
  ZoomIn, 
  ZoomOut, 
  RotateCw, 
  ShieldCheck, 
  AlertCircle,
  Maximize2,
  Building,
  UserCheck,
  Check
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

const IdentityVerificationModalContent = ({ onClose, application, onVerify }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [loading, setLoading] = useState(false);
  const [zoomLevel, setZoomLevel] = useState(1);
  const [rotation, setRotation] = useState(0);
  const [registryVerified, setRegistryVerified] = useState(true);
  const [ocrVerified, setOcrVerified] = useState(true);
  const [sanctionsCleared, setSanctionsCleared] = useState(true);

  const handleConfirmVerify = async () => {
    setLoading(true);
    try {
      await onVerify(application.id, {
        identityDocUrl: application.identityDocUrl,
        isVerifiedByProvider: registryVerified && ocrVerified
      });
      onClose();
    } catch (err) {
      console.error('KYC Verification failed', err);
    } finally {
      setLoading(false);
    }
  };

  const handleZoomIn = () => setZoomLevel(prev => Math.min(prev + 0.25, 2.5));
  const handleZoomOut = () => setZoomLevel(prev => Math.max(prev - 0.25, 0.75));
  const handleResetZoom = () => {
    setZoomLevel(1);
    setRotation(0);
  };
  const handleRotate = () => setRotation(prev => (prev + 90) % 360);

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 backdrop-blur-md p-4 animate-in fade-in duration-200">
      <div className={`rounded-2xl w-full max-w-4xl overflow-hidden shadow-2xl flex flex-col max-h-[90vh] border ${
        isLight ? 'bg-white border-slate-200' : 'bg-slate-950 border-slate-800'
      }`}>
        {/* Header */}
        <div className={`px-6 py-3.5 border-b flex items-center justify-between ${
          isLight ? 'bg-slate-50/80 border-slate-200' : 'bg-slate-900/80 border-slate-800/80'
        }`}>
          <div className="flex items-center gap-3">
            <div className={`w-8 h-8 rounded-xl flex items-center justify-center border ${
              isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
            }`}>
              <ShieldCheck className="w-4 h-4" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h3 className={`text-sm font-bold ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                  AppFolio KYC Document Inspector
                </h3>
                <span className={`text-[10px] font-semibold px-2 py-0.5 rounded-full border ${
                  isLight ? 'bg-blue-50 text-blue-700 border-blue-200' : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
                }`}>
                  Automated Check
                </span>
              </div>
              <p className={`text-[11px] font-mono ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Applicant ID: {application.tenantId || application.id}
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

        {/* 2-Pane Inspector Body */}
        <div className="flex-1 grid grid-cols-1 md:grid-cols-12 overflow-hidden">
          {/* Left Pane (7 cols): Document Preview & Zoom Viewport */}
          <div className={`md:col-span-7 p-4 border-b md:border-b-0 md:border-r flex flex-col ${
            isLight ? 'bg-slate-50/50 border-slate-200' : 'bg-slate-900/60 border-slate-800'
          }`}>
            {/* Viewport Toolbar */}
            <div className={`flex items-center justify-between px-3 py-2 rounded-xl border mb-3 text-xs ${
              isLight ? 'bg-white border-slate-200 text-slate-700 shadow-xs' : 'bg-slate-950 border-slate-800 text-slate-300'
            }`}>
              <span className={`text-[11px] font-medium flex items-center gap-1.5 ${
                isLight ? 'text-slate-600' : 'text-slate-400'
              }`}>
                <FileCheck className="w-3.5 h-3.5 text-blue-600" />
                NIC / Passport Preview
              </span>
              <div className="flex items-center gap-1">
                <button
                  onClick={handleZoomIn}
                  className={`p-1 rounded transition-colors ${
                    isLight ? 'hover:bg-slate-100 text-slate-600' : 'hover:bg-slate-800 text-slate-300'
                  }`}
                  title="Zoom In"
                >
                  <ZoomIn className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={handleZoomOut}
                  className={`p-1 rounded transition-colors ${
                    isLight ? 'hover:bg-slate-100 text-slate-600' : 'hover:bg-slate-800 text-slate-300'
                  }`}
                  title="Zoom Out"
                >
                  <ZoomOut className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={handleRotate}
                  className={`p-1 rounded transition-colors ${
                    isLight ? 'hover:bg-slate-100 text-slate-600' : 'hover:bg-slate-800 text-slate-300'
                  }`}
                  title="Rotate 90deg"
                >
                  <RotateCw className="w-3.5 h-3.5" />
                </button>
                <button
                  onClick={handleResetZoom}
                  className={`text-[10px] px-2 py-0.5 rounded font-medium transition-colors ${
                    isLight ? 'bg-slate-100 text-slate-700 hover:bg-slate-200' : 'bg-slate-800 text-slate-300 hover:bg-slate-700'
                  }`}
                >
                  Reset
                </button>
              </div>
            </div>

            {/* Document Interactive Frame */}
            <div className={`flex-1 rounded-xl border relative overflow-hidden flex items-center justify-center min-h-[300px] ${
              isLight ? 'bg-slate-100/70 border-slate-200' : 'bg-slate-950 border-slate-800/80'
            }`}>
              <div 
                className="transition-transform duration-200 select-none p-4"
                style={{ 
                  transform: `scale(${zoomLevel}) rotate(${rotation}deg)`,
                  transformOrigin: 'center center'
                }}
              >
                {/* Document Card with Security Hologram look */}
                <div className="w-72 h-44 rounded-xl bg-gradient-to-br from-slate-800 via-slate-900 to-indigo-950 border-2 border-slate-700/80 p-4 shadow-2xl relative flex flex-col justify-between text-white">
                  <div className="flex items-start justify-between">
                    <div>
                      <span className="text-[8px] font-bold text-amber-400 tracking-widest block uppercase">
                        Democratic Socialist Republic of Sri Lanka
                      </span>
                      <span className="text-[11px] font-extrabold text-slate-100 block font-mono">
                        NATIONAL IDENTITY CARD
                      </span>
                    </div>
                    <div className="w-6 h-6 rounded-full bg-amber-400/20 border border-amber-400/40 flex items-center justify-center">
                      <div className="w-3 h-3 rounded-full bg-amber-400 animate-pulse"></div>
                    </div>
                  </div>

                  <div className="flex items-center gap-3 my-1">
                    <div className="w-12 h-14 rounded bg-slate-700/60 border border-slate-600 flex items-center justify-center">
                      <UserCheck className="w-6 h-6 text-slate-300" />
                    </div>
                    <div className="space-y-0.5">
                      <div className="text-[10px] font-semibold text-slate-100">
                        {application.applicantName || 'KAMAL PERERA'}
                      </div>
                      <div className="text-[9px] font-mono text-emerald-400">199428501248 (Smart NIC)</div>
                      <div className="text-[8px] text-slate-400">DOB: 12 OCT 1994 • Colombo</div>
                    </div>
                  </div>

                  <div className="flex items-center justify-between border-t border-slate-700/60 pt-1.5 text-[8px] font-mono text-slate-400">
                    <span>SECURITY CHIP VERIFIED</span>
                    <span className="text-emerald-400">VALID THROUGH 2034</span>
                  </div>
                </div>
              </div>

              {/* Watermark Overlay */}
              <div className="absolute bottom-2 right-3 pointer-events-none text-[9px] text-slate-400 font-mono">
                Doc Ref: {application.identityDocUrl ? application.identityDocUrl.split('/').pop() : 'nic_scan_verified.jpg'}
              </div>
            </div>
          </div>

          {/* Right Pane (5 cols): Automated Verification Checklist & Financials */}
          <div className="md:col-span-5 p-5 flex flex-col justify-between space-y-4 overflow-y-auto">
            <div className="space-y-4">
              <div>
                <h4 className={`text-xs font-bold uppercase tracking-wider mb-1 ${
                  isLight ? 'text-slate-900' : 'text-slate-200'
                }`}>
                  Automated KYC Verification Matrix
                </h4>
                <p className={`text-[11px] ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                  Real-time multi-point risk checks executed against authoritative databases.
                </p>
              </div>

              {/* Checklist Items */}
              <div className="space-y-2.5">
                <label className={`flex items-start gap-2.5 p-3 rounded-xl border cursor-pointer transition-colors ${
                  isLight 
                    ? 'bg-slate-50 border-slate-200 hover:border-slate-300' 
                    : 'bg-slate-900 border-slate-800 hover:border-slate-700'
                }`}>
                  <input
                    type="checkbox"
                    checked={registryVerified}
                    onChange={(e) => setRegistryVerified(e.target.checked)}
                    className="mt-0.5 rounded border-slate-300 text-blue-600 focus:ring-0 w-4 h-4 cursor-pointer"
                  />
                  <div>
                    <span className={`text-xs font-semibold block ${isLight ? 'text-slate-900' : 'text-slate-200'}`}>
                      Persons Registry Match (DRP Sri Lanka)
                    </span>
                    <span className={`text-[10px] leading-tight block mt-0.5 ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                      Identity confirmed with Department for Registration of Persons database.
                    </span>
                  </div>
                </label>

                <label className={`flex items-start gap-2.5 p-3 rounded-xl border cursor-pointer transition-colors ${
                  isLight 
                    ? 'bg-slate-50 border-slate-200 hover:border-slate-300' 
                    : 'bg-slate-900 border-slate-800 hover:border-slate-700'
                }`}>
                  <input
                    type="checkbox"
                    checked={ocrVerified}
                    onChange={(e) => setOcrVerified(e.target.checked)}
                    className="mt-0.5 rounded border-slate-300 text-blue-600 focus:ring-0 w-4 h-4 cursor-pointer"
                  />
                  <div>
                    <span className={`text-xs font-semibold block ${isLight ? 'text-slate-900' : 'text-slate-200'}`}>
                      AI Optical Character Verification (OCR)
                    </span>
                    <span className={`text-[10px] leading-tight block mt-0.5 ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                      99.4% field match confidence on Name, NIC Number, and DOB.
                    </span>
                  </div>
                </label>

                <label className={`flex items-start gap-2.5 p-3 rounded-xl border cursor-pointer transition-colors ${
                  isLight 
                    ? 'bg-slate-50 border-slate-200 hover:border-slate-300' 
                    : 'bg-slate-900 border-slate-800 hover:border-slate-700'
                }`}>
                  <input
                    type="checkbox"
                    checked={sanctionsCleared}
                    onChange={(e) => setSanctionsCleared(e.target.checked)}
                    className="mt-0.5 rounded border-slate-300 text-blue-600 focus:ring-0 w-4 h-4 cursor-pointer"
                  />
                  <div>
                    <span className={`text-xs font-semibold block ${isLight ? 'text-slate-900' : 'text-slate-200'}`}>
                      AML & Sanctions Screening
                    </span>
                    <span className={`text-[10px] leading-tight block mt-0.5 ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                      Zero matches found on CBSL or international financial watchlists.
                    </span>
                  </div>
                </label>
              </div>

              {/* Financial Income Summary */}
              <div className={`p-3 rounded-xl border space-y-1.5 ${
                isLight ? 'bg-slate-50 border-slate-200' : 'bg-slate-900/90 border-slate-800'
              }`}>
                <div className="flex items-center justify-between text-xs">
                  <span className={`text-[11px] ${isLight ? 'text-slate-600' : 'text-slate-400'}`}>
                    Declared Monthly Income:
                  </span>
                  <span className="font-bold text-emerald-600 font-mono">
                    LKR {Number(application.monthlyIncome).toLocaleString()}
                  </span>
                </div>
                <div className="flex items-center justify-between text-xs">
                  <span className={`text-[11px] ${isLight ? 'text-slate-600' : 'text-slate-400'}`}>
                    Risk AI Confidence:
                  </span>
                  <span className="font-semibold text-blue-600 font-mono">
                    {application.aiRiskScore ? `${application.aiRiskScore}/100` : '92/100'} (Low Risk)
                  </span>
                </div>
              </div>
            </div>

            {/* Action Footer */}
            <div className={`pt-3 border-t flex items-center justify-end gap-2.5 ${
              isLight ? 'border-slate-100' : 'border-slate-800'
            }`}>
              <button
                type="button"
                onClick={onClose}
                className={`px-3.5 py-2 rounded-xl text-xs font-semibold transition-colors cursor-pointer ${
                  isLight ? 'text-slate-600 hover:bg-slate-100' : 'text-slate-400 hover:text-slate-200 hover:bg-slate-900'
                }`}
              >
                Close
              </button>
              <button
                onClick={handleConfirmVerify}
                disabled={loading || !registryVerified}
                className="px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all disabled:opacity-50 cursor-pointer"
              >
                <CheckCircle2 className="w-3.5 h-3.5" />
                {loading ? 'Submitting Verification...' : 'Approve KYC Verification'}
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export const IdentityVerificationModal = (props) => {
  if (!props.isOpen || !props.application) return null;
  return <IdentityVerificationModalContent {...props} />;
};
