import 'package:flutter/material.dart';

/// MMDSmart Call Center Connect Color Palette
/// Primary: Orange | Neutral: White & Dark Gray
/// Sentiment: Green (Positive), Yellow (Neutral), Red (Negative)
abstract class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8F5C);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryContainer = Color(0xFFFFF0EB);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);
  
  // Dark Gray Scale
  static const Color darkGray = Color(0xFF2D3436);
  static const Color gray700 = Color(0xFF3D4449);
  static const Color gray600 = Color(0xFF545D64);
  static const Color gray500 = Color(0xFF6C757D);
  static const Color gray400 = Color(0xFF8B949C);
  static const Color gray300 = Color(0xFFADB5BD);
  static const Color gray200 = Color(0xFFDEE2E6);
  static const Color gray100 = Color(0xFFE9ECEF);

  // Sentiment Colors (AI-driven call health)
  static const Color sentimentPositive = Color(0xFF00C853);
  static const Color sentimentNeutral = Color(0xFFFFB300);
  static const Color sentimentNegative = Color(0xFFFF3D00);
  
  // Sentiment Backgrounds (softer for cards)
  static const Color sentimentPositiveBg = Color(0xFFE8F5E9);
  static const Color sentimentNeutralBg = Color(0xFFFFF8E1);
  static const Color sentimentNegativeBg = Color(0xFFFFEBEE);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFB300);
  static const Color error = Color(0xFFFF3D00);
  static const Color info = Color(0xFF2196F3);

  // Call Status Colors
  static const Color callActive = Color(0xFF00C853);
  static const Color callOnHold = Color(0xFFFFB300);
  static const Color callEnded = Color(0xFF6C757D);
  static const Color callMissed = Color(0xFFFF3D00);
  static const Color callIncoming = Color(0xFF2196F3);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Border & Divider
  static const Color border = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE9ECEF);

  // Overlay
  static const Color overlay = Color(0x80000000);
  static const Color shimmer = Color(0xFFE9ECEF);
}


