import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vietq_hrm/blocs/blocManager/bloc_manager.dart';
import 'package:vietq_hrm/blocs/forgot/forgot_bloc.dart';
import 'package:vietq_hrm/blocs/theme/theme_bloc.dart';
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
  runApp(MyApp(router: createRouter()));
}

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()),
        BlocProvider(create: (context) => ForgotBloc())
      ],
      child: ScreenUtilInit(
        designSize: const Size(428, 926),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, themeState) {
                print("#==========> ${themeState.primaryColor}");
                return MaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  themeMode: ThemeMode.system,
                  theme: ThemeData(
                    progressIndicatorTheme: ProgressIndicatorThemeData(
                      color: themeState.progressIndicatorColor,
                      linearTrackColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5.r),
                      strokeWidth: 3.r,
                    ),
                    primaryColor: themeState.primaryColor,
                    scaffoldBackgroundColor: Colors.white,
                    splashFactory: InkSplash.splashFactory,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
                    colorScheme: ColorScheme(
                      brightness: Brightness.light,
                      primary: themeState.primaryColor,
                      // màu gốc
                      onPrimary: Colors.white,
                      secondary: themeState.primaryColor,
                      // đồng bộ luôn
                      onSecondary: Colors.white,
                      error: Colors.red,
                      onError: Colors.white,
                      background: Colors.white,
                      onBackground: Colors.black,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                    useMaterial3: true,
                    textTheme: TextTheme(
                      headlineLarge: GoogleFonts.ubuntu(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      headlineMedium: GoogleFonts.ubuntu(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      headlineSmall: GoogleFonts.ubuntu(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      bodyLarge: GoogleFonts.ubuntu(fontSize: 16.sp),
                      bodyMedium: GoogleFonts.ubuntu(
                        fontSize: 14.sp,
                        color: Colors.grey[800],
                      ),
                      bodySmall: GoogleFonts.ubuntu(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  darkTheme: ThemeData(
                    splashFactory: InkSplash.splashFactory,
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    brightness: Brightness.dark,
                    progressIndicatorTheme: ProgressIndicatorThemeData(
                      color: themeState.progressIndicatorColor,
                      linearTrackColor: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5.r),
                      strokeWidth: 3.r,
                    ),
                    colorScheme: ColorScheme(
                      brightness: Brightness.dark,
                      primary: themeState.primaryColor,
                      onPrimary: Colors.white,
                      secondary: themeState.primaryColor,
                      onSecondary: Colors.white,
                      error: Colors.red,
                      onError: Colors.white,
                      background: Colors.white,
                      onBackground: Colors.black,
                      surface: Colors.white,
                      onSurface: Colors.black,
                    ),
                    primaryColor: themeState.primaryColor,
                    appBarTheme: const AppBarTheme(
                      backgroundColor: Color(0xFF1F2937),
                      foregroundColor: Color(0xFF1e1e1e),
                    ),
                    textTheme: TextTheme(
                      headlineLarge: GoogleFonts.ubuntu(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      headlineMedium: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      headlineSmall: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      bodyLarge: GoogleFonts.ubuntu(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      bodyMedium: GoogleFonts.ubuntu(
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                      bodySmall: GoogleFonts.ubuntu(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  routerConfig: router,
                  // builder: (context, child) {
                  //   return HeroControllerScope.none(child: child!);
                  // },
                );
              },
            ),
          );
        },
      ),
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
