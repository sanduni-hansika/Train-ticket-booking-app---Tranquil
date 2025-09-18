import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Lostfound extends StatefulWidget {
  const Lostfound({super.key});

  @override
  State<Lostfound> createState() => _LostFoundScreenState();
}

class _LostFoundScreenState extends State<Lostfound> {
  final Color primaryColor = const Color(0xFF3176B2);
  final Color subColor = const Color(0xFFE3F2FD);

  final _formKey = GlobalKey<FormState>();
  String? itemType;
  DateTime? selectedDate;
  final TextEditingController descriptionController = TextEditingController();

  Future<void> submitData() async {
    if (_formKey.currentState!.validate() &&
        itemType != null &&
        selectedDate != null) {
      try {
        await FirebaseFirestore.instance.collection('lost_found_items').add({
          'type': itemType,
          'date': selectedDate!.toIso8601String(),
          'description': descriptionController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item submitted successfully!')),
        );

        setState(() {
          itemType = null;
          selectedDate = null;
          descriptionController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving to Firestore: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: subColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Image.asset(
                'assets/images/lostfound.png',
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.category),
                            labelText: 'Select Type',
                            border: OutlineInputBorder(),
                          ),
                          value: itemType,
                          items: ['Lost', 'Found'].map((String type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => itemType = value);
                          },
                          validator: (value) =>
                              value == null ? 'Please select type' : null,
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.calendar_today),
                              labelText: 'Select Date',
                              border: OutlineInputBorder(),
                            ),
                            child: Text(
                              selectedDate == null
                                  ? 'Tap to pick a date'
                                  : DateFormat('yyyy-MM-dd')
                                      .format(selectedDate!),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description),
                            labelText: 'Describe the item',
                            alignLabelWithHint: true,
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                                  ? 'Please enter a description'
                                  : null,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: submitData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(0xFF58A2F8), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
