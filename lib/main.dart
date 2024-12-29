import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabse_playground/pages/add_note.dart';
import 'package:supabse_playground/pages/home.dart';
import 'package:supabse_playground/pages/login.dart';
import 'package:supabse_playground/pages/signup.dart';
import 'package:supabse_playground/widgets/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://xufhqcqwrmehuvbvzmak.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1ZmhxY3F3cm1laHV2YnZ6bWFrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUwMzkxMzUsImV4cCI6MjA1MDYxNTEzNX0.vAsWT__yLAz-yxurnH_ju0vE7JvrADXx6RYn5I_Oq04',
  );
  await GetStorage.init(); // Initialize GetStorage if used
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
        title: 'Supabase Playground',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              secondary: Colors.black,
            ),
            useMaterial3: true,
            fontFamily: 'Jost',
            primaryColor: Colors.black),
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
        initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const Home()),
        GetPage(name: '/login', page: () => const LoginScreen(), transition: Transition.cupertino),
        GetPage(name: '/signup', page: () => const SignupScreen(),  transition: Transition.cupertino),
        GetPage(name: '/add-note', page: () => AddNote(isEdit: false,),  transition: Transition.cupertino),

      ],
        
        );
        
  }
}
