// =================================================================================================
// File: AddPropertyModal.jsx
// Module: Component A: Property Listing & Lease Lifecycle Management
// Student Contributor: Upamada Ekanayake (Group Leader - IT24200314)
// Architecture: Frontend Layer - React 19 Modal for Real-Estate Inventory Registration
// Purpose: Collects verified property listing parameters, validates inputs, and dispatches
//          POST /api/properties to persist listings directly in PostgreSQL / EF Core storage.
// =================================================================================================

import React, { useState } from 'react';
import { X, Building2, MapPin, DollarSign, Bed, Home, AlertCircle, CheckCircle2 } from 'lucide-react';
import { propertyService } from '../../services/api.js';
import { useToast } from '../common/Toast.jsx';

export const AddPropertyModal = ({ isOpen, onClose, onPropertyCreated }) => {
  const { addToast } = useToast();
  const [formData, setFormData] = useState({
    title: '',
    address: '',
    monthlyRent: '',
    securityDeposit: '',
    bedrooms: '3',
    propertyType: 'Apartment',
    description: '',
  });

  const [errors, setErrors] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  if (!isOpen) return null;

  const validate = () => {
    const errs = {};
    if (!formData.title.trim()) errs.title = 'Property title is required';
    if (!formData.address.trim()) errs.address = 'Street address is required';
    
    const rent = parseFloat(formData.monthlyRent);
    if (isNaN(rent) || rent <= 0) {
      errs.monthlyRent = 'Please enter a valid monthly rent greater than 0';
    }

    const deposit = parseFloat(formData.securityDeposit);
    if (isNaN(deposit) || deposit < 0) {
      errs.securityDeposit = 'Please enter a valid security deposit amount';
    }

    if (!formData.description.trim()) {
      errs.description = 'Property description is required';
    }

    setErrors(errs);
    return Object.keys(errs).length === 0;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!validate()) return;

    setIsSubmitting(true);
    try {
      const payload = {
        title: formData.title.trim(),
        address: formData.address.trim(),
        monthlyRent: parseFloat(formData.monthlyRent),
        securityDeposit: parseFloat(formData.securityDeposit),
        description: `${formData.description.trim()} (${formData.bedrooms} Bedrooms, ${formData.propertyType})`,
        landlordId: '8f9e0a1b-2c3d-4e5f-6a7b-8c9d0e1f2a3b'
      };

      const res = await propertyService.createProperty(payload);
      addToast('Property listing created successfully and published to inventory!', 'success');
      
      if (onPropertyCreated) {
        onPropertyCreated(res.data);
      }
      onClose();
    } catch (err) {
      console.error('Error creating property:', err);
      addToast(err.response?.data?.message || 'Failed to create property. Check API connectivity.', 'error');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-xs animate-in fade-in duration-150">
      <div 
        className="w-full max-w-xl bg-slate-900 border border-slate-800 rounded-2xl shadow-2xl overflow-hidden text-slate-100 animate-in zoom-in-95 duration-200"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Modal Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-slate-800 bg-slate-950/60">
          <div className="flex items-center gap-3">
            <div className="p-2 rounded-xl bg-blue-600/10 border border-blue-500/20 text-blue-400">
              <Building2 className="w-5 h-5" />
            </div>
            <div>
              <h2 className="text-base font-bold text-white tracking-tight">Add New Property Listing</h2>
              <p className="text-xs text-slate-400">Component A (Upamada) — Register unit into rental inventory</p>
            </div>
          </div>
          <button 
            onClick={onClose}
            className="p-1.5 text-slate-400 hover:text-white rounded-lg hover:bg-slate-800 transition-colors cursor-pointer"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Modal Form */}
        <form onSubmit={handleSubmit} className="p-6 space-y-4">
          {/* Title */}
          <div>
            <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
              Property Marketing Title *
            </label>
            <input
              type="text"
              placeholder="e.g. Lotus Tower View Luxury Suite"
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className={`w-full px-3.5 py-2.5 rounded-xl bg-slate-950 border text-sm text-slate-100 placeholder-slate-500 focus:outline-hidden focus:ring-2 focus:ring-blue-500 transition-all ${
                errors.title ? 'border-red-500' : 'border-slate-800 focus:border-blue-500'
              }`}
            />
            {errors.title && <p className="mt-1 text-xs text-red-400 flex items-center gap-1"><AlertCircle className="w-3.5 h-3.5" />{errors.title}</p>}
          </div>

          {/* Address */}
          <div>
            <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
              Civic Street Address (Sri Lanka) *
            </label>
            <div className="relative">
              <MapPin className="w-4 h-4 text-slate-500 absolute left-3.5 top-3" />
              <input
                type="text"
                placeholder="e.g. 55 Galle Road, Colombo 03"
                value={formData.address}
                onChange={(e) => setFormData({ ...formData, address: e.target.value })}
                className={`w-full pl-10 pr-3.5 py-2.5 rounded-xl bg-slate-950 border text-sm text-slate-100 placeholder-slate-500 focus:outline-hidden focus:ring-2 focus:ring-blue-500 transition-all ${
                  errors.address ? 'border-red-500' : 'border-slate-800 focus:border-blue-500'
                }`}
              />
            </div>
            {errors.address && <p className="mt-1 text-xs text-red-400 flex items-center gap-1"><AlertCircle className="w-3.5 h-3.5" />{errors.address}</p>}
          </div>

          {/* Monetary Inputs: Rent & Deposit */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
                Monthly Rent (LKR) *
              </label>
              <div className="relative">
                <span className="text-xs font-bold text-slate-500 absolute left-3.5 top-3">LKR</span>
                <input
                  type="number"
                  placeholder="250000"
                  value={formData.monthlyRent}
                  onChange={(e) => {
                    const rentVal = e.target.value;
                    const numRent = parseFloat(rentVal) || 0;
                    setFormData({ 
                      ...formData, 
                      monthlyRent: rentVal,
                      // Automatically suggest 2-month security deposit standard
                      securityDeposit: formData.securityDeposit ? formData.securityDeposit : (numRent * 2).toString()
                    });
                  }}
                  className={`w-full pl-12 pr-3.5 py-2.5 rounded-xl bg-slate-950 border text-sm text-slate-100 placeholder-slate-500 focus:outline-hidden focus:ring-2 focus:ring-blue-500 transition-all ${
                    errors.monthlyRent ? 'border-red-500' : 'border-slate-800 focus:border-blue-500'
                  }`}
                />
              </div>
              {errors.monthlyRent && <p className="mt-1 text-xs text-red-400 flex items-center gap-1"><AlertCircle className="w-3.5 h-3.5" />{errors.monthlyRent}</p>}
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
                Security Deposit (LKR) *
              </label>
              <div className="relative">
                <span className="text-xs font-bold text-slate-500 absolute left-3.5 top-3">LKR</span>
                <input
                  type="number"
                  placeholder="500000"
                  value={formData.securityDeposit}
                  onChange={(e) => setFormData({ ...formData, securityDeposit: e.target.value })}
                  className={`w-full pl-12 pr-3.5 py-2.5 rounded-xl bg-slate-950 border text-sm text-slate-100 placeholder-slate-500 focus:outline-hidden focus:ring-2 focus:ring-blue-500 transition-all ${
                    errors.securityDeposit ? 'border-red-500' : 'border-slate-800 focus:border-blue-500'
                  }`}
                />
              </div>
              {errors.securityDeposit && <p className="mt-1 text-xs text-red-400 flex items-center gap-1"><AlertCircle className="w-3.5 h-3.5" />{errors.securityDeposit}</p>}
            </div>
          </div>

          {/* Property Specifications: Type & Bedrooms */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div>
              <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
                Property Architecture Type
              </label>
              <select
                value={formData.propertyType}
                onChange={(e) => setFormData({ ...formData, propertyType: e.target.value })}
                className="w-full px-3.5 py-2.5 rounded-xl bg-slate-950 border border-slate-800 text-sm text-slate-100 focus:outline-hidden focus:ring-2 focus:ring-blue-500"
              >
                <option value="Apartment">Luxury Apartment</option>
                <option value="Villa">Detached Villa / Townhouse</option>
                <option value="Studio">Studio Apartment</option>
                <option value="Penthouse">High-Rise Penthouse</option>
              </select>
            </div>

            <div>
              <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
                Bedrooms Count
              </label>
              <select
                value={formData.bedrooms}
                onChange={(e) => setFormData({ ...formData, bedrooms: e.target.value })}
                className="w-full px-3.5 py-2.5 rounded-xl bg-slate-950 border border-slate-800 text-sm text-slate-100 focus:outline-hidden focus:ring-2 focus:ring-blue-500"
              >
                <option value="1">1 Bedroom</option>
                <option value="2">2 Bedrooms</option>
                <option value="3">3 Bedrooms</option>
                <option value="4">4 Bedrooms</option>
                <option value="5+">5+ Bedrooms</option>
              </select>
            </div>
          </div>

          {/* Description */}
          <div>
            <label className="block text-xs font-semibold text-slate-300 uppercase tracking-wider mb-1.5">
              Comprehensive Description *
            </label>
            <textarea
              rows={3}
              placeholder="Provide architectural highlights, amenities (gym, swimming pool, 24/7 security), and nearby transport links..."
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className={`w-full px-3.5 py-2.5 rounded-xl bg-slate-950 border text-sm text-slate-100 placeholder-slate-500 focus:outline-hidden focus:ring-2 focus:ring-blue-500 transition-all ${
                errors.description ? 'border-red-500' : 'border-slate-800 focus:border-blue-500'
              }`}
            />
            {errors.description && <p className="mt-1 text-xs text-red-400 flex items-center gap-1"><AlertCircle className="w-3.5 h-3.5" />{errors.description}</p>}
          </div>

          {/* Modal Actions */}
          <div className="flex items-center justify-end gap-3 pt-4 border-t border-slate-800">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-sm font-semibold text-slate-400 hover:text-white rounded-xl hover:bg-slate-800 transition-colors cursor-pointer"
            >
              Cancel
            </button>
            <button
              type="submit"
              disabled={isSubmitting}
              className="px-5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white rounded-xl text-sm font-bold shadow-lg shadow-blue-600/20 flex items-center gap-2 transition-all cursor-pointer disabled:opacity-50"
            >
              {isSubmitting ? (
                <>
                  <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                  <span>Persisting to Database...</span>
                </>
              ) : (
                <>
                  <Building2 className="w-4 h-4" />
                  <span>Create Property Listing</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
