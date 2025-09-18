import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'mapview.dart';
import 'data.dart'; 

class LiveLocationScreen extends StatefulWidget {
  const LiveLocationScreen({super.key});

  @override
  State<LiveLocationScreen> createState() => _LiveLocationScreenState();
}

class _LiveLocationScreenState extends State<LiveLocationScreen> {
  late final DateTime selectedDate;
  Station? selectedFrom;
  Station? selectedTo;
  Train? selectedTrain;

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
  }

  List<Train> get filteredTrains {
    if (selectedFrom == null || selectedTo == null) {
      return allTrains;
    }

    final bool isWeekend =
        selectedDate.weekday == DateTime.saturday ||
        selectedDate.weekday == DateTime.sunday;

    return allTrains.where((train) {
      final matchesDate = isWeekend
          ? train.runDays == RunDays.weekend
          : train.runDays == RunDays.weekday;
      final matchesFrom = train.startStation.name == selectedFrom!.name;
      final matchesTo = train.endStation.name == selectedTo!.name;
      return matchesDate && matchesFrom && matchesTo;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat.yMMMEd().format(selectedDate);
    const darkBlue = Color(0xFF0D1B2A);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: Scaffold(
        backgroundColor: const Color(0xfff8f9fa),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
                child: Image.asset(
                  'assets/images/trainibook.jpg',
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 25),
                      _buildDropdown<Station>(
                        label: 'From',
                        value: selectedFrom,
                        items: stations,
                        display: (s) => s.name,
                        hintText: 'Select a station',
                        labelColor: darkBlue,
                        onChanged: (s) {
                          setState(() {
                            selectedFrom = s;
                            selectedTrain = null;
                          });
                        },
                      ),
                      _buildDropdown<Station>(
                        label: 'To',
                        value: selectedTo,
                        items: stations,
                        display: (s) => s.name,
                        hintText: 'Select a station',
                        labelColor: darkBlue,
                        onChanged: (s) {
                          setState(() {
                            selectedTo = s;
                            selectedTrain = null;
                          });
                        },
                      ),

                      _buildDropdown<Train>(
                        label: 'Train name',
                        value: selectedTrain,
                        items: filteredTrains,
                        display: (t) => t.trainName,
                        hintText: 'Select a train',
                        labelColor: darkBlue,
                        onChanged: (t) => setState(() => selectedTrain = t),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: darkBlue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: IgnorePointer(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.calendar_today),
                                  label: Text(dateFormatted),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.grey[800],
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.location_on_outlined),
                          onPressed: () {
                            if (selectedTrain != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LiveLocationPage(
                                    selectedTrain: selectedTrain!,
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select a train."),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF58A2F7),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                          label: const Text(
                            'View Live Location',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) display,
    required String hintText,
    required Color labelColor,
    required void Function(T?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: labelColor),
            hint: Text(hintText, style: TextStyle(color: Colors.grey[600])),
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(display(item)),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
