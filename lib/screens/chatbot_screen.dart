import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/chatbot_service.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  bool _isLoading = false;

  final List<String> _suggestions = [
    "¿Qué buzos hay disponibles?",
    "¿Qué tallas manejan?",
    "¿Hacen envíos nacionales?",
    "¿Precios en pesos colombianos?",
  ];

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida inicial
    _messages.add(
      ChatMessage(
        text: "¡Hola! Soy el asistente virtual de Herencia. Puedo ayudarte con dudas sobre nuestro catálogo de ropa streetwear, tallas, precios y pedidos. ¿En qué te puedo asesorar hoy?",
        isUser: false,
      ),
    );
  }

  void _sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || _isLoading) return;

    _textCtrl.clear();
    setState(() {
      _messages.add(ChatMessage(text: trimmed, isUser: true));
      _isLoading = true;
    });

    _scrollToBottom();

    final reply = await ChatbotService.sendMessage(trimmed);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _messages.add(ChatMessage(text: reply, isUser: false));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ASISTENTE HERENCIA",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                Text(
                  "● En línea 24/7",
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sugerencias rápidas
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              height: 32,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _suggestions.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  return ActionChip(
                    label: Text(
                      _suggestions[idx],
                      style: const TextStyle(fontSize: 11, color: AppColors.textPrimary),
                    ),
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    onPressed: () => _sendMessage(_suggestions[idx]),
                  );
                },
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Lista de mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildBubble(msg);
              },
            ),
          ),

          // Indicador de "Escribiendo..."
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Herencia está respondiendo...",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),

          // Input de texto
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textCtrl,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: "Escribe tu pregunta sobre la tienda...",
                        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        filled: true,
                        fillColor: AppColors.card,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(_textCtrl.text),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send, color: Colors.white, size: 18),
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

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: msg.isUser ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(14),
            topRight: const Radius.circular(14),
            bottomLeft: Radius.circular(msg.isUser ? 14 : 2),
            bottomRight: Radius.circular(msg.isUser ? 2 : 14),
          ),
          border: msg.isUser ? null : Border.all(color: AppColors.border),
        ),
        child: Text(
          msg.text,
          style: TextStyle(
            color: msg.isUser ? Colors.white : AppColors.textPrimary,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
