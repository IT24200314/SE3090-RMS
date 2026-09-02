// =================================================================================================
// File: TenantReviewPortal.jsx
// Module: Component B: Tenant Screening & Onboarding Management
// Student Contributor: Nethmi Seya (IT24200314 Group Member)
// Architecture: Frontend Layer - React Component for Tenant Screening & Risk Evaluation
// Purpose: Provides real-estate staff with an interactive review portal showing credit scores,
//          rent-to-income debt gauges, identity verification status, and manual approval triggers.
// =================================================================================================

import React, { useState } from 'react';
import { 
  FileCheck, 
  Sparkles, 
  RefreshCw, 
  Users, 
  ShieldCheck, 
  AlertTriangle, 
  CheckCircle2, 
  XCircle,
  Eye,
  TrendingDown,
  Building
} from 'lucide-react';
import { RiskScoreBadge, RiskScoreGauge } from './RiskScoreBadge';
import { IdentityVerificationModal } from './IdentityVerificationModal';
import { useToast } from '../common/Toast';
import { useTheme } from '../../context/ThemeContext';
import { tenantService } from '../../services/api';

const INITIAL_APPLICATIONS = [
  {
    id: 'c1d2e3f4-a5b6-7c8d-9e0f-1a2b3c4d5e6f',
    applicantName: 'Kamal Perera',
    applicantAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
    tenantId: 't1a2b3c4-d5e6-f7a8-b9c0-d1e2f3a4b5c6',
    propertyId: 'e1a3b8c4-5d6e-7f8a-9b0c-1d2e3f4a5b6c',
    propertyTitle: 'Oceanfront Luxury Suite',
    monthlyRent: 220000,
    monthlyIncome: 650000,
    identityDocUrl: 'https://cdn.rms.local/kyc/nic_kamal_perera.pdf',
    status: 1, // Approved
    aiRiskScore: 92,
    aiScreeningNotes: 'Low risk profile: Tenant income securely covers rent (33.8% debt-to-income ratio). Identity verified against National Registry.',
    createdAtUtc: new Date().toISOString()
  },
  {
    id: 'd2e3f4a5-b6c7-8d9e-0f1a-2b3c4d5e6f7a',
    applicantName: 'Anura De Silva',
    applicantAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80',
    tenantId: 't2b3c4d5-e6f7-a8b9-c0d1-e2f3a4b5c6d7',
    propertyId: 'f2b4c9d5-6e7f-8a9b-0c1d-2e3f4a5b6c7d',
    propertyTitle: 'Cinnamon Gardens Townhouse',
    monthlyRent: 350000,
    monthlyIncome: 750000,
    identityDocUrl: 'https://cdn.rms.local/kyc/nic_anura_silva.pdf',
    status: 3, // ReviewRequired
    aiRiskScore: 68,
    aiScreeningNotes: 'Moderate risk: Rent accounts for 46.7% of monthly income (exceeds 40% optimal ceiling). Flagged for HITL Manager Approval.',
    createdAtUtc: new Date().toISOString()
  },
  {
    id: 'e3f4a5b6-c7d8-9e0f-1a2b-3c4d5e6f7a8b',
    applicantName: 'Ruwan Fernando',
    applicantAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80',
    tenantId: 't3c4d5e6-f7a8-b9c0-d1e2-f3a4b5c6d7e8',
    propertyId: 'a3c5d0e6-7f8a-9b0c-1d2e-3f4a5b6c7d8e',
    propertyTitle: 'Havelock City Studio Apartment',
    monthlyRent: 95000,
    monthlyIncome: 175000,
    identityDocUrl: 'https://cdn.rms.local/kyc/nic_ruwan_fernando.pdf',
    status: 0, // Pending
    aiRiskScore: 54,
    aiScreeningNotes: 'Debt-to-income ratio at 54.2% (> 50% high threshold). Requires secondary guarantor or risk bond.',
    createdAtUtc: new Date().toISOString()
  }
];

