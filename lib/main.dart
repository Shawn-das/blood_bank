import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/login_page.dart';
import 'package:flutter_application_1/authentication/signup_page.dart';
import 'package:flutter_application_1/features/about_us.dart';
import 'package:flutter_application_1/features/admin/admin_login.dart';
import 'package:flutter_application_1/features/ambulence.dart';
import 'package:flutter_application_1/features/doner_page.dart';
import 'package:flutter_application_1/pages/dash_board.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5vdGt4ZXNxa2Rvc2djdnJtd3hwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzExMzA5MDgsImV4cCI6MjA4NjcwNjkwOH0.ZC0YJUShE5RU9fq-aGwRpCbBR9erIE890tgx29hFHkk",
    url: "https://notkxesqkdosgcvrmwxp.supabase.co",
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        //  Authentication
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),

        // Main Pages
        '/home': (context) => const HomePage(),
        '/dashboard': (context) => const DashboardPage(),
        '/profile': (context) => const ProfilePage(),

        // Features
        '/donate': (context) => const BeADonorPage(),
        '/ambulance': (context) => const AmbulancePage(),
        '/about': (context) => const AboutUsPage(),
        '/admin_login': (context) => const AdminLoginPage(),

        
      },
    );
  }
}
