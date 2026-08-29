import React from 'react';
import { MapPin, FileText, XCircle, Calendar, ShieldCheck, Home, Bed, Bath, Square, Sparkles } from 'lucide-react';
import { useTheme } from '../../context/ThemeContext';

const PROPERTY_PHOTOS = {
  'Oceanfront': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=800&q=80',
  'Cinnamon': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
  'Havelock': 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80',
  'Rajagiriya': 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80'
};

export const PropertyCard = ({ property, onDraftLease, onTerminateLease }) => {
  const { theme } = useTheme();
  const isLight = theme === 'light';

  const getStatusBadge = (status) => {
    switch (status) {
      case 0:
      case 'Available':
        return (
          <span className={`px-2.5 py-1 rounded-full text-[10px] font-semibold border flex items-center gap-1.5 shadow-xs ${
            isLight 
              ? 'bg-emerald-50 text-emerald-700 border-emerald-200' 
              : 'bg-emerald-500/10 text-emerald-400 border-emerald-500/25'
          }`}>
            <span className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse"></span> Available
          </span>
        );
      case 1:
      case 'Occupied':
        return (
          <span className={`px-2.5 py-1 rounded-full text-[10px] font-semibold border flex items-center gap-1.5 shadow-xs ${
            isLight 
              ? 'bg-blue-50 text-blue-700 border-blue-200' 
              : 'bg-blue-500/10 text-blue-400 border-blue-500/25'
          }`}>
            <span className="w-1.5 h-1.5 rounded-full bg-blue-500"></span> Occupied
          </span>
        );
      case 2:
      case 'UnderMaintenance':
        return (
          <span className={`px-2.5 py-1 rounded-full text-[10px] font-semibold border flex items-center gap-1.5 shadow-xs ${
            isLight 
              ? 'bg-amber-50 text-amber-700 border-amber-200' 
              : 'bg-amber-500/10 text-amber-400 border-amber-500/25'
          }`}>
            <span className="w-1.5 h-1.5 rounded-full bg-amber-500"></span> Maintenance
          </span>
        );
      default:
        return (
          <span className={`px-2.5 py-1 rounded-full text-[10px] font-semibold border ${
            isLight ? 'bg-slate-100 text-slate-600 border-slate-200' : 'bg-slate-500/10 text-slate-400 border-slate-500/20'
          }`}>
            Inactive
          </span>
        );
    }
  };

  const isAvailable = property.status === 0 || property.status === 'Available';
  const isOccupied = property.status === 1 || property.status === 'Occupied';

  // Match photo based on title
  const getPhotoUrl = () => {
    for (const key of Object.keys(PROPERTY_PHOTOS)) {
      if (property.title.includes(key)) return PROPERTY_PHOTOS[key];
    }
    return PROPERTY_PHOTOS['Oceanfront'];
  };

  return (
    <div 
      data-testid="property-card" 
      className={`rounded-2xl border transition-all duration-200 flex flex-col justify-between overflow-hidden group ${
        isLight 
          ? 'bg-white border-slate-200/90 hover:border-blue-400/80 shadow-[0_1px_3px_rgba(15,23,42,0.04),0_10px_20px_-5px_rgba(15,23,42,0.02)] hover:shadow-xl hover:-translate-y-0.5' 
          : 'bg-slate-900/80 border-slate-800/80 hover:border-blue-500/40 shadow-lg'
      }`}
    >
      <div>
        {/* Real Luxury Photo Header with Badges */}
        <div className="h-44 relative overflow-hidden bg-slate-900">
          <img 
            src={getPhotoUrl()} 
            alt={property.title}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" 
          />
          <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
          
          <div className="absolute top-3 left-3 right-3 flex items-start justify-between">
            <span className="text-[10px] font-semibold uppercase tracking-wider px-2.5 py-1 rounded-full bg-black/60 border border-white/20 text-white backdrop-blur-md">
              Residential Portfolio
            </span>
            {getStatusBadge(property.status)}
          </div>
          
          <div className="absolute bottom-3 left-3 right-3 flex items-center justify-between text-white">
            <div className="flex items-center gap-1.5">
              <Home className="w-4 h-4 text-blue-400" />
              <span className="text-sm font-bold truncate drop-shadow-md">{property.title}</span>
            </div>
            <span className="text-xs font-mono font-bold text-emerald-400 bg-black/50 px-2 py-0.5 rounded backdrop-blur-sm">
              LKR {(Number(property.monthlyRent) / 1000).toFixed(0)}k/mo
            </span>
          </div>
        </div>

        {/* Content Body */}
        <div className="p-4">
          <p className={`text-[11px] flex items-center gap-1.5 mb-2 truncate ${
            isLight ? 'text-slate-500' : 'text-slate-400'
          }`}>
            <MapPin className="w-3.5 h-3.5 text-blue-600 flex-shrink-0" />
            {property.address}
          </p>

          <p className={`text-[11px] line-clamp-2 mb-3 leading-relaxed ${
            isLight ? 'text-slate-600' : 'text-slate-300'
          }`}>
            {property.description}
          </p>

          {/* Amenity Badges */}
          <div className="flex items-center gap-2 mb-3.5">
            <span className={`px-2 py-0.5 rounded-md text-[10px] font-medium border flex items-center gap-1 ${
              isLight ? 'bg-slate-50 text-slate-600 border-slate-200' : 'bg-slate-800/80 text-slate-300 border-slate-700'
            }`}>
              <Bed className="w-3 h-3 text-slate-400" /> 3 Beds
            </span>
            <span className={`px-2 py-0.5 rounded-md text-[10px] font-medium border flex items-center gap-1 ${
              isLight ? 'bg-slate-50 text-slate-600 border-slate-200' : 'bg-slate-800/80 text-slate-300 border-slate-700'
            }`}>
              <Bath className="w-3 h-3 text-slate-400" /> 2 Baths
            </span>
            <span className={`px-2 py-0.5 rounded-md text-[10px] font-medium border flex items-center gap-1 ${
              isLight ? 'bg-slate-50 text-slate-600 border-slate-200' : 'bg-slate-800/80 text-slate-300 border-slate-700'
            }`}>
              <Square className="w-3 h-3 text-slate-400" /> 1,850 sqft
            </span>
          </div>

          {/* Financial Metric Box */}
          <div className={`grid grid-cols-2 gap-2 p-2.5 rounded-xl border mb-3 ${
            isLight 
              ? 'bg-slate-50/80 border-slate-200/80' 
              : 'bg-slate-950/90 border-slate-800/80'
          }`}>
            <div>
              <span className={`text-[9px] font-semibold block uppercase tracking-wider ${
                isLight ? 'text-slate-500' : 'text-slate-400'
              }`}>
                Monthly Rent
              </span>
              <span className="text-xs font-bold text-emerald-600 font-mono">
                LKR {Number(property.monthlyRent).toLocaleString()}
              </span>
            </div>
            <div>
              <span className={`text-[9px] font-semibold block uppercase tracking-wider ${
                isLight ? 'text-slate-500' : 'text-slate-400'
              }`}>
                Security Deposit
              </span>
              <span className={`text-xs font-bold font-mono ${
                isLight ? 'text-slate-700' : 'text-slate-200'
              }`}>
                LKR {Number(property.securityDeposit).toLocaleString()}
              </span>
            </div>
          </div>

          {/* Lease Term / Expiry Countdown Pill */}
          <div className={`flex items-center justify-between px-2.5 py-1.5 rounded-lg border text-[11px] ${
            isLight ? 'bg-slate-100/70 border-slate-200 text-slate-700' : 'bg-slate-800/50 border-slate-800 text-slate-300'
          }`}>
            <div className="flex items-center gap-1.5">
              <Calendar className="w-3.5 h-3.5 text-slate-400" />
              <span className={`text-[10px] font-medium ${isLight ? 'text-slate-500' : 'text-slate-400'}`}>
                Lease Status:
              </span>
            </div>
            {isOccupied ? (
              <span className="font-semibold text-blue-600 text-[10px] font-mono">
                Active (118 days left)
              </span>
            ) : isAvailable ? (
              <span className="font-semibold text-emerald-600 text-[10px]">
                Immediate Move-in
              </span>
            ) : (
              <span className="font-semibold text-amber-600 text-[10px]">
                Inspection in Progress
              </span>
            )}
          </div>
        </div>
      </div>

      {/* Action Footer */}
      <div className={`px-4 py-3 border-t flex items-center gap-2 ${
        isLight ? 'bg-slate-50/70 border-slate-100' : 'bg-slate-950/50 border-slate-800/80'
      }`}>
        {isAvailable ? (
          <button
            onClick={() => onDraftLease(property)}
            className="flex-1 py-2 px-3 rounded-xl bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold flex items-center justify-center gap-1.5 transition-all shadow-sm active:scale-[0.98] cursor-pointer"
          >
            <FileText className="w-3.5 h-3.5" />
            Draft Lease Agreement
          </button>
        ) : isOccupied ? (
          <button
            onClick={() => onTerminateLease(property)}
            className={`flex-1 py-2 px-3 rounded-xl border text-xs font-semibold flex items-center justify-center gap-1.5 transition-all active:scale-[0.98] cursor-pointer ${
              isLight 
                ? 'bg-rose-50 hover:bg-rose-100 text-rose-700 border-rose-200' 
                : 'bg-rose-500/10 hover:bg-rose-500/20 text-rose-400 border-rose-500/30'
            }`}
          >
            <XCircle className="w-3.5 h-3.5" />
            Early Termination
          </button>
        ) : (
          <button
            disabled
            className={`flex-1 py-2 px-3 rounded-xl text-xs font-medium cursor-not-allowed border ${
              isLight ? 'bg-slate-100 text-slate-400 border-slate-200' : 'bg-slate-900 text-slate-500 border-slate-800'
            }`}
          >
            Unavailable
          </button>
        )}
      </div>
    </div>
  );
};
