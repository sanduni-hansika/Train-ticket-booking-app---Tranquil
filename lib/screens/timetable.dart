import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ticketreservation.dart';

class TimeTableScreen extends StatelessWidget {
  final String departure;
  final String arrival;
  final DateTime date;

  const TimeTableScreen({
    super.key,
    required this.departure,
    required this.arrival,
    required this.date,
  });

  bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  bool isWeekday(DateTime date) {
    return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
  }

  List<Map<String, String>> getFilteredTrains() {
    List<Map<String, String>> trains = [];

    bool weekend = isWeekend(date);
    bool weekday = isWeekday(date);

    if (departure == 'Maradana' && arrival == 'Matara') {
      if (weekday) {
        trains.add({
          'name': 'Galu Kumari',
          'type': 'Express',
          'dep': '1:40 PM',
          'arr': '6:25 PM',
          'route': 'Direct',
          'days': 'Weekdays',
        });
      }
      if (weekend) {
        trains.add({
          'name': 'Ruhunu Kumari',
          'type': 'Express',
          'dep': '3:40 PM',
          'arr': '7:15 PM',
          'route': 'Direct',
          'days': 'Weekend (Sat & Sun)',
        });
      }
    }

    if (departure == 'Anuradhapura' && arrival == 'Jaffna') {
      if (weekday) {
        trains.add({
          'name': 'Yal Rani (No. 4443)',
          'type': 'Express',
          'dep': '2:30 PM',
          'arr': '6:04 PM',
          'route': 'Direct',
          'days': 'Weekdays',
        });
      }
      if (weekend) {
        trains.addAll([
          {
            'name': 'Colombo Commuter (No. 4441)',
            'type': 'Express',
            'dep': '8:20 AM',
            'arr': '11:54 AM',
            'route': 'Direct',
            'days': 'Weekend',
          },
          {
            'name': 'Uttara Devi (No. 4021)',
            'type': 'Express',
            'dep': '9:25 AM',
            'arr': '11:50 AM',
            'route': 'Direct',
            'days': 'Weekend',
          },
        ]);
      }
    }

    if (departure == 'Colombo Fort' && arrival == 'Matara') {
      if (weekend) {
        trains.add({
          'name': 'Express (No. 8766)',
          'type': 'Express',
          'dep': '6:16 PM',
          'arr': '9:55 PM',
          'route': 'Direct',
          'days': 'Weekend',
        });
      }
      if (weekday) {
        trains.addAll([
          {
            'name': 'Long Distance (No. 8094)',
            'type': 'Long Distance',
            'dep': '4:30 PM',
            'arr': '7:20 PM',
            'route': 'Direct',
            'days': 'Weekdays',
          },
          {
            'name': 'Ruhunu Kumari (No. 8058)',
            'type': 'Express',
            'dep': '3:50 PM',
            'arr': '6:56 PM',
            'route': 'Direct',
            'days': 'Weekdays',
          },
          {
            'name': 'Train No. 8050',
            'type': 'Regional',
            'dep': '6:30 AM',
            'arr': '11:57 AM',
            'route': 'Colombo Fort → Beliaththa → Matara',
            'days': 'Weekdays',
          },
        ]);
      }
    }

    if (departure == 'Badulla' && arrival == 'Colombo Fort') {
      trains.add({
        'name': 'Podi Menike',
        'type': 'Express',
        'dep': '4:00 PM',
        'arr': '7:30 AM',
        'route': 'Direct',
        'days': 'All Days',
      });
    }

    return trains;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> results = getFilteredTrains();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF2196F3),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false, 
          title: const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              'Train Time Schedule',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            Text(
              "$departure - $arrival",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2196F3),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('yyyy/MM/dd').format(date),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            if (results.isEmpty)
              const Text("🚫 No trains found for this route and day."),
            Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final train = results[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "# Train name: ${train['name']}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Type: ${train['type']}"),
                          Text("🕐 Departure: ${train['dep']} from $departure"),
                          Text("🕕 Arrival: ${train['arr']} at $arrival"),
                          Text("🛤️ Route: ${train['route']}"),
                          Text("📅 Days: ${train['days']}"),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: SizedBox(
                              width: 150,
                              height: 40,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF58A2F8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => TicketReservation(
                                        initialTrain: train['name']!,
                                        initialDeparture: departure,
                                        initialArrival: arrival,
                                        initialDate: date,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Book Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
