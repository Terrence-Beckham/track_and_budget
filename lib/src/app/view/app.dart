import 'package:ads_repo/ads_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_repo/settings_repo.dart';
import 'package:transactions_repository/transactions_repository.dart';

import '../../home/view/home_page.dart';

class App extends StatelessWidget {
  const App({
    required TransactionsRepo transactionsRepository,
    required AdsRepo adsRepo,
    required SettingsRepo settingsRepo,
    super.key,
  })  : _transactionsRepository = transactionsRepository,
        _adsRepo = adsRepo,
        _settingsRepo = settingsRepo;

  final TransactionsRepo _transactionsRepository;
  final AdsRepo _adsRepo;
  final SettingsRepo _settingsRepo;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<TransactionsRepo>(
            create: (context) => _transactionsRepository),
        RepositoryProvider<AdsRepo>(create: (context) => _adsRepo),
        RepositoryProvider<SettingsRepo>(create: (context) => _settingsRepo),
      ],
      child: AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF080C36),
          primary: const Color(0xFF080C36),
          secondary: const Color(0xFFC5CAE9),
          background: Colors.white,
          onError: Colors.red,
          onTertiary: Colors.amber,
        ),
        appBarTheme: AppBarTheme(
          color: Theme.of(context).colorScheme.onTertiary,
        ),
        fontFamily: 'ComicNeue',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontFamily: 'ComicNeue'),
          bodyMedium: TextStyle(fontFamily: 'ComicNeue'),
          displayLarge: TextStyle(fontFamily: 'ComicNeue'),
          displayMedium: TextStyle(fontFamily: 'ComicNeue'),
          displaySmall: TextStyle(fontFamily: 'ComicNeue'),
          headlineMedium: TextStyle(fontFamily: 'ComicNeue'),
          headlineSmall: TextStyle(fontFamily: 'ComicNeue'),
          titleLarge: TextStyle(fontFamily: 'ComicNeue'),
          titleMedium: TextStyle(fontFamily: 'ComicNeue'),
          titleSmall: TextStyle(fontFamily: 'ComicNeue'),
          bodySmall: TextStyle(fontFamily: 'ComicNeue'),
          labelLarge: TextStyle(fontFamily: 'ComicNeue'),
          labelSmall: TextStyle(fontFamily: 'ComicNeue'),
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // supportedLocales: [Locale('en'), Locale('ar')],
      home: const HomePage(),
    );
  }
}
