import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;

import './providers/auth/auth_provider.dart';
import './repositories/auth_repository.dart';
import './pages/signup_page.dart';
import './pages/splash_page.dart';
import './firebase_options.dart';
import './pages/home_page.dart';
import './pages/signin_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'flutterstatelearn',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance,
              firebaseAuth: fb_auth.FirebaseAuth.instance),
        ),
        //  The "getter (user)" inside AuthRepository generates
        //  nullable type fb_atuh.user state whenever the user
        //  state changes.
        StreamProvider<fb_auth.User?>(
          create: (context) => context.read<AuthRepository>().user,
          //  The "user" stream can be accessed through "AuthRepository"
          //  instance created by the Provider above & I will provide
          //  as intialData bcz this makes it possible to access the
          //  user stream value on the widget tree.
          initialData: null,
        ),
        //  "AuthProvider" required an "fb_auth.user" type stream value.
        //  In easy words, I required a value from other providers I inject
        //  them into widget tree using "ChangeNotifierProxyProvider". Therefore;
        ChangeNotifierProxyProvider<fb_auth.User?, AuthProvider>(
          create: (context) => AuthProvider(
            authRepository: context.read<AuthRepository>(),
          ),
          update: (BuildContext context, fb_auth.User? userStream,
                  AuthProvider? authProvider) =>
              authProvider!..update(userStream),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth Provider',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashPage(),
        routes: {
          SignUpPage.routeName: (context) => const SignUpPage(),
          SigninPage.routeName: (context) => const SigninPage(),
          HomePage.routeName: (context) => const HomePage(),
        },
      ),
    );
  }
}
