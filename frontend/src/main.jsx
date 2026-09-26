// =================================================================================================
// File: main.jsx
// Module: Frontend Entrypoint - React 19 Client Root Bootstrap
// Purpose: Mounts the React application tree into the HTML DOM root element (#root), initializes
//          global Tailwind CSS styles, and enables React StrictMode for development audits.
// =================================================================================================

import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App.jsx';

// 1. Locate the DOM root container element defined in index.html
const rootElement = document.getElementById('root');

// 2. Initialize the concurrent React root and render App inside StrictMode
createRoot(rootElement).render(
  <StrictMode>
    {/* Mount the primary Rental Management System (RMS) application */}
    <App />
  </StrictMode>,
);
