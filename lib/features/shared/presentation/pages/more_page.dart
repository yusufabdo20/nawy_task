import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/core/services/language_service.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  @override
  void initState() {
    super.initState();
    // Initialize services
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.more.tr()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings Section
            _buildSectionTitle(AppStrings.settings.tr()),
            SizedBox(height: 16.h),
            
            // Language Settings
            _buildLanguageSettings(),
            SizedBox(height: 24.h),
            
           
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildLanguageSettings() {
    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              _buildListTile(
                icon: Icons.language,
                title: AppStrings.language.tr(),
                subtitle: languageService.getLanguageName(
                  languageService.currentLocale.languageCode,
                ),
                trailing: Text(
                  languageService.getLanguageFlag(
                    languageService.currentLocale.languageCode,
                  ),
                  style: TextStyle(fontSize: 20.sp),
                ),
                onTap: () => _showLanguageDialog(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
        size: 24.w,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      trailing: trailing ?? Icon(
        Icons.arrow_forward_ios,
        size: 16.w,
        color: Theme.of(context).textTheme.bodyMedium?.color,
      ),
      onTap: onTap,
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => Consumer<LanguageService>(
        builder: (context, languageService, child) {
          return AlertDialog(
            title: Text(AppStrings.select_language.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: languageService.supportedLocales.map((locale) {
                final isSelected = languageService.currentLocale.languageCode ==
                    locale.languageCode;
                return ListTile(
                  leading: Text(
                    languageService.getLanguageFlag(locale.languageCode),
                    style: TextStyle(fontSize: 24.sp),
                  ),
                  title: Text(
                    languageService.getLanguageName(locale.languageCode),
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                  onTap: () async {
                    await languageService.setLanguage(locale);
                    if (mounted) {
                      await context.setLocale(locale);
                      Navigator.of(context).pop();
                    }
                  },
                );
              }).toList(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppStrings.cancel.tr()),
              ),
            ],
          );
        },
      ),
    );
  }


}