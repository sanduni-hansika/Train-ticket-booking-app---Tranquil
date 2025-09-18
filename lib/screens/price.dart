import 'package:flutter/material.dart';
import 'ticketfare.dart';

class Price extends StatelessWidget {
  final String from;
  final String to;

  Price({super.key, required this.from, required this.to});

  final Map<String, Map<String, Map<String, String>>> fareData = {
    'Maradana': {
      'Matara': {
        '1N': 'Rs. 800.00',
        '1S': 'Rs. 950.00',
        '2N': 'Rs. 500.00',
        '2S': 'Rs. 600.00',
        '3N': 'Rs. 300.00',
        '3S': 'Rs. 350.00',
      },
    },
    'Anuradhapura': {
      'Jaffna': {
        '1N': 'Rs. 1000.00',
        '1S': 'Rs. 1200.00',
        '2N': 'Rs. 650.00',
        '2S': 'Rs. 750.00',
        '3N': 'Rs. 400.00',
        '3S': 'Rs. 450.00',
      },
    },
    'Colombo Fort': {
      'Matara': {
        '1N': 'Rs. 900.00',
        '1S': 'Rs. 1100.00',
        '2N': 'Rs. 600.00',
        '2S': 'Rs. 700.00',
        '3N': 'Rs. 350.00',
        '3S': 'Rs. 400.00',
      },
    },
    'Badulla': {
      'Colombo Fort': {
        '1N': 'Rs. 1600.00',
        '1S': 'Rs. 1900.00',
        '2N': 'Rs. 1000.00',
        '2S': 'Rs. 1200.00',
        '3N': 'Rs. 600.00',
        '3S': 'Rs. 700.00',
      },
    },
  };

  @override
  Widget build(BuildContext context) {
    final fare = fareData[from]?[to];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: fare != null
            ? SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF58A2F7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "$from ➔ $to",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "🎫 Normal Ticket Prices",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(fare['1N']!, fare['2N']!, fare['3N']!),
                    const SizedBox(height: 30),
                    const Text(
                      "🌟 Seasonal Ticket Prices",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildPriceCard(fare['1S']!, fare['2S']!, fare['3S']!),
                  ],
                ),
              )
            : _buildNoMatchLayout(context),
      ),
    );
  }

  Widget _buildPriceCard(String first, String second, String third) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildPriceRow("First Class", first),
          const Divider(height: 20, thickness: 1),
          _buildPriceRow("Second Class", second),
          const Divider(height: 20, thickness: 1),
          _buildPriceRow("Third Class", third),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String title, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF24086D),
          ),
        ),
        Text(
          price,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  Widget _buildNoMatchLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 80,
            color: Color(0xFF2196F3),
          ),
          const SizedBox(height: 20),
          const Text(
            "Oops! No Ticket Fare Found",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2196F3),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            "The fare details for your selected route are not available at the moment.\n\nTry selecting a different combination.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const TicketFare()),
              );
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Choose Another Route"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
