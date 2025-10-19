import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Nawy Task';
  static const String appVersion = '1.0.0';

  // Local Storage Keys
  static const String favoritesKey = 'favorites';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;


  // Area Options (mock data)
  static const List<String> appBarTitles = [
    'explore',
    'updates',
    'favorites',
    'more',
  ];

  static const List<String> areaOptions = [];

  // Compound Options (mock data)
  static const List<String> compoundOptions = [
    'New Cairo',
    'Sheikh Zayed',
    'Rehab City',
    '6th October',
    'Madinaty',
    'Al Rehab',
    'Palm Hills',
    'SODIC',
    'Emaar',
    'Talaat Moustafa',
  ];

  // Property Types
  static const List<String> propertyTypes = [
    'apartment',
    'villa',
    'townhouse',
    'duplex',
    'penthouse',
    'studio',
  ];

  // Supported Languages
  static const List<String> supportedLanguages = ['en', 'ar'];
  static const String defaultLanguage = 'en';

  // Locales helper
  // Use AppConstants.locales where a List<Locale> is required (e.g. EasyLocalization)
  static const List<String> _localeStrings = supportedLanguages;
  static List<Locale> get locales =>
      _localeStrings.map((l) => Locale(l)).toList();

  // Themes
  static const List<String> themes = ['light', 'dark', 'system'];
  static const String defaultTheme = 'system';
}
