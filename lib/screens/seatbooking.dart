import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'amount.dart'; 

class SeatBookingScreen extends StatefulWidget {
  final int numPassengers;
  final String trainName;
  final DateTime bookingDate;

  const SeatBookingScreen({
    super.key,
    required this.numPassengers,
    required this.trainName,
    required this.bookingDate,
  });

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  List<String> selectedSeats = [];
  Map<String, String> occupiedSeats = {};
  String? selectedCarriage;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchOccupiedSeats();
  }

  void _fetchOccupiedSeats() {
    final String dateKey =
        '${widget.bookingDate.year}-${widget.bookingDate.month.toString().padLeft(2, '0')}-${widget.bookingDate.day.toString().padLeft(2, '0')}';
    final String trainKey = widget.trainName.replaceAll(RegExp(r'[.#$[\]]'), '');

    databaseReference.child('bookings/$trainKey/$dateKey').onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final newOccupiedSeats = <String, String>{};

        data.forEach((bookingId, bookingData) {
          final bookingMap = Map<String, dynamic>.from(bookingData);
          final seats = List<dynamic>.from(bookingMap['seats'] ?? []);
          for (var seat in seats) {
            newOccupiedSeats[seat.toString()] = bookingId;
          }
        });

        setState(() {
          occupiedSeats = newOccupiedSeats;
        });
      } else {
        setState(() {
          occupiedSeats = {};
        });
      }
    });
  }

  Widget _buildSeat(String seatName) {
    bool isSelected = selectedSeats.contains(seatName);
    bool isOccupied = occupiedSeats.containsKey(seatName);
    bool isAvailable = !isOccupied;

    Color seatColor;
    if (isSelected) {
      seatColor = const Color(0xFF1a237e);
    } else if (isOccupied) {
      seatColor = const Color(0xFF4dd0e1);
    } else {
      seatColor = Colors.grey[300]!;
    }

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          setState(() {
            if (isSelected) {
              selectedSeats.remove(seatName);
            } else {
              if (selectedSeats.length < widget.numPassengers) {
                selectedSeats.add(seatName);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'You can only select ${widget.numPassengers} seats.'),
                  ),
                );
              }
            }
          });
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            seatName,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Seat Selection',
          style: TextStyle(
            color: Color(0xFF1a237e),
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Carriage no',
                  style: TextStyle(
                    color: Color(0xFF1a237e),
                    fontSize: 16,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedCarriage,
                  hint: const Text('Select'),
                  items: <String>['Carriage 1', 'Carriage 2', 'Carriage 3']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCarriage = newValue;
                      selectedSeats = [];
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegend(const Color(0xFF1a237e), 'Selected'),
                _buildLegend(const Color(0xFF4dd0e1), 'Occupied'),
                _buildLegend(Colors.grey[300]!, 'Available'),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSeatGrid(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              height: 50,
              child: ElevatedButton(
                onPressed: _onSelectPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58A2F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child:
                            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        'Select',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  Widget _buildSeatGrid() {
    if (selectedCarriage == null) {
      return const Text('Please select a carriage to view and book seats.');
    }

    final List<String> seatRows = ['A', 'B', 'C', 'D'];
    final int numRows = 5;

    return Column(
      children: List.generate(numRows, (rowIndex) {
        final rowNumber = rowIndex + 1;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSeat('${seatRows[0]}$rowNumber'),
              const SizedBox(width: 20),
              _buildSeat('${seatRows[1]}$rowNumber'),
              const SizedBox(width: 40),
              _buildSeat('${seatRows[2]}$rowNumber'),
              const SizedBox(width: 20),
              _buildSeat('${seatRows[3]}$rowNumber'),
            ],
          ),
        );
      }),
    );
  }

  Future<void> _onSelectPressed() async {
    if (selectedSeats.isEmpty || selectedCarriage == null || isSaving) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select carriage and seats first.')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      for (String seat in selectedSeats) {
        if (occupiedSeats.containsKey(seat)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Some of the selected seats are no longer available.'),
            ),
          );
          _fetchOccupiedSeats();
          setState(() {
            isSaving = false;
          });
          return;
        }
      }

      String ticketClass = '3N';
      if (selectedCarriage == 'Carriage 1') {
        ticketClass = '1N';
      } else if (selectedCarriage == 'Carriage 2') {
        ticketClass = '2N';
      }

      await _saveBookingToFirebase();

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AmountScreen(
            numPassengers: widget.numPassengers,
            trainName: widget.trainName,
            ticketClass: ticketClass,
            selectedSeats: selectedSeats,
            bookingDate: widget.bookingDate,
            selectedCarriage: selectedCarriage!,
            onPaymentSuccess: (paymentData) async {
              await _savePaymentInfo(paymentData);
            },
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving booking: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _saveBookingToFirebase() async {
    final String dateKey =
        '${widget.bookingDate.year}-${widget.bookingDate.month.toString().padLeft(2, '0')}-${widget.bookingDate.day.toString().padLeft(2, '0')}';
    final String trainKey = widget.trainName.replaceAll(RegExp(r'[.#$[\]]'), '');

    final newBookingRef = databaseReference.child('bookings/$trainKey/$dateKey').push();
    final bookingId = newBookingRef.key;

    if (bookingId == null) {
      throw Exception('Failed to create booking reference');
    }

    await newBookingRef.set({
      'carriage': selectedCarriage,
      'seats': selectedSeats,
      'timestamp': ServerValue.timestamp,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking confirmed! Your seats: ${selectedSeats.join(', ')}'),
      ),
    );
  }

  Future<void> _savePaymentInfo(Map<String, dynamic> paymentData) async {
    final String dateKey =
        '${widget.bookingDate.year}-${widget.bookingDate.month.toString().padLeft(2, '0')}-${widget.bookingDate.day.toString().padLeft(2, '0')}';
    final String trainKey = widget.trainName.replaceAll(RegExp(r'[.#$[\]]'), '');

    final bookingRef = databaseReference.child('bookings/$trainKey/$dateKey');

    final snapshot = await bookingRef.get();
    if (snapshot.exists) {
      final bookings = Map<String, dynamic>.from(snapshot.value as Map);
      String? bookingId;
      bookings.forEach((key, value) {
        final seats = List<dynamic>.from(value['seats'] ?? []);
        if (seats.toSet().containsAll(selectedSeats) && selectedSeats.toSet().containsAll(seats)) {
          bookingId = key;
        }
      });

      if (bookingId != null) {
        await bookingRef.child(bookingId!).update({'paymentInfo': paymentData});
      }
    }
  }
}
