import 'package:flutter/material.dart';

/// App-wide color definitions
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4A90E2);
  static const Color primaryDark = Color(0xFF2E5C8A);
  static const Color primaryLight = Color(0xFF7AB3F5);
  
  // Accent Colors
  static const Color accent = Color(0xFF50C878);
  static const Color accentDark = Color(0xFF2D8F4F);
  
  // Background Colors
  static const Color background = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color textWhite = Colors.white;
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);
  
  // Booking Status Colors
  static const Color pending = Color(0xFFF39C12);
  static const Color accepted = Color(0xFF3498DB);
  static const Color ongoing = Color(0xFF9B59B6);
  static const Color completed = Color(0xFF27AE60);
  static const Color cancelled = Color(0xFF95A5A6);
  static const Color rejected = Color(0xFFE74C3C);
  
  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFECF0F1);
  
  // Shadow
  static Color shadow = Colors.black.withOpacity(0.1);
}
