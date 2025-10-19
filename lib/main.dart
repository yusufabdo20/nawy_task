import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:nawy_task/core/constants/app_strings.dart';
import 'package:nawy_task/core/di/injection_container.dart';
import 'package:nawy_task/features/explore/presentation/bloc/explore_bloc.dart';
import 'package:nawy_task/features/shared/presentation/pages/home_layout_page.dart';
import 'package:nawy_task/features/favorites/presentation/services/favorites_service.dart';
import 'package:nawy_task/core/services/language_service.dart';
import 'package:nawy_task/features/shared/presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDependencies();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/langs',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => sl<ExploreBloc>(),
          ),
          ChangeNotifierProvider(
            create: (context) => sl<FavoritesService>(),
          ),
          ChangeNotifierProvider(
            create: (context) => sl<LanguageService>(),
          ),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Consumer<LanguageService>(
          builder: (context, languageService, child) {
            return MaterialApp(
              title: AppStrings.appName,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: languageService.currentLocale,
              theme: AppTheme.theme,
              themeMode: ThemeMode.light,
              home: const HomeLayoutPage(),
            );
          },
        );
      },
    );
  }
}
