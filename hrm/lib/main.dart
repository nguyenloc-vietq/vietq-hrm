import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vietq_hrm/configs/sharedPreference/SharedPreferences.config.dart';
import 'package:vietq_hrm/routers/routes.config.dart';
import 'package:vietq_hrm/services/firebase/firebase_options.dart';
import 'package:vietq_hrm/services/push_notification/notification.service.dart';

//248 212 72 254 249 221
@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await SharedPreferencesConfig.init();
  await dotenv.load(fileName: "assets/.env");
  await initializeDateFormatting('vi', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  //remove splash
  FlutterNativeSplash.remove();
  runApp(MyApp(appRouter: appRouter));
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;

  const MyApp({super.key, required this.appRouter});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        primaryColor: Color(0xFFFBE67B),
        scaffoldBackgroundColor: Colors.white,
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFBE67B),
          brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.ubuntu(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: GoogleFonts.ubuntu(
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: GoogleFonts.ubuntu(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.ubuntu(fontSize: 18,),
          bodyMedium: GoogleFonts.ubuntu(fontSize: 16, color: Colors.grey[800]),
          bodySmall: GoogleFonts.ubuntu(fontSize: 16, color: Colors.grey)
        ),
      ),
      darkTheme: ThemeData(
        splashFactory: InkSplash.splashFactory,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        brightness: Brightness.dark,
        primaryColor: Color(0xFFFBE67B),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          foregroundColor: Colors.white,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFFF8D448),
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: appRouter,
      // builder: (context, child) {
      //   return HeroControllerScope.none(child: child!);
      // },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    NotificationService().requestNotificationPermission();
    NotificationService().getToken();
    NotificationService().firebaseInit(context);
    NotificationService().setupInteractions(context);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Text('H2 Subtitle', style: textTheme.headlineMedium),
      ),

    );
  }
}
