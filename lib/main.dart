import 'package:castly/core/config/firebase_options.dart';
import 'package:castly/core/constants/string_manager.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/router/app_router.dart';
import 'package:castly/core/router/routes.dart';
import 'package:castly/core/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    dotenv.load(fileName: ".env"),
  ]).then((_) {
    intitSetupLocator();
    runApp(const MyApp());
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
      child: MaterialApp(
        title: StringManager.appName,
        theme: AppTheme.lightTheme,
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: Routes.splash,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
