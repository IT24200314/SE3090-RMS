// =================================================================================================
// File: MaintenanceBoard.jsx
// Module: Component C: Maintenance & Work-Order Operations
// Student Contributor: Hashini Wicramathilake (IT24200314 Group Member)
// Architecture: Frontend Layer - React Component for Work-Order Management & HITL Approvals
// Purpose: Interactive Kanban & table board displaying open maintenance tickets, AI triage summaries,
//          high-cost (>= LKR 50,000) Human-in-the-Loop review banners, and certified contractor dispatch.
// =================================================================================================

import React, { useState, useEffect } from 'react';
import { 
  Wrench, 
  Sparkles, 
  RefreshCw, 
  UserCheck, 
  ShieldAlert, 
  CheckCircle2, 
  AlertTriangle,
  Clock,
  ArrowRight,
  Flame,
  Check
} from 'lucide-react';
import { HighCostApprovalCard } from './HighCostApprovalCard';
import { ContractorDispatchModal } from './ContractorDispatchModal';
import { useToast } from '../common/Toast';
import { useTheme } from '../../context/ThemeContext';
import { maintenanceService } from '../../services/api';

const INITIAL_TICKETS = [
  {
    id: 'm1a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c',
    propertyId: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
    propertyTitle: 'Oceanfront Luxury Suite',
    tenantId: 't1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6',
    issueDescription: 'Major burst pipe in master bathroom causing rapid water leakage on floor.',
    photoUrl: 'https://cdn.rms.local/photos/burst_pipe_01.jpg',
    priority: 3, // Emergency
    status: 2, // PendingManagerApproval ( >= 50K )
    estimatedCost: 65000,
    aiTriageSummary: "Classified under 'Plumbing Services'. Estimated budget: LKR 65,000.00. [FLAGGED] Exceeds LKR 50K ceiling. Paused at PendingManagerApproval node.",
    assignedContractorId: null,
    createdAtUtc: new Date().toISOString()
  },
  {
    id: 'm2b3c4d5-e6f7-8a9b-0c1d-2e3f4a5b6c7d',
    propertyId: 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
    propertyTitle: 'Cinnamon Gardens Townhouse',
    tenantId: 't2b3c4d5-e6f7-a8b9-c0d1-e2f3a4b5c6d7',
    issueDescription: 'Kitchen main power outlet sparking when high load appliance is connected.',
    photoUrl: 'https://cdn.rms.local/photos/outlet_spark_01.jpg',
    priority: 2, // High
    status: 0, // Unassigned / Open
    estimatedCost: 22000,
    aiTriageSummary: "Classified under 'Electrical Engineering'. Estimated budget: LKR 22,000.00. [APPROVED] Within auto-approval bounds.",
    assignedContractorId: null,
    createdAtUtc: new Date().toISOString()
  },
  {
    id: 'm3c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e',
    propertyId: 'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
    propertyTitle: 'Havelock City Studio Apartment',
    tenantId: 't3c4d5e6-f7a8-b9c0-d1e2-f3a4b5c6d7e8',
    issueDescription: 'HVAC Air conditioning condenser leaking refrigerant water onto balcony.',
    photoUrl: 'https://cdn.rms.local/photos/hvac_01.jpg',
    priority: 1, // Medium
    status: 1, // Dispatched
    estimatedCost: 28000,
    aiTriageSummary: "Classified under 'HVAC Services'. Lanka Cool Air dispatched.",
    assignedContractorId: '9f8e7d6c-5b4a-3f2e-1d0c-9b8a7f6e5d4c',
    contractorName: 'Lanka QuickPlumb Services',
    createdAtUtc: new Date().toISOString()
  },
  {
    id: 'm4d5e6f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
    propertyId: 'b4d6e1f7-8a9b-0c1d-2e3f-4a5b6c7d8e9f',
    propertyTitle: 'Rajagiriya Lakeview Condo',
    tenantId: 't4d5e6f7-a8b9-c0d1-e2f3-a4b5c6d7e8f9',
    issueDescription: 'Replaced main front biometric lock sensor battery and recalibrated bolt.',
    photoUrl: 'https://cdn.rms.local/photos/lock_01.jpg',
    priority: 0, // Low
    status: 4, // Resolved
    estimatedCost: 12000,
    aiTriageSummary: "General Handyman resolved. Invoiced settled.",
    assignedContractorId: '6c5b4a3f-2e1d-0c9b-8a7f-6e5d4c3b2a10',
    contractorName: 'All-Fix Handyman Crew',
    createdAtUtc: new Date().toISOString()
  }
];

