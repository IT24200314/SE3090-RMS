// =================================================================================================
// File: main.dart
// Module: Flutter Mobile Application Entrypoint & Material 3 Theme Configuration
// Student Contributors: Upamada Ekanayake, Nethmi Seya, Hashini Wicramathilake
// Architecture: Mobile Layer - Flutter 3.24+ Client with Material 3 Design Tokens
// Purpose: Configures root mobile application themes (Dark/Light AppFolio Slate), typography,
//          system navigation overlays, and mounts the primary HomeNavScreen shell.
// =================================================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_nav_screen.dart';
import 'screens/auth/login_screen.dart';
import 'services/auth_service.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RentalManagementApp());
}

class RentalManagementApp extends StatelessWidget {
  const RentalManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dark Theme Tokens (AppFolio Deep Slate)
    const darkBg = Color(0xFF09090B);
    const darkSurface = Color(0xFF0F172A);
    const darkElevated = Color(0xFF1E293B);
    const darkBorder = Color(0x1FFFFFFF);
    const royalBlue = Color(0xFF2563EB);
    const emeraldMint = Color(0xFF10B981);

    // Light Theme Tokens (AppFolio Clean Slate)
    const lightBg = Color(0xFFF8FAFC);
    const lightSurface = Color(0xFFFFFFFF);
    const lightElevated = Color(0xFFF1F5F9);
    const lightBorder = Color(0xFFE2E8F0);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, __) {
        final isLight = currentMode == ThemeMode.light;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: isLight ? lightBg : darkBg,
            systemNavigationBarIconBrightness: isLight ? Brightness.dark : Brightness.light,
          ),
        );

        return MaterialApp(
          title: 'RMS Mobile — AppFolio PropTech',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: lightBg,
            colorScheme: const ColorScheme.light(
              primary: royalBlue,
              surface: lightSurface,
              onSurface: Color(0xFF0F172A),
              secondary: emeraldMint,
            ),
            cardTheme: CardThemeData(
              color: lightSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: lightBorder, width: 1),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: lightSurface,
              elevation: 0,
              centerTitle: false,
              scrolledUnderElevation: 0,
              titleTextStyle: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              iconTheme: IconThemeData(color: Color(0xFF64748B)),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: lightSurface,
              elevation: 0,
              indicatorColor: const Color(0x1A2563EB),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Color(0xFF1E293B),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  );
                }
                return const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: royalBlue, size: 22);
                }
                return const IconThemeData(color: Color(0xFF64748B), size: 22);
              }),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: lightElevated,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: lightBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: lightBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: royalBlue, width: 1.5),
              ),
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
              labelStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: const Color(0xFF1E293B),
              contentTextStyle: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: darkBg,
            colorScheme: const ColorScheme.dark(
              primary: royalBlue,
              surface: darkSurface,
              onSurface: Color(0xFFF8FAFC),
              secondary: emeraldMint,
            ),
            cardTheme: CardThemeData(
              color: darkSurface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: darkBorder, width: 1),
              ),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: darkBg,
              elevation: 0,
              centerTitle: false,
              scrolledUnderElevation: 0,
              titleTextStyle: TextStyle(
                color: Color(0xFFF8FAFC),
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
              iconTheme: IconThemeData(color: Color(0xFF94A3B8)),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: darkBg,
              elevation: 0,
              indicatorColor: const Color(0x292563EB),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    color: Color(0xFFF8FAFC),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  );
                }
                return const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                );
              }),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const IconThemeData(color: Color(0xFF60A5FA), size: 22);
                }
                return const IconThemeData(color: Color(0xFF64748B), size: 22);
              }),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: darkElevated,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: darkBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: darkBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: royalBlue, width: 1.5),
              ),
              hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: royalBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: darkElevated,
              contentTextStyle: const TextStyle(color: Color(0xFFF8FAFC), fontSize: 12, fontWeight: FontWeight.w500),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: darkBorder),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          ),
          home: const AuthGate(),
        );
      },
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _checking = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  void _checkSession() async {
    final user = await AuthService.loadSession();
    if (!mounted) return;
    setState(() {
      _checking = false;
      _isAuthenticated = user != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_isAuthenticated) {
      return const HomeNavScreen();
    }
    return LoginScreen(
      onLoginSuccess: () {
        setState(() => _isAuthenticated = true);
      },
    );
  }
}

