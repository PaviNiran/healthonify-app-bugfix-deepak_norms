import 'dart:developer';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/firebase_options.dart';
import 'package:healthonify_mobile/models/fiirebase_notifications.dart';
import 'package:healthonify_mobile/models/shared_pref_manager.dart';
import 'package:healthonify_mobile/providers/auth/login_data.dart';
import 'package:healthonify_mobile/providers/multi_provider.dart';
import 'package:healthonify_mobile/screens/auth/login_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/physio/experts_list_screen.dart';
import 'package:healthonify_mobile/screens/main_screen.dart';
import 'package:healthonify_mobile/screens/splash/splash_screen.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Instance/Object of shared pref to store data
late SharedPreferences kSharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseNotif.init();

  FirebaseMessaging.onBackgroundMessage(
      FirebaseNotif.firebaseMessagingBackgroundHandler);
  // ignore: unused_local_variable
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  //ios configuration

  await FirebaseNotif.createNotifChannel();

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
  FirebaseNotif.registerNotification();
  _configureLocalTimeZone().then((value) {
    // getLocationAccess();
  });
  kSharedPreferences = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

PermissionStatus? permissionStatus;
void getLocationAccess() async {
  Location location = Location();

  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();

    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  permissionStatus = permissionGranted;
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
  log("location :LONG- ${locationData.longitude} LAT- ${locationData.latitude} ");
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZone = await FlutterTimezone.getLocalTimezone();
  // log(timeZone);
  tz.setLocalLocation(tz.getLocation(timeZone));
  log("Time zone init");
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: MultiProv.providersArray,
      child: MaterialApp(
        theme: MyTheme.lightTheme,
        darkTheme: MyTheme.darkTheme,
        themeMode: ThemeMode.system,
        title: 'Healthonify',
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
        routes: {
          ExpertsList.routeName: (ctx) => const ExpertsList(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool session = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((value) => log(value!));
    FirebaseNotifClickHandler(context: context).setupInteractedMessage().then(
      (value) {
        permissionStatus == PermissionStatus.denied
            ? locationDisclosure()
            : null;
      },
    );

    // getSession();
  }

  // void getSession() async {
  //   setState(() {
  //     isLoading == true;
  //   });
  //   SharedPrefManager pref = SharedPrefManager();
  //   session = await pref.getSession();
  //   // print(session);
  //   setState(() {
  //     isLoading == false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }

  void locationDisclosure() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Text(
                  "Use your location",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Healthonify collects location data to enable fitness tracking even when the app is closed or not in use.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Image.asset(
                "assets/icons/maps.png",
                height: 100,
                width: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Collected location data will be used to detect laboratories around your location. Please grant access to continue.",
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  getLocationAccess();
                  Navigator.pop(context);
                },
                child: const Text('Continue'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
