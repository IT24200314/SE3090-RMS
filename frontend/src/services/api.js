// =================================================================================================
// File: api.js
// Module: Frontend Service Layer - Centralized Axios API Client
// Purpose: Provides unified HTTP client configuration and endpoint methods connecting the React 19
//          Admin Dashboard directly to the ASP.NET Core Web API (Port 5000) for all 3 components.
// =================================================================================================

import axios from 'axios';

// Base URL configured from environment variable (defaults to local ASP.NET Core Web API port 5000)
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

// Create pre-configured Axios instance with JSON headers
export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// =================================================================================================
// Component A: Property & Lease Lifecycle Services (Upamada Ekanayake)
// =================================================================================================
export const propertyService = {
  // Fetches paginated properties with optional text search filter
  getProperties: (search = '', page = 1, pageSize = 10) => 
    api.get(`/properties?search=${encodeURIComponent(search)}&page=${page}&pageSize=${pageSize}`),

  // Registers a new property unit listing
  createProperty: (data) => 
    api.post('/properties', data),

  // Drafts a new lease contract and sets property status to Occupied
  createLease: (data) => 
    api.post('/leases', data),

  // Executes early lease termination state machine and reverts property back to Available
  terminateLease: (id, reason) => 
    api.put(`/leases/${id}/terminate`, { terminationReason: reason }),
};

// =================================================================================================
// Component B: Tenant Screening & Onboarding Services (Nethmi Seya)
// =================================================================================================
export const tenantService = {
  // Retrieves tenant applications filtered by optional screening status
  getApplications: (status) => 
    api.get(`/tenants/applications${status !== undefined ? `?status=${status}` : ''}`),

  // Fetches a single tenant application dossier by ID
  getApplicationById: (id) => 
    api.get(`/tenants/applications/${id}`),

  // Submits a prospective tenant rental application
  submitApplication: (data) => 
    api.post('/tenants/applications', data),

  // Updates verified identity KYC document URLs (e.g. NIC or Passport photo)
  verifyDocument: (id, data) => 
    api.post(`/tenants/applications/${id}/verify-docs`, data),

  // Triggers mathematical debt-to-income risk scoring calculation (<=35%, 35-50%, >50%)
  evaluateRisk: (id) => 
    api.post(`/tenants/applications/${id}/evaluate-risk`),
};

// =================================================================================================
// Component C: Maintenance & Work-Order Operations (Hashini Wicramathilake)
// =================================================================================================
export const maintenanceService = {
  // Queries maintenance tickets filtered by status and urgency priority
  getTickets: (status, priority) => {
    const params = new URLSearchParams();
    if (status !== undefined && status !== '') params.append('status', status);
    if (priority !== undefined && priority !== '') params.append('priority', priority);
    return api.get(`/maintenance/tickets?${params.toString()}`);
  },

  // Retrieves ticket details by unique identifier
  getTicketById: (id) => 
    api.get(`/maintenance/tickets/${id}`),

  // Creates a tenant-reported maintenance ticket
  createTicket: (data) => 
    api.post('/maintenance/tickets', data),

  // Assigns a licensed contractor and sets approved budget ceiling
  assignContractor: (id, data) => 
    api.put(`/maintenance/tickets/${id}/assign`, data),

  // Marks ticket as resolved with final invoice cost and resolution summary
  completeTicket: (id, data) => 
    api.put(`/maintenance/tickets/${id}/complete`, data),

  // Triggers automated trade categorization and LKR 50K Human-in-the-Loop policy ceiling check
  triageAndEstimate: (id) => 
    api.post(`/maintenance/tickets/${id}/triage-and-estimate`),
};

// =================================================================================================
// Section 11: Third-Party Integration Services (Currency & Geocoding)
// =================================================================================================
export const externalService = {
  // Converts LKR rental amount to foreign currency (USD, EUR, GBP) via ASP.NET Core backend proxy
  convertCurrency: (amountLkr, targetCurrency = 'USD') =>
    api.post('/external/currency/convert', { amountLkr: Number(amountLkr), targetCurrency }),

  // Reverse geocodes mobile GPS coordinates to verify physical location within Sri Lanka
  reverseGeocode: (latitude, longitude) =>
    api.post('/external/location/reverse-geocode', { latitude: Number(latitude), longitude: Number(longitude) }),
};

