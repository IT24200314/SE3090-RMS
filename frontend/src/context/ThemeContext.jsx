// =================================================================================================
// File: ThemeContext.jsx
// Module: Frontend Context Layer - Theme Management (Light / Dark AppFolio Slate)
// Purpose: Provides application-wide theme state management with localStorage persistence and
//          automatic HTML document root class toggling (dark/light) for Tailwind CSS v4 styling.
// =================================================================================================

import React, { createContext, useContext, useState, useEffect } from 'react';

// Initialize context with default light theme and no-op mutation handles
const ThemeContext = createContext({
  theme: 'light',
  toggleTheme: () => {},
  setTheme: () => {}
});

export const ThemeProvider = ({ children }) => {
  // Initialize theme from localStorage if previously chosen, or default to clean light mode
  const [theme, setTheme] = useState(() => {
    const saved = localStorage.getItem('rms_theme');
    return saved ? saved : 'light';
  });

  // Synchronize active theme with browser localStorage and document root classes
  useEffect(() => {
    localStorage.setItem('rms_theme', theme);
    const root = document.documentElement;
    if (theme === 'dark') {
      root.classList.add('dark');
      root.classList.remove('light');
    } else {
      root.classList.add('light');
      root.classList.remove('dark');
    }
  }, [theme]);

  // Toggles between light and dark modes
  const toggleTheme = () => {
    setTheme(prev => (prev === 'light' ? 'dark' : 'light'));
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme, setTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

// Custom hook providing access to current theme and toggle handler
export const useTheme = () => useContext(ThemeContext);
