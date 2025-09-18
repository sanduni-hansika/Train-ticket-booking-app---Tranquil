import 'package:flutter/material.dart';
import 'price.dart';

class TicketFare extends StatefulWidget {
  const TicketFare({super.key});

  @override
  State<TicketFare> createState() => _TicketFareScreenState();
}

class _TicketFareScreenState extends State<TicketFare> {
  String? fromStation;
  String? toStation;

  final List<String> fromStations = [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
  ];

  final List<String> toStations = [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
    'Galle',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 16,
              right: 16,
              bottom: 30,
            ),
            child: Column(
              children: [
                Image.asset('assets/images/price.jpg', height: 150),
                const SizedBox(height: 12),
                const Text(
                  "Train Ticket Fare",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          buildDropdown(
            "From Station",
            fromStations,
            fromStation,
            (value) => setState(() => fromStation = value),
          ),
          const SizedBox(height: 25),
          buildDropdown(
            "To Station",
            toStations,
            toStation,
            (value) => setState(() => toStation = value),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 250,  
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                if (fromStation != null && toStation != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Price(from: fromStation!, to: toStation!),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select both stations.")),
                  );
                }
              },
              icon: const Icon(Icons.train, color: Colors.white),
              label: const Text(
                "View Price",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.zero,
                elevation: 5,
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String label,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF24086D),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFF2196F3), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Select a station"),
              value: selectedValue,
              underline: const SizedBox(),
              icon: const Icon(Icons.expand_more, color: Color(0xFF2196F3)),
              items: items.map((station) {
                return DropdownMenuItem<String>(
                  value: station,
                  child: Text(station, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
