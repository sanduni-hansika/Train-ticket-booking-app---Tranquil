import 'package:flutter/material.dart';

class Contact2 extends StatelessWidget {
  final String department;
  const Contact2({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    const contactData = {
      'Colombo Fort': [
        '0413256707',
        '0712345345',
        'kalaniyarailway56@gmail.com',
        '0712345678',
      ],
      'Anuradhapura': [
        '0252233445',
        '0778877665',
        'anurail@slrail.lk',
        '0771234567',
      ],
      'Matara': [
        '0412233445',
        '0768877665',
        'matararail@slrail.lk',
        '0761234567',
      ],
      'Maradana': [
        '0112122334',
        '0716677889',
        'maradana@slrail.lk',
        '0711122334',
      ],
      'Jaffna': [
        '0213456789',
        '0777777777',
        'jaffnarail@slrail.lk',
        '0771234567',
      ],
      'Badulla': [
        '0554455667',
        '0752233445',
        'badullarail@slrail.lk',
        '0751122334',
      ],
      'Galle': [
        '0912233445',
        '0726677889',
        'gallerail@slrail.lk',
        '0721234567',
      ],
    };

    final data = contactData[department]!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset('assets/images/contact.png', height: 110),
                      const SizedBox(height: 10),
                      Text(
                        department,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView(
                    children: [
                      contactCard(
                        "📞 Department Contact No.",
                        "${data[0]}\n${data[1]}",
                      ),
                      contactCard("✉️ Email", data[2]),
                      contactCard("🔒 Security Helpline", data[3]),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F0FD),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.blue.shade100),
                        ),
                        child: const Text(
                          "⚠️ Using these contact numbers or emails improperly carries penalties.",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Widget contactCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 170, 
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 45,  
                ),
                alignment: Alignment.topLeft,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
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
