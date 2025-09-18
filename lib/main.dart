import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:train/screens/bookinghistory.dart';
import 'package:train/screens/splash_screen.dart';
import 'package:train/screens/signin.dart';
import 'package:train/screens/signup_screen.dart';
import 'package:train/screens/home_screen.dart';
import 'package:train/screens/profile.dart';
import 'package:train/screens/traintimeschedule.dart';
import 'package:train/screens/ticketfare.dart';
import 'package:train/screens/livelocation.dart';
import 'package:train/screens/userreviews.dart';
import 'package:train/screens/emergencyguide.dart';
import 'package:train/screens/mybooking.dart';
import 'package:train/screens/chatbot.dart';
import 'package:train/screens/contact1.dart';
import 'package:train/screens/lostfound.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tranquil App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => const SplashScreen(),
        '/signin': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/login': (context) => const LoginScreen(),

        
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const Profile(),
        '/traintimeschedule': (context) => const TrainTimeSchedule(),
        '/bookinghistory': (context) => const BookingHistory(),
        '/ticketfare': (context) => const TicketFare(),
        '/livelocation': (context) => const LiveLocationScreen(),
        '/userreviews': (context) => const UserReviews(),
        '/emergencyguide': (context) => const EmergencyGuide(),
        '/mybooking': (context) => const MyBooking(),
        

        
        '/chatbot': (context) => const ChatBot(
              apiUrl: "",
              apiKey: "", 
            ),

        '/contacts': (context) => const Contact1(),
        '/lostfound': (context) => const Lostfound(),
      },
    );
  }
}
