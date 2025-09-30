// Primary Colors
import 'dart:ui';

import 'package:flutter/cupertino.dart';

const Color kPrimary = Color(0xFF2E7D32); // Deep Green
const Color kPrimaryLight = Color(0xFF60AD5E); // Light Green
const Color kPrimaryDark = Color(0xFF005005); // Dark Green

// Accent / Secondary Colors
const Color kAccent = Color(0xFF00897B); // Teal
const Color kAccentLight = Color(0xFF4EBAAA);
const Color kAccentDark = Color(0xFF005B4F);

// Neutral Colors
const Color kBackground = Color(0xFFF1F8F6); // Soft Background Greenish-White
const Color kCardBackground = Color(0xFFFFFFFF); // White for cards
const Color kTextPrimary = Color(0xFF1B1B1B); // Dark text
const Color kTextSecondary = Color(0xFF5F6368); // Gray text

// Error / Warning
const Color kError = Color(0xFFD32F2F); // Red

//Gradient Example (For Buttons)
const LinearGradient kButtonGradient = LinearGradient(
  colors: [kPrimary, kAccent],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);
