// =================================================================================================
// File: LoginScreen.jsx
// Module: Frontend Authentication Presentation Layer
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Presentation Layer - Modern Glassmorphic Login Gateway with Evaluator Presets
// Purpose: Provides authentication interface for Managers, Tenants, and Contractors with one-click
//          quick-fill credentials for SE3090 evaluators and examiners, JWT token acquisition.
// =================================================================================================

import React, { useState } from 'react';
import { 
  Building2, 
  Lock, 
  Mail, 
  ArrowRight, 
  ShieldCheck, 
  Sparkles, 
  Sun, 
  Moon, 
  CheckCircle2, 
  AlertCircle,
  KeyRound,
  UserCheck,
  Wrench,
  Home
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useTheme } from '../../context/ThemeContext';

export const LoginScreen = () => {
  const { login } = useAuth();
  const { theme, toggleTheme } = useTheme();
  const isLight = theme === 'light';

  const [email, setEmail] = useState('manager@rms.lk');
  const [password, setPassword] = useState('Password123!');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [showPassword, setShowPassword] = useState(false);

  const handleQuickFill = (presetEmail, presetPwd) => {
    setEmail(presetEmail);
    setPassword(presetPwd);
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    const result = await login(email, password);
    setLoading(false);

    if (!result.success) {
      setError(result.message || 'Login failed. Please verify credentials.');
    }
  };

  return (
    <div className={`min-h-screen flex flex-col justify-between transition-colors duration-300 font-sans ${
      isLight 
        ? 'bg-gradient-to-br from-slate-50 via-blue-50/40 to-slate-100 text-slate-900' 
        : 'bg-gradient-to-br from-slate-950 via-slate-900 to-indigo-950 text-slate-100'
    }`}>
      {/* Top Navbar */}
      <header className="px-6 py-4 flex items-center justify-between max-w-7xl mx-auto w-full">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-xl bg-gradient-to-tr from-blue-600 to-indigo-600 flex items-center justify-center text-white shadow-md shadow-blue-500/20">
            <Building2 className="w-5 h-5" />
          </div>
          <div>
            <span className="font-extrabold text-base tracking-tight block">
              RMS Enterprise
            </span>
            <span className="text-[10px] font-mono text-blue-600 dark:text-blue-400 font-semibold">
              SE3090 PropTech • Multi-Agent AI
            </span>
          </div>
        </div>

        <div className="flex items-center gap-2">
          <button
            onClick={toggleTheme}
            className={`p-2 rounded-xl border transition-colors cursor-pointer ${
              isLight 
                ? 'bg-white border-slate-200 text-slate-600 hover:bg-slate-100' 
                : 'bg-slate-900 border-slate-800 text-slate-300 hover:bg-slate-800'
            }`}
            title="Toggle Light/Dark Theme"
          >
            {isLight ? <Moon className="w-4 h-4" /> : <Sun className="w-4 h-4 text-amber-400" />}
          </button>
        </div>
      </header>

      {/* Main Form Center Box */}
      <main className="flex-1 flex items-center justify-center px-4 py-8">
        <div className="w-full max-w-md space-y-6">
          {/* Glassmorphic Login Card */}
          <div className={`rounded-3xl border p-8 shadow-2xl transition-all duration-300 backdrop-blur-xl ${
            isLight 
              ? 'bg-white/95 border-slate-200/90 shadow-slate-200/60' 
              : 'bg-slate-900/90 border-slate-800/80 shadow-black/80'
          }`}>
            <div className="text-center space-y-2 mb-6">
              <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[11px] font-semibold bg-blue-500/10 text-blue-600 dark:text-blue-400 border border-blue-500/20">
                <ShieldCheck className="w-3.5 h-3.5" /> Secure JWT Bearer Access
              </div>
              <h2 className="text-2xl font-black tracking-tight">
                Sign in to your portal
              </h2>
              <p className={`text-xs ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Select an evaluator preset or enter credentials below.
              </p>
            </div>

            {/* Evaluator Quick-Fill Cards */}
            <div className="space-y-2 mb-6">
              <span className={`text-[10px] font-bold uppercase tracking-wider block text-center ${
                isLight ? 'text-slate-400' : 'text-slate-500'
              }`}>
                One-Click Viva & Evaluator Presets:
              </span>
              <div className="grid grid-cols-3 gap-2">
                <button
                  type="button"
                  onClick={() => handleQuickFill('manager@rms.lk', 'Password123!')}
                  className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer flex flex-col items-center justify-center text-center group ${
                    email === 'manager@rms.lk'
                      ? 'border-blue-500 bg-blue-500/10 text-blue-600 dark:text-blue-400 font-bold'
                      : isLight 
                        ? 'border-slate-200 hover:border-blue-300 hover:bg-slate-50' 
                        : 'border-slate-800 hover:border-blue-500/40 hover:bg-slate-800/50'
                  }`}
                >
                  <Building2 className="w-4 h-4 mb-1 text-blue-600 dark:text-blue-400" />
                  <span className="text-[11px] font-bold block leading-tight">Manager</span>
                  <span className="text-[9px] opacity-70">Admin Access</span>
                </button>

                <button
                  type="button"
                  onClick={() => handleQuickFill('tenant@rms.lk', 'Password123!')}
                  className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer flex flex-col items-center justify-center text-center group ${
                    email === 'tenant@rms.lk'
                      ? 'border-emerald-500 bg-emerald-500/10 text-emerald-600 dark:text-emerald-400 font-bold'
                      : isLight 
                        ? 'border-slate-200 hover:border-emerald-300 hover:bg-slate-50' 
                        : 'border-slate-800 hover:border-emerald-500/40 hover:bg-slate-800/50'
                  }`}
                >
                  <Home className="w-4 h-4 mb-1 text-emerald-600 dark:text-emerald-400" />
                  <span className="text-[11px] font-bold block leading-tight">Tenant</span>
                  <span className="text-[9px] opacity-70">Renter Portal</span>
                </button>

                <button
                  type="button"
                  onClick={() => handleQuickFill('contractor@rms.lk', 'Password123!')}
                  className={`p-2.5 rounded-xl border text-left transition-all cursor-pointer flex flex-col items-center justify-center text-center group ${
                    email === 'contractor@rms.lk'
                      ? 'border-amber-500 bg-amber-500/10 text-amber-600 dark:text-amber-400 font-bold'
                      : isLight 
                        ? 'border-slate-200 hover:border-amber-300 hover:bg-slate-50' 
                        : 'border-slate-800 hover:border-amber-500/40 hover:bg-slate-800/50'
                  }`}
                >
                  <Wrench className="w-4 h-4 mb-1 text-amber-600 dark:text-amber-400" />
                  <span className="text-[11px] font-bold block leading-tight">Contractor</span>
                  <span className="text-[9px] opacity-70">Work Orders</span>
                </button>
              </div>
            </div>

            {/* Error Message */}
            {error && (
              <div className="mb-4 p-3 rounded-xl bg-rose-500/10 border border-rose-500/20 text-rose-600 dark:text-rose-400 text-xs flex items-center gap-2 animate-in fade-in duration-200">
                <AlertCircle className="w-4 h-4 shrink-0" />
                <span>{error}</span>
              </div>
            )}

            {/* Login Form */}
            <form onSubmit={handleSubmit} className="space-y-4">
              <div>
                <label className={`block text-xs font-semibold mb-1.5 ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                  Email Address
                </label>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <Mail className="w-4 h-4" />
                  </div>
                  <input
                    type="email"
                    required
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    placeholder="name@rms.lk"
                    className={`w-full pl-10 pr-3.5 py-2.5 rounded-xl border text-sm transition-all focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                      isLight 
                        ? 'bg-slate-50 border-slate-200 text-slate-900 focus:bg-white' 
                        : 'bg-slate-950 border-slate-800 text-slate-100 focus:bg-slate-900'
                    }`}
                  />
                </div>
              </div>

              <div>
                <div className="flex items-center justify-between mb-1.5">
                  <label className={`text-xs font-semibold ${isLight ? 'text-slate-700' : 'text-slate-300'}`}>
                    Password
                  </label>
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="text-[11px] text-blue-600 dark:text-blue-400 hover:underline cursor-pointer"
                  >
                    {showPassword ? 'Hide' : 'Show'}
                  </button>
                </div>
                <div className="relative">
                  <div className="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <Lock className="w-4 h-4" />
                  </div>
                  <input
                    type={showPassword ? 'text' : 'password'}
                    required
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="Enter password"
                    className={`w-full pl-10 pr-3.5 py-2.5 rounded-xl border text-sm transition-all focus:outline-none focus:ring-2 focus:ring-blue-500 ${
                      isLight 
                        ? 'bg-slate-50 border-slate-200 text-slate-900 focus:bg-white' 
                        : 'bg-slate-950 border-slate-800 text-slate-100 focus:bg-slate-900'
                    }`}
                  />
                </div>
              </div>

              <button
                type="submit"
                disabled={loading}
                className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white font-bold text-sm shadow-lg shadow-blue-500/25 flex items-center justify-center gap-2 cursor-pointer transition-all duration-200 disabled:opacity-50 hover:scale-[1.01]"
              >
                {loading ? (
                  <>
                    <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                    <span>Authenticating...</span>
                  </>
                ) : (
                  <>
                    <span>Sign In to RMS Portal</span>
                    <ArrowRight className="w-4 h-4" />
                  </>
                )}
              </button>
            </form>
          </div>

          {/* Academic Info Tag */}
          <div className="text-center space-y-1 text-slate-500 text-xs">
            <p className="font-semibold text-slate-400">
              SLIIT Software Engineering Frameworks (SE3090)
            </p>
            <p className="text-[11px]">
              Group: <strong className="text-slate-300">SEF_KDY_AI_04</strong> • Specialization: AI (Batch 1)
            </p>
          </div>
        </div>
      </main>

      {/* Footer */}
      <footer className="px-6 py-3 text-center text-xs text-slate-500 border-t border-slate-200/50 dark:border-slate-800/50">
        Rental Management System • Full-Stack & LangGraph Agentic AI Enterprise Platform © 2026
      </footer>
    </div>
  );
};
