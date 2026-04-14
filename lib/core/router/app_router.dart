import 'package:castly/core/models/stream_model.dart';
import 'package:castly/features/home/presentation/home_screen.dart';
import 'package:castly/features/streams/live_stream/presentation/live_stream_screen.dart';
import 'package:castly/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:castly/core/database/local/secure_storage/secure_storage_helper.dart';
import 'package:castly/core/di/service_locator.dart';
import 'package:castly/core/router/routes.dart';
import 'package:castly/features/auth/presentation/forget_passoword/presentation/forget_password_screen.dart';
import 'package:castly/features/auth/presentation/login/presentation/login_screen.dart';
import 'package:castly/features/auth/presentation/register/presentation/register_screen.dart';
import 'package:castly/features/splash/screens/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) =>
              SplashScreen(secureStorageHelper: getIt<SecureStorageHelper>()),
        );
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case Routes.forgetPassword:
        return MaterialPageRoute(builder: (_) => ForgetPasswordPage());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case Routes.liveStream:
        final streamModel = settings.arguments as StreamModel;
        return MaterialPageRoute(
          builder: (_) => LiveStreamPage(streamModel: streamModel),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Not Found : ${settings.name}')),
          ),
        );
    }
  }
}
