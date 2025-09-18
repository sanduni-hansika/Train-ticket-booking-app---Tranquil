import 'package:flutter/material.dart';
import 'contact2.dart';

class Contact1 extends StatefulWidget {
  const Contact1({super.key});

  @override
  State<Contact1> createState() => _Contact1State();
}

class _Contact1State extends State<Contact1> {
  final List<String> departments = const [
    'Colombo Fort',
    'Anuradhapura',
    'Matara',
    'Maradana',
    'Jaffna',
    'Badulla',
    'Galle',
  ];

  String? selectedDepartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0FD),
      body: Stack(
        children: [
          Container(
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80),
              ),
            ),
            child: Center(
              child: Column(
                children: const [
                  SizedBox(height: 75),
                  Text(
                    'Select Department',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 180, 24, 24),
              child: Column(
                children: [
                  Image.asset('assets/images/contact.png', height: 170),
                  const SizedBox(height: 80),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF2196F3), width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: SizedBox(
                        width: 230,
                        child: DropdownButton<String>(
                          hint: const Text(
                            "Select Department",
                            style: TextStyle(fontSize: 16),
                          ),
                          value: selectedDepartment,
                          icon: const Icon(Icons.arrow_drop_down),
                          dropdownColor: Colors.white,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          items: departments.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedDepartment = value!;
                            });
                          },
                          isExpanded: true, 
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: selectedDepartment == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Contact2(department: selectedDepartment!),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                        disabledBackgroundColor: const Color(0xFF2196F3),
                        disabledForegroundColor: Colors.white,
                      ),
                      child: const Text("View Contact"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
