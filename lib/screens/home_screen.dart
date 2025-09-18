import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:train/screens/bookinghistory.dart';

import 'profile.dart';
import 'traintimeschedule.dart';
import 'ticketfare.dart';
import 'userreviews.dart';
import 'emergencyguide.dart';
import 'mybooking.dart';
import 'chatbot.dart';
import 'contact1.dart';
import 'lostfound.dart';
import 'livelocation.dart';
import 'signin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = -1; //

  final List<Widget> _pages = const [
    MyBooking(),
    ChatBot(
      apiUrl: "",
      apiKey: "",
    ),
    Contact1(),
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
     
      setState(() {
        _selectedIndex = -1;
      });
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _pages[index - 1]),
    ).then((_) {
     
      setState(() {
        _selectedIndex = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF58A2F7)),
              child: const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data() as Map<String, dynamic>?;

          return Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    child: Image.asset(
                      'assets/images/homepage.jpg',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                  ),
                  Positioned(
                    top: 40,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Profile()),
                        );
                      },
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: userData != null &&
                                  userData['profile_pic'] != null &&
                                  userData['profile_pic'].isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl:
                                      '${userData['profile_pic']}?v=${DateTime.now().millisecondsSinceEpoch}',
                                  fit: BoxFit.cover,
                                  width: 44,
                                  height: 44,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(
                                          strokeWidth: 2),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.person,
                                          color: Colors.grey),
                                )
                              : const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: [
                    _buildButton(context, Icons.search, "Search", Colors.blue,
                        const TrainTimeSchedule()),
                    _buildButton(context, Icons.money, "Ticket Fare",
                        Colors.cyan, const TicketFare()),
                    _buildButton(context, Icons.wifi, "Live Location",
                        Colors.blue, const LiveLocationScreen()),
                    _buildButton(context, Icons.backpack, "Lost and Found",
                        Colors.cyan, const Lostfound()),
                    _buildButton(context, Icons.confirmation_num,
                        "Booking History", Colors.blue, const BookingHistory()),
                    _buildButton(context, Icons.reviews, "User Reviews",
                        Colors.cyan, const UserReviews()),
                    _buildButton(context, Icons.warning_amber,
                        "Emergency Guide", Colors.blue, const EmergencyGuide()),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex == -1 ? 0 : _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blue.shade900, 
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    Widget page,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(
          child: SizedBox(
            width: 180,
            child: Row(
              children: [
                Container(
                  width: 30,
                  alignment: Alignment.centerRight,
                  child: Icon(icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
