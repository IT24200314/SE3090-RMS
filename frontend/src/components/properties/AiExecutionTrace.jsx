import React, { useState } from 'react';
import { 
  Sparkles, 
  CheckCircle2, 
  ShieldAlert, 
  Play, 
  RefreshCw,
  Terminal,
  Cpu
} from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

const INITIAL_TRACES = [
  {
    id: 'TRC-1049',
    timestamp: 'Just now',
    agent: 'Upamada (Planning Agent)',
    action: 'Generate Lease Clauses & Schedule Inspection',
    state: 'SUCCESS',
    duration: '320ms',
    details: 'Verified Colombo rental index, applied standard 30-day termination policy, generated contract clauses.'
  },
  {
    id: 'TRC-1048',
    timestamp: '2 mins ago',
    agent: 'Nethmi (Risk Scoring Agent)',
    action: 'Evaluate Rent-to-Income & ID Validation',
    state: 'SUCCESS',
    duration: '540ms',
    details: 'Calculated 20% rent ratio, generated 92/100 risk score. Identity card verified.'
  },
  {
    id: 'TRC-1047',
    timestamp: '5 mins ago',
    agent: 'Hashini (Triage & Validation Agent)',
    action: 'Maintenance Cost Estimation & Policy Audit',
    state: 'HITL_PAUSE',
    duration: '410ms',
    details: 'Burst pipe repair estimated at LKR 65,000. Exceeds LKR 50,000 threshold. Paused at PendingManagerApproval node.'
  }
];

