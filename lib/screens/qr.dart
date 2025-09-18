import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'mybooking.dart';

class QrScreen extends StatelessWidget {
  final Map<String, dynamic> qrData;
  final Map<String, dynamic> receipt;

  const QrScreen({
    super.key,
    required this.qrData,
    required this.receipt,
  });

  Future<void> _saveBookingToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    DateTime trainDate;
    try {
      trainDate = DateTime.parse(receipt['date']);
    } catch (_) {
      trainDate = DateTime.now();
    }

    Map<String, dynamic> bookingData = {
      'qrData': qrData,
      'receipt': receipt,
      'trainDate': trainDate,
      'createdAt': DateTime.now(),
    };

    final docId = qrData['bookingId']?.toString();
    if (docId != null) {
      await firestore.collection('mybooking').doc(docId).set(bookingData);
    } else {
      await firestore.collection('mybooking').add(bookingData);
    }
  }

  Widget buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF4facfe), size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final qrString = qrData.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Ticket',
          style: TextStyle(
            color: Color(0xFF4facfe), 
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.25),
                    blurRadius: 12,
                    spreadRadius: 3,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    QrImageView(
                      data: qrString,
                      version: QrVersions.auto,
                      size: 220.0,
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Show this QR to the conductor',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 12),

                    // Ticket Details with icons
                    buildDetailRow(Icons.confirmation_number, "Booking ID",
                        qrData['bookingId']?.toString() ?? '—'),
                    buildDetailRow(Icons.train, "Train", receipt['train']),
                    buildDetailRow(Icons.chair, "Class", receipt['class']),
                    buildDetailRow(Icons.directions_railway,
                        "Carriage", receipt['carriage']),
                    buildDetailRow(Icons.date_range, "Date", receipt['date']),
                    buildDetailRow(Icons.people, "Passengers",
                        receipt['passengers'].toString()),
                    buildDetailRow(Icons.event_seat, "Seats",
                        (receipt['seats'] as List).join(', ')),
                    buildDetailRow(Icons.attach_money, "Amount",
                        "Rs. ${receipt['amount']}"),

                    const SizedBox(height: 14),
                    const Divider(),
                    const SizedBox(height: 8),
                    const Text(
                      'Receipt',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Generated at: ${DateTime.now().toLocal()}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  await _saveBookingToFirestore();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MyBooking()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58A2F8), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
