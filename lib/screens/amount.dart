import 'package:flutter/material.dart';
import 'pay.dart';
import 'package:intl/intl.dart';

class AmountScreen extends StatelessWidget {
  final int numPassengers;
  final String trainName;
  final String ticketClass; 
  final List<String> selectedSeats;
  final DateTime bookingDate;
  final String selectedCarriage;
  final Future<void> Function(Map<String, dynamic> bookingData)? onPaymentSuccess;

  AmountScreen({
    super.key,
    required this.numPassengers,
    required this.trainName,
    required this.ticketClass,
    required this.selectedSeats,
    required this.bookingDate,
    required this.selectedCarriage,
    this.onPaymentSuccess,
  });

  final Map<String, double> classFare = {
    '1N': 800,
    '1S': 950,
    '2N': 500,
    '2S': 600,
    '3N': 300,
    '3S': 350,
  };

  double _calculateTotal() {
    final price = classFare[ticketClass] ?? 0.0;
    return price * numPassengers;
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _calculateTotal();
    final dateFormatted = DateFormat('yyyy-MM-dd').format(bookingDate);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80), 
        child: AppBar(
          title: const Text(
            'Total Amount',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF58A2F8),
          centerTitle: true,
          elevation: 4,
          automaticallyImplyLeading: false, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30), 
        child: Column(
          children: [
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Train: $trainName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF58A2F8),
                      )),
                  const SizedBox(height: 6),
                  Text('Class: $ticketClass', style: const TextStyle(color: Colors.black)),
                  const SizedBox(height: 6),
                  Text('Carriage: $selectedCarriage', style: const TextStyle(color: Colors.black)),
                  const SizedBox(height: 6),
                  Text('Date: $dateFormatted', style: const TextStyle(color: Colors.black)),
                  const SizedBox(height: 6),
                  Text('Passengers: $numPassengers', style: const TextStyle(color: Colors.black)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: selectedSeats
                        .map((s) => Chip(
                              label: Text(
                                s,
                                style: const TextStyle(color: Colors.black87),
                              ),
                              backgroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: Colors.black12,
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey[300], thickness: 1),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xFF58A2F8)),
                      ),
                      Text(
                        'Rs. $totalAmount',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), 

            
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PayScreen(
                        amount: totalAmount,
                        trainName: trainName,
                        ticketClass: ticketClass,
                        numPassengers: numPassengers,
                        selectedSeats: selectedSeats,
                        bookingDate: bookingDate,
                        selectedCarriage: selectedCarriage,
                      ),
                    ),
                  );

                  if (result == true && onPaymentSuccess != null) {
                    final bookingPayload = {
                      'train': trainName,
                      'class': ticketClass,
                      'carriage': selectedCarriage,
                      'seats': selectedSeats,
                      'passengers': numPassengers,
                      'amount': totalAmount,
                      'date': DateFormat('yyyy-MM-dd').format(bookingDate),
                      'timestamp': DateTime.now().toIso8601String(),
                    };
                    await onPaymentSuccess!(bookingPayload);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58A2F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Pay',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ),
    );
  }
}
