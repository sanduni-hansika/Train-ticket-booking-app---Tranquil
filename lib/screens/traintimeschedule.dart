import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'timetable.dart'; 

class TrainTimeSchedule extends StatefulWidget {
  const TrainTimeSchedule({super.key});

  @override
  State<TrainTimeSchedule> createState() => _TrainTimeScheduleState();
}

class _TrainTimeScheduleState extends State<TrainTimeSchedule> {
  String? selectedDeparture;
  String? selectedArrival;
  DateTime? selectedDate;

  final List<String> departureStations = [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
  ];

  final List<String> arrivalStations = [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
    'Galle',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF58A2F8),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(5),
              ),
              child: Image.asset(
                'assets/images/trainimage.jpg',
                height: MediaQuery.of(context).size.height * 0.40,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 60,
              left: 15,
              right: 15,
              bottom: 20,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Train Time Schedule',
                        style: TextStyle(
                          fontSize: 30, 
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF58A2F8),
                        ),
                      ),
                      const SizedBox(height: 25),
                      buildDropdown(
                        "Departure station",
                        departureStations,
                        selectedDeparture,
                        (value) => setState(() => selectedDeparture = value),
                      ),
                      const SizedBox(height: 15),
                      buildDropdown(
                        "Arrival Station",
                        arrivalStations,
                        selectedArrival,
                        (value) => setState(() => selectedArrival = value),
                      ),
                      const SizedBox(height: 15),
                      buildDatePicker(),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.search, size: 20, color: Colors.white),
                          label: const Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF58A2F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            if (selectedDeparture != null &&
                                selectedArrival != null &&
                                selectedDate != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TimeTableScreen(
                                    departure: selectedDeparture!,
                                    arrival: selectedArrival!,
                                    date: selectedDate!,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown(
    String label,
    List<String> options,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, color: Color(0xFF24086D)),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF24086D)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            hint: const Text("Select"),
            value: selectedValue,
            underline: const SizedBox(),
            icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF24086D)),
            items: options.map((station) {
              return DropdownMenuItem<String>(
                value: station,
                child: Text(station),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Date",
          style: TextStyle(fontSize: 16, color: Color(0xFF24086D)),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectDate(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF24086D)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Text(
                  selectedDate == null
                      ? "Select a date"
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFF24086D),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
