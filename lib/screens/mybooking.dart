import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr.dart';
import 'bookinghistory.dart';
import 'home_screen.dart'; 
class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _moveExpiredBookings();
  }

  Future<void> _moveExpiredBookings() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    final expiredQuery = await firestore
        .collection('mybooking')
        .where('trainDate', isLessThan: todayStart)
        .get();

    for (final doc in expiredQuery.docs) {
      final data = doc.data();

      await firestore.collection('bookinghistory').doc(doc.id).set({
        'receipt': data['receipt'],
        'trainDate': data['trainDate'],
        'movedAt': now,
      });

      await firestore.collection('mybooking').doc(doc.id).delete();
    }
  }

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF58A2F7);
    const greyColor = Color(0xFFE0E0E0);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Bookings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          },
          tooltip: 'Back to Home',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('mybooking')
            .where('trainDate', isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
            .orderBy('trainDate')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.event_busy, size: 80, color: greyColor),
                  SizedBox(height: 12),
                  Text(
                    'No upcoming bookings',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data()! as Map<String, dynamic>;
              final receipt = data['receipt'] as Map<String, dynamic>;
              final qrData = data['qrData'] as Map<String, dynamic>;
              final trainDateTimestamp = data['trainDate'] as Timestamp;
              final trainDate = trainDateTimestamp.toDate();

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(14),
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withOpacity(0.1),
                    child: const Icon(Icons.train, color: primaryColor),
                  ),
                  title: Text(
                    "${receipt['train']} (${receipt['class']})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "📅 ${formatDate(trainDate)}\n🪑 ${(receipt['seats'] as List).join(', ')}",
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  trailing: Text(
                    "Rs. ${receipt['amount']}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrScreen(qrData: qrData, receipt: receipt),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BookingHistory()),
          );
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}
