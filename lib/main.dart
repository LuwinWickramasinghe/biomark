import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:biomark/Screens/Welcome/welcome_screen.dart';
import 'package:biomark/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'viewmodels/account_recovery_view_model.dart';  // Import the ViewModel


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for both Web and non-Web platforms
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAqRlUlkdhlGBhhdIpD5OprYGusukqjmBM",
        authDomain: "biomark-86cde.firebaseapp.com",
        projectId: "biomark-86cde",
        storageBucket: "biomark-86cde.firebasestorage.app",
        messagingSenderId: "646088274735",
        appId: "1:646088274735:web:f4b3caf91a5e089931e7da",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providing AccountRecoveryViewModel
        ChangeNotifierProvider(
          create: (context) => AccountRecoveryViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Auth',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              foregroundColor: Colors.white,
              backgroundColor: kPrimaryColor,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
