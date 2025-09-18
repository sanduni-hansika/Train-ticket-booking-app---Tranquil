import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'seatbooking.dart';

class TicketReservation extends StatefulWidget {
  final String? initialTrain;
  final String? initialDeparture;
  final String? initialArrival;
  final DateTime? initialDate;

  const TicketReservation({
    super.key,
    this.initialTrain,
    this.initialDeparture,
    this.initialArrival,
    this.initialDate,
  });

  @override
  State<TicketReservation> createState() => _TicketReservationState();
}

class _TicketReservationState extends State<TicketReservation> {
  List<String> stations = [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
  ];

  List<String> trains = [
    'Galu Kumari',
    'Ruhunu Kumari',
    'Yal Rani (No. 4443)',
    'Colombo Commuter (No. 4441)',
    'Uttara Devi (No. 4021)',
    'Express (No. 8766)',
    'Ruhunu Kumari (No. 8058)',
    'Train No. 8050',
    'Podi Menike',
  ];

  final List<String> classes = ['First class', 'Second class', 'Third class'];
  final List<String> passengerCounts =
      List.generate(10, (index) => '${index + 1}');

  String? selectedTrain;
  String? departureStation;
  String? arrivalStation;
  String? travelClass;
  String? passengerCount;
  DateTime? selectedDate;

  late TextEditingController _dateController;

  static const darkBlue = Color(0xFF123456);
  static const lightBlack = Colors.black54;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();

    if (widget.initialTrain != null && !trains.contains(widget.initialTrain)) {
      trains.insert(0, widget.initialTrain!);
    }
    if (widget.initialDeparture != null &&
        !stations.contains(widget.initialDeparture)) {
      stations.insert(0, widget.initialDeparture!);
    }
    if (widget.initialArrival != null &&
        !stations.contains(widget.initialArrival)) {
      stations.insert(0, widget.initialArrival!);
    }

    selectedTrain = widget.initialTrain;
    departureStation = widget.initialDeparture;
    arrivalStation = widget.initialArrival;

    if (widget.initialDate != null) {
      selectedDate = widget.initialDate;
      _dateController.text =
          DateFormat('MM/dd/yyyy').format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  void _navigateToSeatPage() {
    if (selectedTrain != null &&
        departureStation != null &&
        arrivalStation != null &&
        selectedDate != null &&
        travelClass != null &&
        passengerCount != null) {
      if (departureStation == arrivalStation) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Departure and arrival cannot be the same.')),
        );
        return;
      }

      final now = DateTime.now();
      final startDate = now;
      final endDate = now.add(const Duration(days: 30));

      if (selectedDate!.isBefore(startDate) ||
          selectedDate!.isAfter(endDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booking can be done between ${DateFormat('MM/dd/yyyy').format(startDate)} - ${DateFormat('MM/dd/yyyy').format(endDate)}.',
            ),
          ),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeatBookingScreen(
            numPassengers: int.parse(passengerCount!),
            trainName: selectedTrain!,
            bookingDate: selectedDate!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all the fields')),
      );
    }
  }

  Widget _buildDropdown(String label, List<String> items, String? selected,
      ValueChanged<String?> onChanged,
      {bool specialLabelColorForEmpty = false}) {
    Color labelColor = darkBlue;
    if (specialLabelColorForEmpty && (selected == null || selected.isEmpty)) {
      labelColor = lightBlack;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selected,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w600,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: labelColor),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: Icon(Icons.expand_more, color: labelColor),
        dropdownColor: Colors.white,
        items: items
            .map(
              (item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: const TextStyle(color: Colors.black87)),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        readOnly: true,
        onTap: _pickDate,
        controller: _dateController,
        decoration: InputDecoration(
          labelText: "Date",
          hintText: "MM/DD/YYYY",
          labelStyle: const TextStyle(
            color: darkBlue,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: const Icon(Icons.calendar_today, color: darkBlue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: darkBlue),
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                'assets/images/trainibook.jpg',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Ticket Reservation",
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF58A2F8),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDropdown("Train name", trains, selectedTrain,
                        (value) => setState(() => selectedTrain = value)),
                    _buildDropdown("Departure station", stations,
                        departureStation,
                        (value) => setState(() => departureStation = value)),
                    _buildDropdown("Arrival station", stations, arrivalStation,
                        (value) => setState(() => arrivalStation = value)),
                    _buildDateField(),
                    _buildDropdown(
                      "Class",
                      classes,
                      travelClass,
                      (value) => setState(() => travelClass = value),
                      specialLabelColorForEmpty: true,
                    ),
                    _buildDropdown(
                      "No of passengers",
                      passengerCounts,
                      passengerCount,
                      (value) => setState(() => passengerCount = value),
                      specialLabelColorForEmpty: true,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _navigateToSeatPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF58A2F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          "Reserve",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
