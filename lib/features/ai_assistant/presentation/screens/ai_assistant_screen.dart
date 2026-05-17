import 'package:flutter/material.dart';
import 'package:itrip/core/theme/app_colors.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[
    const _ChatMessage(
      isUser: false,
      text:
          'Hi! I\'m your iTrip AI travel advisor. Ask me about routes, destinations, hotels, weather, or emergency advice for your India road trip!',
    ),
  ];

  final _suggestions = [
    'Best route Bangalore to Coorg?',
    'Hotels in Coorg under ₹3000',
    'Is it safe to ride at night?',
    'Rain alert for Western Ghats',
  ];

  void _send(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(isUser: true, text: text));
      _messages.add(_ChatMessage(
        isUser: false,
        text: _generateResponse(text),
      ));
    });
    _controller.clear();
  }

  String _generateResponse(String query) {
    final q = query.toLowerCase();
    if (q.contains('route') || q.contains('coorg')) {
      return 'For Bangalore to Coorg, I recommend the scenic route via Kushalnagar (265 km, ~6 hrs). Start before 7 AM to avoid traffic. The ghat section needs caution — preview it in Experience Before You Travel!';
    }
    if (q.contains('hotel')) {
      return 'Top picks in Coorg: Orange County (luxury), Taj Madikeri (premium), and homestays in Madikeri (budget ₹1500-2500/night). Book early for weekends!';
    }
    if (q.contains('night') || q.contains('safe')) {
      return 'Night riding on ghat roads scores 5.5/10 safety. Avoid if possible. If riding at night: full beam headlights, reflective gear, and no overtaking on curves.';
    }
    if (q.contains('rain')) {
      return '⚠️ Rain alert: Western Ghats expected light rain this weekend. Roads get slippery near Madikeri. Carry rain gear and reduce speed by 30% on ghats.';
    }
    return 'Great question! I\'m analyzing travel data for you. For detailed route info, check Routes → Experience Preview. For budget, use the Budget Estimator. How else can I help?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: AppColors.primary),
            SizedBox(width: 8),
            Text('AI Travel Advisor'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _ChatBubble(message: _messages[i]),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _suggestions.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  label: Text(_suggestions[i], style: const TextStyle(fontSize: 11)),
                  onPressed: () => _send(_suggestions[i]),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask about routes, hotels, weather...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: _send,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  onPressed: () => _send(_controller.text),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  const _ChatMessage({required this.isUser, required this.text});

  final bool isUser;
  final String text;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.primary
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? Colors.white : null,
          ),
        ),
      ),
    );
  }
}
