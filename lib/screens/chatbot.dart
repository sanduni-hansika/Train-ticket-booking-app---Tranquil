import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatBot extends StatefulWidget {
  final String apiUrl;
  final String apiKey;
  final String modelName;

  const ChatBot({
    super.key,
    this.apiUrl="",
    this.apiKey="",
    this.modelName=""
  });

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> chatMessages = [
    {
      "role": "system",
      "content": "Hello! 👋 I'm your virtual assistant. How can I help you today?"
    }
  ];

  bool _isLoading = false;

  Future<void> _sendQuery(String prompt) async {
    setState(() => _isLoading = true);

    chatMessages.add({"role": "user", "content": prompt});

    final data = {
      "model": widget.modelName,
      "messages": chatMessages,
      "temperature": 1,
      "max_completion_tokens": 1024,
      "top_p": 1,
      "stream": false
    };

    try {
      final response = await http.post(
        Uri.parse(widget.apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "",
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botMessage = responseData["choices"][0]["message"]["content"] ?? "No reply";
        chatMessages.add({"role": "assistant", "content": botMessage});
      } else {
        chatMessages.add({
          "role": "assistant",
          "content": "Error: ${response.statusCode} ${response.reasonPhrase ?? ''}",
        });
      }
    } catch (e) {
      chatMessages.add({"role": "assistant", "content": "Error: $e"});
    }

    _controller.clear();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF58A2F7);
    const greyColor = Color(0xFFE0E0E0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Chat Assistant",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  final isBot = message["role"] == "assistant" || message["role"] == "system";
                  return Align(
                    alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      decoration: BoxDecoration(
                        color: isBot ? greyColor : primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
                          bottomRight: isBot ? const Radius.circular(16) : const Radius.circular(0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        message["content"] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: isBot ? Colors.black87 : Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(color: primaryColor),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        filled: true,
                        fillColor: greyColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_controller.text.trim().isNotEmpty) {
                        _sendQuery(_controller.text.trim());
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