export const TenantReviewPortal = () => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const [applications, setApplications] = useState(INITIAL_APPLICATIONS);
  const [activeTab, setActiveTab] = useState('ALL');
  const [loading, setLoading] = useState(false);
  const [evaluatingId, setEvaluatingId] = useState(null);
  const [selectedAppForKyc, setSelectedAppForKyc] = useState(null);
  const { addToast } = useToast();

  const fetchApplications = async () => {
    setLoading(true);
    try {
      const res = await tenantService.getApplications();
      if (res.data && res.data.length > 0) {
        setApplications(res.data);
      }
    } catch (err) {
      console.warn('Backend unavailable, using local state:', err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleEvaluateRisk = async (id) => {
    setEvaluatingId(id);
    try {
      const res = await tenantService.evaluateRisk(id);
      if (res.data) {
        setApplications(prev =>
          prev.map(app => (app.id === id ? {
            ...app,
            aiRiskScore: res.data.aiRiskScore,
            status: res.data.status,
            aiScreeningNotes: res.data.evaluationNotes
          } : app))
        );
      }
      addToast(`Risk evaluation completed for Application ${id.slice(0, 8)}`, 'success');
    } catch (err) {
      console.warn('API error, applying client-side rule evaluation:', err);
      // Fallback deterministic simulation
      setApplications(prev =>
        prev.map(app => {
          if (app.id === id) {
            const rent = app.monthlyRent || 200000;
            const income = app.monthlyIncome || 400000;
            const ratio = rent / income;
            let score = 88;
            let status = 1;
            let notes = 'Approved: Low debt-to-rent ratio.';
            if (ratio > 0.45) {
              score = 62;
              status = 3;
              notes = 'Moderate debt ratio (> 45%). Requires HITL Manager Approval.';
            }
            return { ...app, aiRiskScore: score, status, aiScreeningNotes: notes };
          }
          return app;
        })
      );
      addToast('AI Risk Score evaluated (Simulated Model)', 'info');
    } finally {
      setEvaluatingId(null);
    }
  };

  const handleReviewDecision = async (id, decision, decisionText) => {
    try {
      await tenantService.reviewApplication(id, decision);
      setApplications(prev =>
        prev.map(app => (app.id === id ? { ...app, status: decision } : app))
      );
      addToast(`Application marked as ${decisionText}`, decision === 1 ? 'success' : 'info');
    } catch (err) {
      setApplications(prev =>
        prev.map(app => (app.id === id ? { ...app, status: decision } : app))
      );
      addToast(`Application marked as ${decisionText} (Local state updated)`, 'info');
    }
  };

  const handleVerifyKyc = (appId) => {
    setApplications(prev =>
      prev.map(app => (app.id === appId ? { ...app, status: 1 } : app))
    );
    addToast('KYC Identity Document Verified & Approved!', 'success');
    setSelectedAppForKyc(null);
  };

  const filteredApps = applications.filter((app) => {
    if (activeTab === 'ALL') return true;
    if (activeTab === 'HITL') return app.status === 3 || app.status === 'ReviewRequired';
    if (activeTab === 'APPROVED') return app.status === 1 || app.status === 'Approved';
    if (activeTab === 'PENDING') return app.status === 0 || app.status === 'Pending';
    return true;
  });

  const hitlCount = applications.filter(a => a.status === 3 || a.status === 'ReviewRequired').length;

  return (
    <div className="space-y-4">
      {/* Executive Portfolio Screening KPI Strip */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-3.5">
        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Total Applicants
            </span>
            <span className={`text-base font-bold font-mono ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
              {applications.length} Candidates
            </span>
          </div>
          <div className={`p-2 rounded-lg ${isLight ? 'bg-blue-50' : 'bg-blue-500/10'}`}>
            <Users className={`w-4 h-4 ${isLight ? 'text-blue-600' : 'text-blue-400'}`} />
          </div>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              HITL Review Queue
            </span>
            <span className="text-base font-bold text-amber-600 font-mono">
              {hitlCount} Actions
            </span>
          </div>
          <span className={`text-[10px] px-2 py-0.5 rounded-full font-semibold border ${
            isLight ? 'bg-amber-50 text-amber-700 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/20'
          }`}>
            Priority
          </span>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Auto-Approval Rate
            </span>
            <span className="text-base font-bold text-emerald-600 font-mono">67%</span>
          </div>
          <span className={`text-[10px] px-2 py-0.5 rounded-full font-semibold border ${
            isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/20'
          }`}>
            Target: 60%
          </span>
        </div>

        <div className={`p-3.5 rounded-xl border flex items-center justify-between transition-all ${
          isLight ? 'bg-white border-slate-200/90 shadow-xs' : 'bg-slate-900/80 border-slate-800'
        }`}>
          <div>
            <span className={`text-[10px] font-semibold uppercase tracking-wider block ${
              isLight ? 'text-slate-500' : 'text-slate-400'
            }`}>
              Average AI Risk Score
            </span>
            <span className="text-base font-bold text-indigo-600 font-mono">71 / 100</span>
          </div>
          <div className={`p-2 rounded-lg ${isLight ? 'bg-indigo-50' : 'bg-indigo-500/10'}`}>
            <Sparkles className={`w-4 h-4 ${isLight ? 'text-indigo-600' : 'text-indigo-400'}`} />
          </div>
        </div>
      </div>

      {/* Tabs & Filter Bar */}
      <div className={`rounded-xl border p-3 flex items-center justify-between shadow-xs ${
        isLight ? 'bg-white border-slate-200/90' : 'bg-slate-900/90 border-slate-800/80'
      }`}>
        <div className={`flex p-1 rounded-lg border gap-1 ${
          isLight ? 'bg-slate-100 border-slate-200' : 'bg-slate-950 border-slate-800'
        }`}>
          {[
            { id: 'ALL', label: `All Applicants (${applications.length})` },
            { id: 'HITL', label: `HITL Queue (${hitlCount})` },
            { id: 'APPROVED', label: 'Approved' },
            { id: 'PENDING', label: 'Pending AI' }
          ].map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`px-3 py-1.5 rounded-md text-xs font-semibold transition-all cursor-pointer whitespace-nowrap ${
                activeTab === tab.id
                  ? 'bg-blue-600 text-white shadow-xs'
                  : isLight ? 'text-slate-600 hover:text-slate-900' : 'text-slate-400 hover:text-slate-200'
              }`}
            >
              {tab.label}
            </button>
          ))}
        </div>

        <button
          onClick={fetchApplications}
          className={`p-1.5 rounded-lg border transition-colors cursor-pointer ${
            isLight 
              ? 'bg-slate-50 border-slate-200 hover:bg-slate-100 text-slate-600' 
              : 'bg-slate-950 border-slate-800 hover:bg-slate-800 text-slate-400 hover:text-slate-200'
          }`}
          title="Refresh Applications"
        >
          <RefreshCw className={`w-3.5 h-3.5 ${loading ? 'animate-spin text-blue-600' : ''}`} />
        </button>
      </div>

      {/* Applicant Scorecards Grid */}
      <div className="space-y-3">
        {filteredApps.map((app) => {
          const isEvaluating = evaluatingId === app.id;
          const rent = app.monthlyRent || 180000;
          const income = app.monthlyIncome || 450000;
          const debtRatio = Math.round((rent / (income || 1)) * 100);

          // Debt ratio color categorization
          let ratioTextColor = isLight ? 'text-emerald-700' : 'text-emerald-400';
          let ratioBarColor = 'bg-emerald-500';
          let ratioCategory = 'Optimal (≤ 35%)';
          if (debtRatio > 50) {
            ratioTextColor = isLight ? 'text-rose-700' : 'text-rose-400';
            ratioBarColor = 'bg-rose-500';
            ratioCategory = 'High Risk (> 50%)';
          } else if (debtRatio > 35) {
            ratioTextColor = isLight ? 'text-amber-700' : 'text-amber-400';
            ratioBarColor = 'bg-amber-500';
            ratioCategory = 'Moderate (35%-50%)';
          }

          const isReviewRequired = app.status === 3 || app.status === 'ReviewRequired';
          const isApproved = app.status === 1 || app.status === 'Approved';

          return (
            <div 
              key={app.id}
              className={`rounded-2xl border p-4 transition-all ${
                isLight
                  ? isReviewRequired 
                    ? 'bg-white border-amber-300 shadow-[0_2px_12px_rgba(245,158,11,0.12)]' 
                    : 'bg-white border-slate-200 shadow-xs hover:border-slate-300 hover:shadow-md'
                  : isReviewRequired 
                    ? 'bg-slate-900/80 border-amber-500/40 shadow-[0_0_20px_-4px_rgba(245,158,11,0.15)]' 
                    : 'bg-slate-900/80 border-slate-800/80 hover:border-slate-700'
              }`}
            >
              <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-4">
                {/* Left: Applicant Identity & Score Gauge */}
                <div className="flex items-center gap-4 min-w-[280px]">
                  <RiskScoreGauge score={app.aiRiskScore || 50} size={64} showLabel={false} />
                  
                  <div className="flex items-center gap-3">
                    {app.applicantAvatar ? (
                      <img 
                        src={app.applicantAvatar} 
                        alt={app.applicantName || 'Applicant'} 
                        className="w-10 h-10 rounded-full object-cover border border-slate-200 shadow-xs"
                      />
                    ) : (
                      <div className="w-10 h-10 rounded-full bg-blue-600 text-white font-bold flex items-center justify-center text-xs">
                        {app.applicantName ? app.applicantName.charAt(0) : 'A'}
                      </div>
                    )}

                    <div>
                      <div className="flex items-center gap-2">
                        <span className={`font-bold text-sm ${isLight ? 'text-slate-900' : 'text-slate-100'}`}>
                          {app.applicantName || `APP-${app.id.slice(0, 8).toUpperCase()}`}
                        </span>
                        {isApproved ? (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                            isLight ? 'bg-emerald-50 text-emerald-700 border-emerald-200' : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/25'
                          }`}>
                            Approved
                          </span>
                        ) : isReviewRequired ? (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border animate-pulse ${
                            isLight ? 'bg-amber-50 text-amber-800 border-amber-200' : 'bg-amber-500/10 text-amber-400 border-amber-500/25'
                          }`}>
                            HITL Review Req.
                          </span>
                        ) : (
                          <span className={`px-2 py-0.5 rounded-full text-[10px] font-semibold border ${
                            isLight ? 'bg-slate-100 text-slate-600 border-slate-200' : 'bg-slate-500/10 text-slate-400 border-slate-500/20'
                          }`}>
                            Pending AI
                          </span>
                        )}
                      </div>
                      <p className={`text-xs mt-0.5 flex items-center gap-1 ${
                        isLight ? 'text-slate-500' : 'text-slate-400'
                      }`}>
                        <Building className="w-3 h-3 text-blue-500" />
                        {app.propertyTitle || 'Property Unit Assignment'}
                      </p>
                      <div className="flex items-center gap-2 mt-1.5">
                        <button
                          onClick={() => setSelectedAppForKyc(app)}
                          className={`inline-flex items-center gap-1 text-[11px] font-semibold px-2 py-0.5 rounded border transition-colors cursor-pointer ${
                            isLight 
                              ? 'bg-blue-50 text-blue-700 border-blue-200 hover:bg-blue-100' 
                              : 'bg-blue-500/10 text-blue-400 hover:text-blue-300 border-blue-500/20'
                          }`}
                        >
                          <FileCheck className="w-3 h-3" /> Inspect KYC Document
                        </button>
                      </div>
                    </div>
                  </div>
                </div>

                {/* Center: Income-to-Rent Debt Ratio Visualization Bar */}
                <div className={`flex-1 max-w-md p-3 rounded-xl border ${
                  isLight ? 'bg-slate-50/80 border-slate-200' : 'bg-slate-950/80 border-slate-800/80'
                }`}>
                  <div className="flex items-center justify-between text-xs mb-1.5">
                    <span className={`text-[10px] font-semibold uppercase tracking-wider ${
                      isLight ? 'text-slate-500' : 'text-slate-400'
                    }`}>
                      Income vs. Rent Debt Ratio
                    </span>
                    <span className={`font-mono font-bold text-xs ${ratioTextColor}`}>
                      {debtRatio}% ({ratioCategory})
                    </span>
                  </div>

                  {/* Progress Track */}
                  <div className={`w-full h-2 rounded-full overflow-hidden flex ${
                    isLight ? 'bg-slate-200' : 'bg-slate-800'
                  }`}>
                    <div 
                      className={`h-full transition-all duration-500 ${ratioBarColor}`}
                      style={{ width: `${Math.min(debtRatio, 100)}%` }}
                    ></div>
                  </div>

                  <div className={`flex items-center justify-between mt-2 text-[10px] font-mono ${
                    isLight ? 'text-slate-600' : 'text-slate-400'
                  }`}>
                    <span>Income: LKR {Number(income).toLocaleString()}</span>
                    <span>Rent: LKR {Number(rent).toLocaleString()}</span>
                  </div>
                </div>

                {/* Right: Actions */}
                <div className="flex items-center gap-2 justify-end">
                  {isReviewRequired ? (
                    <>
                      <button
                        onClick={() => handleReviewDecision(app.id, 1, 'Approved')}
                        className="px-3.5 py-1.5 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all cursor-pointer"
                      >
                        <CheckCircle2 className="w-3.5 h-3.5" /> Approve
                      </button>
                      <button
                        onClick={() => handleReviewDecision(app.id, 2, 'Rejected')}
                        className={`px-3.5 py-1.5 rounded-xl text-xs font-semibold flex items-center gap-1.5 active:scale-[0.98] transition-all cursor-pointer border ${
                          isLight 
                            ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border-rose-200' 
                            : 'bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border-rose-500/30'
                        }`}
                      >
                        <XCircle className="w-3.5 h-3.5" /> Reject
                      </button>
                    </>
                  ) : (
                    <button
                      onClick={() => handleEvaluateRisk(app.id)}
                      disabled={isEvaluating}
                      className="px-3.5 py-1.5 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold flex items-center gap-1.5 shadow-sm active:scale-[0.98] transition-all cursor-pointer disabled:opacity-50"
                    >
                      <Sparkles className={`w-3.5 h-3.5 ${isEvaluating ? 'animate-spin' : ''}`} />
                      {isEvaluating ? 'Evaluating...' : 'Run Risk AI'}
                    </button>
                  )}
                </div>
              </div>

              {/* AI Screening Notes Quote Box */}
              {app.aiScreeningNotes && (
                <div className={`mt-3 pt-2.5 border-t flex items-start gap-2 text-[11px] ${
                  isLight ? 'border-slate-100 text-slate-600' : 'border-slate-800/80 text-slate-400'
                }`}>
                  <Sparkles className="w-3.5 h-3.5 text-indigo-500 flex-shrink-0 mt-0.5" />
                  <span className="leading-relaxed font-sans">{app.aiScreeningNotes}</span>
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* 2-Pane KYC Modal */}
      <IdentityVerificationModal
        isOpen={selectedAppForKyc !== null}
        onClose={() => setSelectedAppForKyc(null)}
        application={selectedAppForKyc}
        onVerify={handleVerifyKyc}
      />
    </div>
  );
};
