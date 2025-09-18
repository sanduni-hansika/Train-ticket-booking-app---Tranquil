import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'qr.dart';

class PnrStatusScreen extends StatefulWidget {
  final bool paymentSuccess;
  final Map<String, dynamic> bookingDetails;

  const PnrStatusScreen({
    super.key,
    required this.paymentSuccess,
    required this.bookingDetails,
  });

  @override
  State<PnrStatusScreen> createState() => _PnrStatusScreenState();
}

class _PnrStatusScreenState extends State<PnrStatusScreen> {
  String? bookingId;
  bool saving = false;

  Future<void> _saveBooking() async {
    setState(() => saving = true);

    final dateKey = widget.bookingDetails['date'];
    final trainName = widget.bookingDetails['train'];
    final carriage = widget.bookingDetails['carriage'];
    final seats = List<String>.from(widget.bookingDetails['seats']);

    final data = {
      ...widget.bookingDetails,
      'paymentStatus': widget.paymentSuccess ? 'SUCCESS' : 'FAILED',
      'savedAt': DateTime.now().toIso8601String(),
      'userId': 'user_guest',
    };

    try {
      final firestoreRef =
          await FirebaseFirestore.instance.collection('bookings').add(data);
      bookingId = firestoreRef.id;
    } catch (e) {
      debugPrint("Firestore save error: $e");
    }

    try {
      final dbRef = FirebaseDatabase.instance
          .ref('seatBookings/$trainName/$dateKey/$carriage');

      for (var seat in seats) {
        await dbRef.child(seat).set({
          'bookingId': bookingId,
          'userId': 'user_guest',
          'status': data['paymentStatus'],
          'timestamp': ServerValue.timestamp,
        });
      }
    } catch (e) {
      debugPrint("Realtime DB save error: $e");
    }

    setState(() => saving = false);

    if (bookingId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking saved successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save booking')),
      );
    }
  }

  void _gotoQr() {
    if (bookingId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please save the booking first')),
      );
      return;
    }

    final qrPayload = {
      'bookingId': bookingId,
      'userId': 'user_guest',
      ...widget.bookingDetails,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrScreen(
          qrData: qrPayload,
          receipt: widget.bookingDetails,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.bookingDetails;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Payment Status',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF58A2F7),
          centerTitle: true,
          elevation: 6,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 12),

            
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: widget.paymentSuccess ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    widget.paymentSuccess ? Icons.check_circle : Icons.error,
                    color: widget.paymentSuccess ? Colors.green : Colors.red,
                    size: 40,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      widget.paymentSuccess
                          ? 'Payment Successful'
                          : 'Payment Failed',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            widget.paymentSuccess ? Colors.green[800] : Colors.red[800],
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const Divider(),
                    _rowTile(Icons.train, 'Train', details['train']),
                    _rowTile(Icons.chair, 'Class', details['class']),
                    _rowTile(Icons.directions_railway, 'Carriage', details['carriage']),
                    _rowTile(Icons.event_seat, 'Seats',
                        (details['seats'] as List).join(', ')),
                    _rowTile(Icons.people, 'Passengers', '${details['passengers']}'),
                    _rowTile(Icons.attach_money, 'Amount', 'Rs. ${details['amount']}'),
                    _rowTile(Icons.date_range, 'Date', details['date']),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (saving) const CircularProgressIndicator(),
            const SizedBox(height: 12),

            
            if (widget.paymentSuccess)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: bookingId == null ? _saveBooking : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bookingId == null
                            ? const Color(0xFF58A2F8)
                            : Colors.grey,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        bookingId == null ? 'Save Booking' : 'Saved',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: bookingId != null ? _gotoQr : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF58A2F8),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Get QR Code',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Payment Failed'),
                      content: const Text(
                          'Your payment was not successful. Please try again.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: const Text(
                  'Payment Failed - Retry?',
                  style: TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _rowTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2196F3), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
