import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uip_tv/controllers/movie_controller.dart';
import 'package:uip_tv/routes.dart';
import 'ui/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialize & Open Box
  await Hive.initFlutter();
  await Hive.openBox('moviesBox'); // Ensure Movie Data Storing

  // GetX Controller Register
  Get.lazyPut(() => MovieController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UIP-TV',
      theme: ThemeData.dark(),
      initialRoute: '/',
      getPages: AppRoutes.routes,
      home: SplashScreen(),
    );
  }
}