export const AiExecutionTrace = () => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [traces, setTraces] = useState(INITIAL_TRACES);
  const [executing, setExecuting] = useState(false);
  const [selectedTrace, setSelectedTrace] = useState(INITIAL_TRACES[0]);

  const triggerLiveAgentRun = () => {
    setExecuting(true);
    setTimeout(() => {
      const newTrace = {
        id: `TRC-${Math.floor(1050 + Math.random() * 900)}`,
        timestamp: 'Just now',
        agent: 'Upamada (Planning Agent)',
        action: 'Dynamic Lease Renewal & Market Rate Calibration',
        state: 'SUCCESS',
        duration: `${Math.floor(280 + Math.random() * 200)}ms`,
        details: 'Evaluated property occupancy rates in Colombo 03, calibrated recommended agreed rent at LKR 225,000.'
      };
      setTraces([newTrace, ...traces]);
      setSelectedTrace(newTrace);
      setExecuting(false);
    }, 1000);
  };

  return (
    <div className="space-y-4">
      {/* Top Controller Banner */}
      <div className={`rounded-2xl border p-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 shadow-xs ${
        isLight ? 'bg-white border-slate-200' : 'bg-zinc-900/60 border-white/[0.08]'
      }`}>
        <div className="flex items-center gap-3">
          <div className={`w-8 h-8 rounded-xl flex items-center justify-center border ${
            isLight ? 'bg-violet-50 text-violet-700 border-violet-200' : 'bg-violet-500/10 border-violet-500/20 text-violet-400'
          }`}>
            <Sparkles className="w-4 h-4 animate-pulse" />
          </div>
          <div>
            <h3 className={`text-xs font-bold flex items-center gap-1.5 ${
              isLight ? 'text-slate-900' : 'text-zinc-100'
            }`}>
              LangGraph StateGraph Telemetry
              <span className={`px-2 py-0.2 rounded-full text-[10px] font-semibold border ${
                isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
              }`}>
                ACTIVE
              </span>
            </h3>
            <p className={`text-[11px] mt-0.5 ${isLight ? 'text-slate-500' : 'text-zinc-500'}`}>
              Multi-agent state checkpoints & Human-in-the-Loop policy nodes.
            </p>
          </div>
        </div>

        <button
          onClick={triggerLiveAgentRun}
          disabled={executing}
          className="px-4 py-2 rounded-xl bg-violet-600 hover:bg-violet-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all cursor-pointer disabled:opacity-50"
        >
          {executing ? (
            <>
              <RefreshCw className="w-3.5 h-3.5 animate-spin" />
              <span>Orchestrating...</span>
            </>
          ) : (
            <>
              <Play className="w-3.5 h-3.5" />
              <span>Simulate Agent Run</span>
            </>
          )}
        </button>
      </div>

      {/* Grid of Traces and Inspector */}
      <div className="grid grid-cols-1 lg:grid-cols-12 gap-4">
        {/* Trace List */}
        <div className="lg:col-span-7 space-y-2">
          <div className={`px-1 text-[11px] font-bold uppercase tracking-wider ${
            isLight ? 'text-slate-400' : 'text-zinc-500'
          }`}>
            Execution Log & State Checkpoints
          </div>
          {traces.map((trace) => {
            const isSelected = selectedTrace?.id === trace.id;
            const isHitl = trace.state === 'HITL_PAUSE';
            return (
              <div
                key={trace.id}
                onClick={() => setSelectedTrace(trace)}
                className={`p-3.5 rounded-xl border transition-all cursor-pointer ${
                  isSelected
                    ? isLight
                      ? 'bg-white border-violet-400 ring-2 ring-violet-100 shadow-sm'
                      : 'bg-zinc-900 text-zinc-100 border-violet-500/40 shadow-[inset_0_1px_0_0_rgba(255,255,255,0.05)]'
                    : isLight
                      ? 'bg-white/80 border-slate-200 hover:border-slate-300 shadow-xs'
                      : 'bg-zinc-900/40 border-white/[0.06] hover:border-zinc-700'
                }`}
              >
                <div className="flex items-center justify-between gap-2 mb-1.5">
                  <div className="flex items-center gap-2">
                    <Cpu className={`w-3.5 h-3.5 ${isLight ? 'text-violet-600' : 'text-violet-400'}`} />
                    <span className={`text-xs font-semibold ${isLight ? 'text-slate-800' : 'text-zinc-200'}`}>
                      {trace.agent}
                    </span>
                  </div>
                  <div className="flex items-center gap-1.5">
                    <span className={`text-[10px] font-mono ${isLight ? 'text-slate-400' : 'text-zinc-500'}`}>
                      {trace.duration}
                    </span>
                    {isHitl ? (
                      <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border flex items-center gap-1 ${
                        isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
                      }`}>
                        <ShieldAlert className="w-2.5 h-2.5" /> HITL PAUSED
                      </span>
                    ) : (
                      <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border flex items-center gap-1 ${
                        isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
                      }`}>
                        <CheckCircle2 className="w-2.5 h-2.5" /> COMPLETED
                      </span>
                    )}
                  </div>
                </div>

                <p className={`text-xs font-semibold mb-0.5 ${isLight ? 'text-slate-900' : 'text-zinc-100'}`}>
                  {trace.action}
                </p>
                <p className={`text-[11px] truncate ${isLight ? 'text-slate-500' : 'text-zinc-500'}`}>
                  {trace.details}
                </p>
              </div>
            );
          })}
        </div>

        {/* Trace Inspector */}
        <div className="lg:col-span-5">
          <div className={`rounded-2xl border p-4 sticky top-20 space-y-3 shadow-xs ${
            isLight ? 'bg-white border-slate-200' : 'bg-zinc-900/60 border-white/[0.08]'
          }`}>
            <div className={`flex items-center gap-2 text-xs font-bold border-b pb-2.5 ${
              isLight ? 'text-slate-900 border-slate-100' : 'text-zinc-200 border-white/[0.06]'
            }`}>
              <Terminal className="w-3.5 h-3.5 text-indigo-600" />
              <span>Node Inspector: {selectedTrace?.id}</span>
            </div>

            {selectedTrace && (
              <div className="space-y-2.5 text-xs">
                <div>
                  <span className={`block text-[10px] font-semibold uppercase tracking-wider ${
                    isLight ? 'text-slate-400' : 'text-zinc-500'
                  }`}>
                    Agent Node
                  </span>
                  <span className="font-semibold text-indigo-600 text-xs">{selectedTrace.agent}</span>
                </div>
                <div>
                  <span className={`block text-[10px] font-semibold uppercase tracking-wider ${
                    isLight ? 'text-slate-400' : 'text-zinc-500'
                  }`}>
                    Objective Target
                  </span>
                  <span className={`font-semibold text-xs ${isLight ? 'text-slate-800' : 'text-zinc-200'}`}>
                    {selectedTrace.action}
                  </span>
                </div>
                <div>
                  <span className={`block text-[10px] font-semibold uppercase tracking-wider mb-1 ${
                    isLight ? 'text-slate-400' : 'text-zinc-500'
                  }`}>
                    State Payload
                  </span>
                  <p className={`p-3 rounded-xl border font-mono text-[11px] leading-relaxed ${
                    isLight ? 'bg-slate-50 border-slate-200 text-slate-700' : 'bg-zinc-950 border-white/[0.06] text-zinc-300'
                  }`}>
                    {selectedTrace.details}
                  </p>
                </div>
                <div className="pt-1">
                  <span className={`block text-[10px] font-semibold uppercase tracking-wider mb-0.5 ${
                    isLight ? 'text-slate-400' : 'text-zinc-500'
                  }`}>
                    Policy Status
                  </span>
                  <div className="flex items-center gap-1.5 text-emerald-600 text-[11px] font-bold">
                    <CheckCircle2 className="w-3.5 h-3.5" />
                    <span>Deterministic rule bounds validated</span>
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
