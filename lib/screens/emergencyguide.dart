import 'package:flutter/material.dart';

class EmergencyGuide extends StatelessWidget {
  const EmergencyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    const _ = Color(0xFF58A2F7);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Column(
              children: [
                Image.asset('assets/images/alert.png', height: 100),
                const SizedBox(height: 12),
                const Text(
                  "Emergency Guide",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF21114D),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF58A2F7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "In the event of a train derailment, fire, or any major emergency, follow these essential safety instructions to protect yourself and others.",
                        style: TextStyle(
                          fontSize: 15.5,
                          color: Color(0xFF21114D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),
                    guideBullet(
                      Color(0xFF58A2F7),
                      "Stay Calm",
                      "Panicking will only make the situation worse. Try to stay calm and composed.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Stay Seated if Possible",
                      "If the train comes to a sudden stop or derails, try to remain seated to avoid injuries.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Use Emergency Brakes Only If Necessary",
                      "Only use emergency brakes in extreme conditions, as abrupt stopping can lead to more injuries.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                     Color(0xFF58A2F7),
                      "Exit Safely",
                      "If evacuation is required, use designated exits and help others if possible. Avoid jumping from windows.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Avoid Broken Glass",
                      "Stay away from shattered windows or doors to prevent cuts and other injuries.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Do Not Touch Wires",
                      "In case of damage to the train's electrical systems, avoid touching any loose or hanging wires.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Assist the Elderly and Disabled",
                      "Help passengers who need assistance, such as the elderly, children, or injured individuals.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Move to a Safe Distance",
                      "After exiting the train, move to a safe area away from the tracks and train.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Call Emergency Services",
                      "Dial local emergency numbers or notify train staff to report injuries or hazards.",
                    ),
                    const SizedBox(height: 10),

                    guideBullet(
                      Color(0xFF58A2F7),
                      "Follow Train Staff Instructions",
                      "Always listen to and follow announcements or guidance from official train personnel.",
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget guideBullet(Color primaryColor, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 8, color: primaryColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                children: [
                  TextSpan(
                    text: "$title: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF21114D),
                    ),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