export const MaintenanceBoard = () => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [tickets, setTickets] = useState(INITIAL_TICKETS);
  const [loading, setLoading] = useState(false);
  const [triagingId, setTriagingId] = useState(null);
  const [selectedTicketForDispatch, setSelectedTicketForDispatch] = useState(null);
  const { addToast } = useToast();

  const fetchTickets = async (isManual = false) => {
    if (isManual) setLoading(true);
    try {
      const res = await maintenanceService.getTickets();
      if (res.data && res.data.length > 0) {
        setTickets(res.data);
      }
    } catch (err) {
      console.warn('Backend unavailable, using local state:', err.message);
    } finally {
      if (isManual) setLoading(false);
    }
  };

  useEffect(() => {
    fetchTickets(false);
  }, []);

  const handleTriage = async (id) => {
    setTriagingId(id);
    try {
      const res = await maintenanceService.triageAndEstimate(id);
      if (res.data) {
        setTickets(prev =>
          prev.map(t => (t.id === id ? {
            ...t,
            priority: res.data.priority,
            status: res.data.status,
            estimatedCost: res.data.estimatedCost,
            aiTriageSummary: res.data.triageSummary
          } : t))
        );
      }
      addToast(`Ticket ${id.slice(0, 8)} triaged successfully!`, 'success');
    } catch (err) {
      // Fallback deterministic simulation
      setTickets(prev =>
        prev.map(t => {
          if (t.id === id) {
            const cost = t.priority >= 2 ? 65000 : 25000;
            const status = cost >= 50000 ? 2 : 0;
            return {
              ...t,
              estimatedCost: cost,
              status,
              aiTriageSummary: cost >= 50000 
                ? `[FLAGGED] AI estimate LKR ${cost.toLocaleString()} exceeds 50k ceiling. Paused for HITL approval.` 
                : `[APPROVED] AI estimate LKR ${cost.toLocaleString()} within standard threshold.`
            };
          }
          return t;
        })
      );
      addToast('AI triage executed (Simulated Policy Engine)', 'info');
    } finally {
      setTriagingId(null);
    }
  };

  const handleApproveHighCost = async (id) => {
    try {
      await maintenanceService.approveTicket(id);
    } catch (err) {
      console.warn('API error, applying client-side approval state');
    }
    setTickets(prev =>
      prev.map(t => (t.id === id ? { ...t, status: 0 } : t)) // Move to Unassigned/Approved for dispatch
    );
    addToast('Financial approval granted! Ticket unlocked for contractor dispatch.', 'success');
  };

  const handleRejectHighCost = async (id) => {
    setTickets(prev =>
      prev.map(t => (t.id === id ? { ...t, status: 4, aiTriageSummary: 'Declined by Property Manager during HITL authorization.' } : t))
    );
    addToast('Repair authorization declined. Ticket archived.', 'info');
  };

  const handleDispatchContractor = (contractorId, contractorName, maxBudget) => {
    if (!selectedTicketForDispatch) return;
    setTickets(prev =>
      prev.map(t => (t.id === selectedTicketForDispatch.id ? {
        ...t,
        status: 1, // Dispatched
        assignedContractorId: contractorId,
        contractorName: contractorName,
        estimatedCost: maxBudget
      } : t))
    );
    addToast(`Dispatched to ${contractorName} with budget ceiling LKR ${maxBudget.toLocaleString()}`, 'success');
    setSelectedTicketForDispatch(null);
  };

  const handleAdvanceStatus = (ticketId, nextStatus) => {
    setTickets(prev =>
      prev.map(t => (t.id === ticketId ? { ...t, status: nextStatus } : t))
    );
    const statusLabels = { 3: 'In-Progress', 4: 'Resolved' };
    addToast(`Ticket status advanced to ${statusLabels[nextStatus] || 'Next Stage'}`, 'success');
  };

  // Group tickets into 4 AppFolio Kanban Columns
  const pendingApprovalTickets = tickets.filter(t => t.status === 2 || t.status === 'PendingManagerApproval');
  const unassignedTickets = tickets.filter(t => t.status === 0 || t.status === 'Open' || t.status === 2);
  const dispatchedTickets = tickets.filter(t => t.status === 1 || t.status === 'Dispatched');
  const inProgressTickets = tickets.filter(t => t.status === 3 || t.status === 'InProgress');
  const resolvedTickets = tickets.filter(t => t.status === 4 || t.status === 'Resolved');

  const renderPriorityBadge = (priority) => {
    switch (priority) {
      case 3:
      case 'Emergency':
        return (
          <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold border flex items-center gap-1 ${
            isLight ? 'bg-rose-50 text-rose-700 border-rose-200' : 'bg-rose-500/10 text-rose-400 border-rose-500/30'
          }`}>
            <Flame className="w-3 h-3 text-rose-500 animate-pulse" /> Emergency
          </span>
        );
      case 2:
      case 'High':
        return (
          <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold border flex items-center gap-1 ${
            isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/25'
          }`}>
            <AlertTriangle className="w-3 h-3 text-amber-500" /> High
          </span>
        );
      case 1:
      case 'Medium':
        return (
          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
            isLight ? 'bg-blue-50 text-blue-700 border-blue-200' : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
          }`}>
            Medium
          </span>
        );
      default:
        return (
          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
            isLight ? 'bg-slate-100 text-slate-600 border-slate-200' : 'bg-slate-500/10 text-slate-400 border-slate-500/20'
          }`}>
            Low
          </span>
        );
    }
  };

  return (
    <div className="space-y-4">
      {/* Executive Maintenance Ribbon */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3.5">
        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Open Work Orders
            </span>
            <span className={`text-base font-bold font-mono ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
              {tickets.filter(t => t.status !== 4).length} Active
            </span>
          </div>
          <div className={`p-2 rounded-lg ${isLight ? 'bg-blue-50' : 'bg-blue-500/10'}`}>
            <Wrench className={`w-4 h-4 ${isLight ? 'text-blue-600' : 'text-blue-400'}`} />
          </div>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight 
            ? 'bg-amber-50/70 border-amber-200 shadow-xs' 
            : 'bg-amber-950/20 border-amber-500/30'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-amber-800' : 'text-amber-400'
            }`}>
              HITL Threshold Pending
            </span>
            <span className="text-base font-bold text-amber-600 font-mono">
              {pendingApprovalTickets.length} Orders
            </span>
          </div>
          <ShieldAlert className="w-5 h-5 text-amber-600" />
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Emergency Orders
            </span>
            <span className="text-base font-bold text-rose-600 font-mono">
              {tickets.filter(t => t.priority === 3 || t.priority === 'Emergency').length} Urgent
            </span>
          </div>
          <Flame className="w-5 h-5 text-rose-500" />
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Resolved This Period
            </span>
            <span className="text-base font-bold text-emerald-600 font-mono">
              {resolvedTickets.length} Closed
            </span>
          </div>
          <button
            onClick={() => fetchTickets(true)}
            disabled={loading}
            className={`p-1.5 rounded-lg border transition-colors cursor-pointer ${
              isLight ? 'bg-slate-50 border-slate-200 hover:bg-slate-100 text-slate-600' : 'bg-slate-950 border-slate-800 hover:bg-slate-800 text-slate-400 hover:text-slate-200'
            }`}
            title="Refresh Board"
          >
            <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin text-blue-600' : ''}`} />
          </button>
        </div>
      </div>

      {/* Prominent AppFolio HITL Approval Banner (Orders >= LKR 50K) */}
      {pendingApprovalTickets.length > 0 && (
        <div className="space-y-3">
          <div className="flex items-center justify-between px-1">
            <div className="flex items-center gap-2">
              <span className="w-2.5 h-2.5 rounded-full bg-amber-500 animate-ping"></span>
              <h3 className={`text-xs font-bold uppercase tracking-wider ${
                isLight ? 'text-amber-800' : 'text-amber-400'
              }`}>
                Immediate Financial Review Queue ({pendingApprovalTickets.length} Require Authorization)
              </h3>
            </div>
            <span className={`text-[11px] ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
              Policy: All repairs &ge; LKR 50,000 paused
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            {pendingApprovalTickets.map((ticket) => (
              <HighCostApprovalCard
                key={ticket.id}
                ticket={ticket}
                onApprove={handleApproveHighCost}
                onReject={handleRejectHighCost}
              />
            ))}
          </div>
        </div>
      )}

      {/* 4-Column Smart Triage Kanban Board */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-3">
        {/* Column 1: Unassigned (Triage) */}
        <div className={`rounded-2xl border p-3.5 flex flex-col min-h-[500px] ${
          isLight ? 'bg-slate-100/70 border-slate-200' : 'bg-slate-900/70 border-slate-800/80'
        }`}>
          <div className={`flex items-center justify-between border-b pb-2.5 mb-3 ${
            isLight ? 'border-slate-200' : 'border-slate-800/80'
          }`}>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-blue-600"></span>
              <h4 className={`text-xs font-bold uppercase tracking-wider ${
                isLight ? 'text-slate-800' : 'text-slate-200'
              }`}>
                Unassigned (Triage)
              </h4>
            </div>
            <span className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded-full border ${
              isLight ? 'bg-blue-50 text-blue-700 border-blue-200' : 'bg-blue-500/10 text-blue-400 border-blue-500/20'
            }`}>
              {unassignedTickets.length}
            </span>
          </div>

          <div className="space-y-2.5 flex-1 overflow-y-auto">
            {unassignedTickets.map((ticket) => {
              const isHitl = ticket.status === 2 || ticket.status === 'PendingManagerApproval';
              return (
                <div 
                  key={ticket.id}
                  className={`p-3.5 rounded-xl border transition-all ${
                    isLight 
                      ? isHitl ? 'border-amber-300 bg-amber-50/50' : 'bg-white border-slate-200 shadow-xs hover:border-slate-300 hover:shadow-md'
                      : isHitl ? 'border-amber-500/40 bg-amber-950/10' : 'bg-slate-950 border-slate-800 hover:border-slate-700'
                  }`}
                >
                  <div className="flex items-start justify-between gap-1 mb-1.5">
                    <span className="text-[10px] font-mono text-slate-400">#{ticket.id.slice(0, 8)}</span>
                    {renderPriorityBadge(ticket.priority)}
                  </div>

                  <h5 className={`text-xs font-semibold leading-snug mb-1 ${
                    isLight ? 'text-slate-900' : 'text-slate-100'
                  }`}>
                    {ticket.issueDescription}
                  </h5>

                  <p className={`text-[11px] font-mono mb-2 ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                    Est: <strong className="text-emerald-600">LKR {Number(ticket.estimatedCost).toLocaleString()}</strong>
                  </p>

                  {ticket.aiTriageSummary && (
                    <div className={`p-2 rounded-lg border text-[10px] leading-tight mb-2 ${
                      isLight ? 'bg-slate-50 border-slate-200 text-slate-600' : 'bg-slate-900 border-slate-800 text-slate-400'
                    }`}>
                      {ticket.aiTriageSummary}
                    </div>
                  )}

                  <div className={`flex items-center gap-1.5 pt-2 border-t ${
                    isLight ? 'border-slate-100' : 'border-slate-800/80'
                  }`}>
                    <button
                      onClick={() => handleTriage(ticket.id)}
                      disabled={triagingId === ticket.id}
                      className={`flex-1 py-1.5 px-2 rounded-lg border text-[11px] font-semibold flex items-center justify-center gap-1 cursor-pointer transition-all disabled:opacity-50 ${
                        isLight 
                          ? 'bg-indigo-50 hover:bg-indigo-100 text-indigo-700 border-indigo-200' 
                          : 'bg-indigo-500/10 hover:bg-indigo-500/20 text-indigo-400 border-indigo-500/20'
                      }`}
                    >
                      <Sparkles className="w-3 h-3" />
                      {triagingId === ticket.id ? '...' : 'AI Triage'}
                    </button>
                    {!isHitl && (
                      <button
                        onClick={() => setSelectedTicketForDispatch(ticket)}
                        className="flex-1 py-1.5 px-2 rounded-lg bg-amber-600 hover:bg-amber-700 text-white text-[11px] font-semibold flex items-center justify-center gap-1 shadow-xs transition-all cursor-pointer"
                      >
                        <UserCheck className="w-3 h-3" />
                        Dispatch
                      </button>
                    )}
                  </div>
                </div>
              );
            })}
          </div>
        </div>

        {/* Column 2: Dispatched */}
        <div className={`rounded-2xl border p-3.5 flex flex-col min-h-[500px] ${
          isLight ? 'bg-slate-100/70 border-slate-200' : 'bg-slate-900/70 border-slate-800/80'
        }`}>
          <div className={`flex items-center justify-between border-b pb-2.5 mb-3 ${
            isLight ? 'border-slate-200' : 'border-slate-800/80'
          }`}>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-amber-500"></span>
              <h4 className={`text-xs font-bold uppercase tracking-wider ${
                isLight ? 'text-slate-800' : 'text-slate-200'
              }`}>
                Dispatched
              </h4>
            </div>
            <span className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded-full border ${
              isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
            }`}>
              {dispatchedTickets.length}
            </span>
          </div>

          <div className="space-y-2.5 flex-1 overflow-y-auto">
            {dispatchedTickets.map((ticket) => (
              <div 
                key={ticket.id} 
                className={`p-3.5 rounded-xl border space-y-2 ${
                  isLight ? 'bg-white border-slate-200 shadow-xs' : 'bg-slate-950 border-slate-800'
                }`}
              >
                <div className="flex items-start justify-between gap-1">
                  <span className="text-[10px] font-mono text-slate-400">#{ticket.id.slice(0, 8)}</span>
                  {renderPriorityBadge(ticket.priority)}
                </div>

                <h5 className={`text-xs font-semibold leading-snug ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                  {ticket.issueDescription}
                </h5>

                <div className={`p-2 rounded-lg border text-[11px] ${
                  isLight ? 'bg-slate-50 border-slate-200' : 'bg-slate-900 border-slate-800'
                }`}>
                  <span className={`text-[10px] block ${isLight ? 'text-slate-500' : 'text-slate-500'}`}>
                    Service Partner Assigned:
                  </span>
                  <span className="font-semibold text-blue-600">{ticket.contractorName || 'QuickPlumb Services'}</span>
                  <div className="text-[10px] font-mono text-emerald-600 mt-0.5">
                    Ceiling: LKR {Number(ticket.estimatedCost).toLocaleString()}
                  </div>
                </div>

                <button
                  onClick={() => handleAdvanceStatus(ticket.id, 3)} // To InProgress
                  className="w-full py-1.5 px-2 rounded-lg bg-blue-600 hover:bg-blue-700 text-white text-[11px] font-semibold flex items-center justify-center gap-1 shadow-xs transition-all cursor-pointer"
                >
                  <ArrowRight className="w-3 h-3" /> Move to In-Progress
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Column 3: In-Progress */}
        <div className={`rounded-2xl border p-3.5 flex flex-col min-h-[500px] ${
          isLight ? 'bg-slate-100/70 border-slate-200' : 'bg-slate-900/70 border-slate-800/80'
        }`}>
          <div className={`flex items-center justify-between border-b pb-2.5 mb-3 ${
            isLight ? 'border-slate-200' : 'border-slate-800/80'
          }`}>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-indigo-500 animate-pulse"></span>
              <h4 className={`text-xs font-bold uppercase tracking-wider ${
                isLight ? 'text-slate-800' : 'text-slate-200'
              }`}>
                In-Progress
              </h4>
            </div>
            <span className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded-full border ${
              isLight ? 'bg-indigo-50 text-indigo-700 border-indigo-200' : 'bg-indigo-500/10 text-indigo-400 border-indigo-500/20'
            }`}>
              {inProgressTickets.length}
            </span>
          </div>

          <div className="space-y-2.5 flex-1 overflow-y-auto">
            {inProgressTickets.map((ticket) => (
              <div 
                key={ticket.id} 
                className={`p-3.5 rounded-xl border space-y-2 ${
                  isLight ? 'bg-white border-slate-200 shadow-xs' : 'bg-slate-950 border-slate-800'
                }`}
              >
                <div className="flex items-start justify-between gap-1">
                  <span className="text-[10px] font-mono text-slate-400">#{ticket.id.slice(0, 8)}</span>
                  {renderPriorityBadge(ticket.priority)}
                </div>

                <h5 className={`text-xs font-semibold leading-snug ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                  {ticket.issueDescription}
                </h5>

                <div className={`flex items-center justify-between text-[11px] p-2 rounded-lg border ${
                  isLight ? 'bg-slate-50 border-slate-200' : 'bg-slate-900 border-slate-800'
                }`}>
                  <span className="text-slate-500 text-[10px]">On-site Execution</span>
                  <span className="text-blue-600 font-semibold font-mono text-[10px]">98% Confidence</span>
                </div>

                <button
                  onClick={() => handleAdvanceStatus(ticket.id, 4)} // To Resolved
                  className="w-full py-1.5 px-2 rounded-lg bg-emerald-600 hover:bg-emerald-700 text-white text-[11px] font-semibold flex items-center justify-center gap-1 shadow-xs transition-all cursor-pointer"
                >
                  <CheckCircle2 className="w-3.5 h-3.5" /> Complete & Close Order
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Column 4: Resolved */}
        <div className={`rounded-2xl border p-3.5 flex flex-col min-h-[500px] ${
          isLight ? 'bg-slate-100/70 border-slate-200' : 'bg-slate-900/70 border-slate-800/80'
        }`}>
          <div className={`flex items-center justify-between border-b pb-2.5 mb-3 ${
            isLight ? 'border-slate-200' : 'border-slate-800/80'
          }`}>
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-emerald-500"></span>
              <h4 className={`text-xs font-bold uppercase tracking-wider ${
                isLight ? 'text-slate-800' : 'text-slate-200'
              }`}>
                Resolved
              </h4>
            </div>
            <span className={`text-[10px] font-mono font-bold px-2 py-0.5 rounded-full border ${
              isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
            }`}>
              {resolvedTickets.length}
            </span>
          </div>

          <div className="space-y-2.5 flex-1 overflow-y-auto">
            {resolvedTickets.map((ticket) => (
              <div 
                key={ticket.id} 
                className={`p-3.5 rounded-xl border space-y-1.5 opacity-90 ${
                  isLight ? 'bg-white border-slate-200 shadow-xs' : 'bg-slate-950 border-slate-800'
                }`}
              >
                <div className="flex items-start justify-between gap-1">
                  <span className="text-[10px] font-mono text-slate-400">#{ticket.id.slice(0, 8)}</span>
                  <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                    isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
                  }`}>
                    Closed
                  </span>
                </div>

                <h5 className={`text-xs font-semibold leading-snug line-through ${
                  isLight ? 'text-slate-500' : 'text-slate-400'
                }`}>
                  {ticket.issueDescription}
                </h5>

                <div className={`p-2 rounded-lg border text-[10px] flex items-center justify-between font-mono ${
                  isLight ? 'bg-slate-50 border-slate-200 text-slate-600' : 'bg-slate-900 border-slate-800 text-slate-400'
                }`}>
                  <span>Settled Cost:</span>
                  <span className="text-emerald-600 font-bold">LKR {Number(ticket.estimatedCost).toLocaleString()}</span>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Contractor Dispatch Flyout Modal */}
      <ContractorDispatchModal
        isOpen={selectedTicketForDispatch !== null}
        onClose={() => setSelectedTicketForDispatch(null)}
        ticket={selectedTicketForDispatch}
        onDispatch={handleDispatchContractor}
      />
    </div>
  );
};
