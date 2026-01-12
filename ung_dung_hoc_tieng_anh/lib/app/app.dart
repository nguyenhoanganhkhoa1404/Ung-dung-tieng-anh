import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../core/constants/app_constants.dart';
import '../core/l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';
import '../presentation/bloc/auth/auth_bloc.dart';
import '../presentation/bloc/auth/auth_event.dart';
import '../src/config/app_config.dart';
import '../src/theme/app_theme.dart' as lingoflow;
import 'di.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box(AppConstants.settingsBox);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(AuthCheckRequested()),
        ),
      ],
      child: ValueListenableBuilder(
        valueListenable: settingsBox.listenable(
          keys: [
            AppConstants.keyThemeMode,
            AppConstants.keyLanguage,
          ],
        ),
        builder: (context, box, _) {
          final mode = (box.get(AppConstants.keyThemeMode) ?? 'light').toString();
          final themeMode = mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
          final languageCode =
              (box.get(AppConstants.keyLanguage) ?? 'vi').toString();
          final locale = Locale(languageCode);

          return MaterialApp(
            title: AppLocalizations(locale).t('app_title'),
            debugShowCheckedModeBanner: false,
            theme: AppConfig.useLingoFlowTheme
                ? lingoflow.LingoFlowTheme.lightTheme
                : AppTheme.lightTheme,
            darkTheme: AppConfig.useLingoFlowTheme
                ? lingoflow.LingoFlowTheme.darkTheme
                : AppTheme.darkTheme,
            themeMode: themeMode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            onGenerateRoute: AppRouter.onGenerateRoute,
            initialRoute: AppRouter.splash,
          );
        },
      ),
    );
  }
}

