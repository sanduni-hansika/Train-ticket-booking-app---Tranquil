import 'package:flutter/material.dart';
import 'pnrstatus.dart';

class PayScreen extends StatefulWidget {
  final double amount;
  final String trainName;
  final String ticketClass;
  final int numPassengers;
  final List<String> selectedSeats;
  final DateTime bookingDate;
  final String selectedCarriage;

  const PayScreen({
    super.key,
    required this.amount,
    required this.trainName,
    required this.ticketClass,
    required this.numPassengers,
    required this.selectedSeats,
    required this.bookingDate,
    required this.selectedCarriage,
  });

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvnController = TextEditingController();

  bool processing = false;

  void _startPayment() async {
    final cardNumber = _cardNumberController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvn = _cvnController.text.trim();

    if (cardNumber.isEmpty || expiry.isEmpty || cvn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all card details')),
      );
      return;
    }

    final cardNumberValid = RegExp(r'^\d{8}$').hasMatch(cardNumber);

    setState(() => processing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => processing = false);

    final paymentSuccess = cardNumberValid;

    if (!paymentSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment failed: Card number must be exactly 8 digits.'),
        ),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PnrStatusScreen(
          paymentSuccess: paymentSuccess,
          bookingDetails: {
            'train': widget.trainName,
            'class': widget.ticketClass,
            'carriage': widget.selectedCarriage,
            'seats': widget.selectedSeats,
            'passengers': widget.numPassengers,
            'amount': widget.amount,
            'date': widget.bookingDate.toIso8601String(),
          },
        ),
      ),
    );
  }

  void _clearFields() {
    _cardNumberController.clear();
    _expiryController.clear();
    _cvnController.clear();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = const Color(0xFF58A2F8);
    final payButtonColor = const Color(0xFF58A2F8);
    final clearButtonColor = Colors.white;
    final darkBlueBorder = const Color(0xFF1a237e);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: appBarColor,
          centerTitle: true,
          elevation: 6,
          automaticallyImplyLeading: false,
          title: const Text(
            'Pay Now',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, 
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              TextField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: InputDecoration(
                  counterText: '',
                  labelText: 'Card Number',
                  labelStyle: const TextStyle(color: Colors.black),
                  prefixIcon: const Icon(Icons.credit_card, color: Color(0xFF1a237e)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: darkBlueBorder),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFF58A2F8), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Enter card number',
                ),
                style: const TextStyle(fontSize: 18, letterSpacing: 2),
              ),
              const SizedBox(height: 20),

             
              const Text(
                'Expiration Month and Year',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        hintText: 'MM/YYYY',
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkBlueBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF58A2F8), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _cvnController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 3,
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'CVN',
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: darkBlueBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFF58A2F8), width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 16, letterSpacing: 2),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              
              const Text(
                'Total Amount',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Rs. ${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              
              processing
                  ? Center(child: CircularProgressIndicator(color: payButtonColor))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: _clearFields,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: clearButtonColor,
                              side: BorderSide(color: darkBlueBorder, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 3,
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        SizedBox(
                          width: 100,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _startPayment,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: payButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 6,
                              shadowColor: payButtonColor.withOpacity(0.6),
                            ),
                            child: const Text(
                              'Pay',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
