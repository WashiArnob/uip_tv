import 'package:get/get.dart';
import 'ui/home_screen.dart';
import 'ui/splash_screen.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/', page: () => SplashScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
  ];
}
