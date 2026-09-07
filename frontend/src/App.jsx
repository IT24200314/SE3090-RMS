// =================================================================================================
// File: App.jsx
// Module: React Admin Dashboard / Application Shell & Navigation Router
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Frontend Layer - React 19 Single Page Application with Tabbed Clean UI
// Purpose: Hosts the main operational dashboard providing unified tabs for Property Listings,
//          Tenant Screening/KYC, Maintenance Triage & HITL Approvals, and AI Telemetry.
// =================================================================================================

import React, { useState } from 'react';
import { ThemeProvider, useTheme } from './context/ThemeContext';
import { Sidebar } from './components/layout/Sidebar';
import { Header } from './components/layout/Header';
import { MetricsOverview } from './components/common/MetricsOverview';
import { ToastProvider } from './components/common/Toast';
import { PropertyList } from './components/properties/PropertyList';
import { AiExecutionTrace } from './components/properties/AiExecutionTrace';
import { TenantReviewPortal } from './components/tenants/TenantReviewPortal';
import { MaintenanceBoard } from './components/maintenance/MaintenanceBoard';

function DashboardContent() {
  const [activeTab, setActiveTab] = useState('properties');
  const { theme } = useTheme();

  const getHeaderDetails = () => {
    switch (activeTab) {
      case 'properties':
        return {
          title: 'Property & Lease Management',
          subtitle: 'Component A (Upamada) — Inventory, Lease Lifecycle & State Transitions'
        };
      case 'tenants':
        return {
          title: 'Tenant Screening & KYC',
          subtitle: 'Component B (Nethmi) — Risk Scoring Engine & Document Verification'
        };
      case 'maintenance':
        return {
          title: 'Maintenance & Dispatch',
          subtitle: 'Component C (Hashini) — Triage & Human-in-the-Loop Financial Approvals'
        };
      case 'ai-trace':
        return {
          title: 'Agentic AI Execution Telemetry',
          subtitle: 'Multi-Agent LangGraph StateGraph Observability'
        };
      default:
        return {
          title: 'Rental Management System',
          subtitle: 'Staff & Admin Operations'
        };
    }
  };

  const { title, subtitle } = getHeaderDetails();

  return (
    <div className={`flex min-h-screen font-sans antialiased transition-colors duration-200 ${
      theme === 'dark' 
        ? 'bg-slate-950 text-slate-100' 
        : 'bg-[#F8FAFC] text-slate-900'
    }`}>
      {/* Sidebar Navigation */}
      <Sidebar activeTab={activeTab} setActiveTab={setActiveTab} />

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 overflow-hidden">
        <Header currentTitle={title} subtitle={subtitle} />

        <main className="flex-1 p-6 overflow-y-auto">
          <div className="max-w-7xl mx-auto space-y-6">
            {/* Dynamic KPI Overview Ribbon */}
            <MetricsOverview stats={{ totalProperties: 4, occupiedCount: 1, availableCount: 2, hitlCount: 1, pendingKyc: 2 }} />

            {activeTab === 'properties' && <PropertyList />}
            {activeTab === 'tenants' && <TenantReviewPortal />}
            {activeTab === 'maintenance' && <MaintenanceBoard />}
            {activeTab === 'ai-trace' && <AiExecutionTrace />}
          </div>
        </main>
      </div>
    </div>
  );
}

export default function App() {
  return (
    <ThemeProvider>
      <ToastProvider>
        <DashboardContent />
      </ToastProvider>
    </ThemeProvider>
  );
}
