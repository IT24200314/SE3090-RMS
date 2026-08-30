import axios from 'axios';

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000/api';

export const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Property & Lease Services (Upamada - Component A)
export const propertyService = {
  getProperties: (search = '', page = 1, pageSize = 10) => 
    api.get(`/properties?search=${encodeURIComponent(search)}&page=${page}&pageSize=${pageSize}`),
  createProperty: (data) => 
    api.post('/properties', data),
  createLease: (data) => 
    api.post('/leases', data),
  terminateLease: (id, reason) => 
    api.put(`/leases/${id}/terminate`, { terminationReason: reason }),
};

// Tenant Screening Services (Nethmi - Component B)
export const tenantService = {
  getApplications: (status) => 
    api.get(`/tenants/applications${status !== undefined ? `?status=${status}` : ''}`),
  getApplicationById: (id) => 
    api.get(`/tenants/applications/${id}`),
  submitApplication: (data) => 
    api.post('/tenants/applications', data),
  verifyDocument: (id, data) => 
    api.post(`/tenants/applications/${id}/verify-docs`, data),
  evaluateRisk: (id) => 
    api.post(`/tenants/applications/${id}/evaluate-risk`),
};

// Maintenance Services (Hashini - Component C)
export const maintenanceService = {
  getTickets: (status, priority) => {
    const params = new URLSearchParams();
    if (status !== undefined && status !== '') params.append('status', status);
    if (priority !== undefined && priority !== '') params.append('priority', priority);
    return api.get(`/maintenance/tickets?${params.toString()}`);
  },
  getTicketById: (id) => 
    api.get(`/maintenance/tickets/${id}`),
  createTicket: (data) => 
    api.post('/maintenance/tickets', data),
  assignContractor: (id, data) => 
    api.put(`/maintenance/tickets/${id}/assign`, data),
  completeTicket: (id, data) => 
    api.put(`/maintenance/tickets/${id}/complete`, data),
  triageAndEstimate: (id) => 
    api.post(`/maintenance/tickets/${id}/triage-and-estimate`),
};
