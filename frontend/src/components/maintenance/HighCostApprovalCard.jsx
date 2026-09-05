import React from 'react';
import { ShieldAlert, CheckCircle2, XCircle, AlertTriangle, ArrowRight } from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

export const HighCostApprovalCard = ({ ticket, onApprove, onReject }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  return (
    <div 
      data-testid="hitl-approval-card" 
      className={`p-4 rounded-2xl border space-y-3 transition-all ${
        isLight
          ? 'bg-gradient-to-r from-amber-50/90 via-white to-white border-amber-300 shadow-[0_2px_12px_rgba(245,158,11,0.12)]'
          : 'bg-gradient-to-r from-amber-950/40 via-slate-900 to-slate-900 border-amber-500/30 shadow-lg shadow-amber-950/20'
      }`}
    >
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-start gap-3">
          <div className={`w-8 h-8 rounded-xl border flex items-center justify-center flex-shrink-0 mt-0.5 ${
            isLight ? 'bg-amber-100 text-amber-700 border-amber-300' : 'bg-amber-500/15 text-amber-400 border-amber-500/30'
          }`}>
            <ShieldAlert className="w-4 h-4 animate-pulse" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h4 className={`text-xs font-bold ${isLight ? 'text-amber-950' : 'text-amber-300'}`}>
                HITL Financial Authorization Required
              </h4>
              <span className={`text-[9px] font-bold px-2 py-0.2 rounded-full border uppercase ${
                isLight ? 'bg-amber-100 text-amber-800 border-amber-300' : 'bg-amber-500/20 text-amber-300 border-amber-500/30'
              }`}>
                Threshold Alert
              </span>
            </div>
            <p className={`text-[11px] mt-1 leading-relaxed ${isLight ? 'text-slate-600' : 'text-slate-300'}`}>
              Ticket requires Human-in-the-Loop review because estimated expenditure exceeds the designated property manager ceiling (<span className={`font-semibold ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>LKR 50,000</span>).
            </p>
          </div>
        </div>

        <div className="text-right flex-shrink-0">
          <span className={`text-[10px] font-semibold block uppercase tracking-wider ${
            isLight ? 'text-slate-500' : 'text-slate-400'
          }`}>
            Estimated Cost
          </span>
          <span className={`text-sm font-bold font-mono ${isLight ? 'text-amber-700' : 'text-amber-400'}`}>
            LKR {Number(ticket.estimatedCost).toLocaleString()}
          </span>
        </div>
      </div>

      {/* AI Triage details container */}
      <div className={`p-3 rounded-xl border text-xs space-y-1 ${
        isLight ? 'bg-slate-50/90 border-slate-200' : 'bg-slate-950/80 border-slate-800'
      }`}>
        <div className={`flex items-center justify-between text-[10px] font-semibold uppercase tracking-wider ${
          isLight ? 'text-slate-500' : 'text-slate-400'
        }`}>
          <span>AI Triage & Classification Assessment</span>
          <span className={`font-mono ${isLight ? 'text-amber-700' : 'text-amber-400'}`}>
            Priority: {ticket.priority}
          </span>
        </div>
        <p className={`text-[11px] leading-relaxed font-sans ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
          {ticket.aiTriageSummary}
        </p>
      </div>

      <div className="flex items-center justify-between pt-1">
        <span className={`text-[10px] font-mono ${isLight ? 'text-slate-400' : 'text-slate-400'}`}>
          Ref: {ticket.id}
        </span>
        <div className="flex items-center gap-2">
          <button
            onClick={() => onReject(ticket.id)}
            className={`px-3 py-1.5 rounded-xl text-xs font-semibold flex items-center gap-1.5 active:scale-[0.98] transition-colors cursor-pointer border ${
              isLight 
                ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border-rose-200' 
                : 'bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border-rose-500/30'
            }`}
          >
            <XCircle className="w-3.5 h-3.5" />
            Decline Authorization
          </button>
          <button
            onClick={() => onApprove(ticket.id)}
            className="px-3.5 py-1.5 rounded-xl bg-amber-600 hover:bg-amber-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-xs active:scale-[0.98] transition-all cursor-pointer"
          >
            <CheckCircle2 className="w-3.5 h-3.5" />
            Authorize LKR {Number(ticket.estimatedCost).toLocaleString()} Repair
          </button>
        </div>
      </div>
    </div>
  );
};
