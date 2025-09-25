import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const BarbeariaApp());
}

class BarbeariaApp extends StatelessWidget {
  const BarbeariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Sistema Barbearia',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

