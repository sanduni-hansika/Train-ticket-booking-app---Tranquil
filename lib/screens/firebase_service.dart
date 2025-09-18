
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  
  Future<String?> saveBooking(Map<String, dynamic> bookingData) async {
    try {
      final ref = _db.child('bookings').push();
      await ref.set(bookingData);
      return ref.key;
    } catch (e) {
      
      return null;
    }
  }
}
