// ignore_for_file: deprecated_member_use

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kurdish_localization/kurdish_material_localization_delegate.dart';
import 'package:flutter_kurdish_localization/kurdish_widget_localization_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/appointment/provider/appointment_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/profile_provider.dart';
import 'package:telemedicine_hub_doctor/features/splash/screen/splash_screen.dart';
import 'package:telemedicine_hub_doctor/firebase_options.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';
import 'package:telemedicine_hub_doctor/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "telemedicine-hub-afa78",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final languageProvider = LanguageProvider();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await languageProvider.initPrefs();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: Consumer<LanguageProvider>(
        builder: (BuildContext context, languageProvider, Widget? child) =>
            MaterialApp(
          useInheritedMediaQuery: true,
          locale: languageProvider.locale,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            KurdishMaterialLocalizations.delegate,
            KurdishWidgetLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('ku'),
          ],
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.transparent,
            appBarTheme: const AppBarTheme(
              systemOverlayStyle: SystemUiOverlayStyle.dark,
              backgroundColor: Colors.transparent, // Make app bar transparent
              elevation: 0, // Remove shadow
              scrolledUnderElevation: 0,
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.lightBlue,
              background: AppColors.lightBlue,
            ),
            fontFamily: GoogleFonts.openSans().fontFamily,
            extensions: const [
              GradientTheme(
                backgroundGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.16, 0.51, 0.74, 1.0],
                  colors: [
                    Color(0xFFF1FAFF),
                    Color(0xFFF6FCFF),
                    Color(0xFFF5FBFF),
                    Color(0xFFFFFFFF),
                  ],
                ),
              ),
            ],
          ),
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: Theme.of(context)
                    .extension<GradientTheme>()
                    ?.backgroundGradient,
              ),
              child: child!,
            );
          },
          initialRoute: AppRoutes.splash,
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.singin: (context) => const SignInEmail(),
          },
        ),
      ),
    );
  }
}
