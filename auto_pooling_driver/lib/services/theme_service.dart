import 'package:auto_pooling_driver/common/theme/app_theme.dart';
import 'package:flutter/material.dart';

abstract class ThemeService {
  ThemeData get lightTheme;
}

class ThemeServiceImpl implements ThemeService {
  @override
  ThemeData get lightTheme => AppTheme.lightTheme;
}
