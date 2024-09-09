import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_gen_core/version.gen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';
import 'package:telemedicine_hub_doctor/features/splash/screen/splash_screen.dart';
import 'package:telemedicine_hub_doctor/routes/app_routes.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: DevicePreview(
          // enabled: !kReleaseMode,
          enabled: false,
          builder: (context) => const MyApp(), // Wrap your app
        ),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: const Locale('en', 'ar'),
        // builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate, // Add this line

          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
        ],
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            elevation: 0,
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.lightBlue,
            // brightness: Brightness.dark,
            // surface: AppColors.black,
            background: AppColors.lightBlue,
          ),
          fontFamily: GoogleFonts.openSans().fontFamily,
        ),
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (context) => const SplashScreen(),
          AppRoutes.singin: (context) => const SignInEmail(),
        },
      ),
    );
  }
}
