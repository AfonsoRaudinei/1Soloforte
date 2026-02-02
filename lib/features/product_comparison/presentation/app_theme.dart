import 'package:flutter/material.dart';

class AppColors {
  // Cores Primárias
  static const iosBlue = Color(0xFF007AFF);
  static const iosBlueDark = Color(0xFF0051D5);
  static const white = Color(0xFFFFFFFF);
  static const backgroundLight = Color(0xFFF5F5F7);
  static const backgroundDark = Color(0xFFE5E5E7);
  
  // Cores de Texto
  static const textPrimary = Color(0xFF1D1D1F);
  static const textSecondary = Color(0xFF86868B);
  static const textTertiary = Color(0xFFC7C7CC);
  
  // Cores de Estado
  static const success = Color(0xFF34C759);
  static const error = Color(0xFFFF3B30);
  static const successBg = Color(0xFFE8F5E9);
  static const errorBg = Color(0xFFFFEBEE);
  
  // Bordas
  static const border = Color(0xFFD1D1D6);
  static const borderLight = Color(0xFFE5E5E7);
}

class AppTypography {
  static const fontFamily = '-apple-system'; // ou 'SF Pro Display'
  
  static const sectionTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    fontFamily: fontFamily,
  );
  
  static const bodyText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
  
  static const roiValue = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: fontFamily,
  );
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
}

class AppRadius {
  static const small = BorderRadius.all(Radius.circular(6));
  static const medium = BorderRadius.all(Radius.circular(8));
  static const large = BorderRadius.all(Radius.circular(12));
  static const xlarge = BorderRadius.all(Radius.circular(16));
  static const round = BorderRadius.all(Radius.circular(999));
}

class AppShadows {
  static const card = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      offset: Offset(0, 1),
      blurRadius: 3,
    ),
    BoxShadow(
      color: Color(0x0A000000), // rgba(0,0,0,0.04)
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];
  
  static const floating = [
    BoxShadow(
      color: Color(0x66007AFF), // rgba(0,122,255,0.4)
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];
}
