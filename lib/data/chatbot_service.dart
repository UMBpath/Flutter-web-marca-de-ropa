import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class ChatbotService {
  static const String _apiKey = String.fromEnvironment(
    'ANTHROPIC_API_KEY',
    defaultValue: 'YOUR_API_KEY_HERE',
  );
  static const String _model = 'claude-3-sonnet-20240229';

  static const String _systemPrompt = """
Eres el asistente virtual oficial de "Herencia - Gestión de Catálogo de Ropa".
Tu función es ayudar a los clientes exclusivamente con preguntas relacionadas con la tienda, productos, tallas, precios y compras.
Responde de forma concisa, educada y en tono streetwear moderno.

PRODUCTOS PRINCIPALES:
- Buzo Contoda: \$89.99 USD / \$360.000 COP. Tallas: S, M, L, XL. Silueta oversize en felpa.
- Buzo Cóndor: \$95.00 USD. Negro con gráfico en naranja quemado. Tallas S, M, L, XL.
- Buzo Gestión: \$99.99 USD. Pieza firma, capucha amplia. Tallas M, L, XL.
- Buzo Night Walk: \$85.00 USD. S, M, L.
- Camisetas Boxy / Marca: Desde \$39.99 USD / S, M, L, XL. Algodón pesado hombro caído.
- Jeans Wide / Ink: \$79.99 - \$85.00 USD. Tallas 28 a 34.
- Colección Mujer: Buzo Aura (\$89.99), Buzo Duna (\$95.00), Buzo Nocturna (\$99.99), Camisetas (\$35-\$42), Jeans Costa y Sombra.

ENVÍOS Y POLÍTICAS:
- Envíos a todo el país.
- Cambios de talla hasta 30 días después de la compra.
""";

  static Future<String> sendMessage(String userText) async {
    // 1. Intentar llamar a la API de Claude
    try {
      final response = await http
          .post(
            Uri.parse('https://api.anthropic.com/v1/messages'),
            headers: {
              'Content-Type': 'application/json',
              'x-api-key': _apiKey,
              'anthropic-version': '2023-06-01',
            },
            body: jsonEncode({
              'model': _model,
              'max_tokens': 300,
              'system': _systemPrompt,
              'messages': [
                {'role': 'user', 'content': userText}
              ],
            }),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final contentList = data['content'] as List?;
        if (contentList != null && contentList.isNotEmpty) {
          return contentList[0]['text']?.toString().trim() ??
              _fallbackResponse(userText);
        }
      }
    } catch (_) {
      // Si falla la red o la API, pasar fluidamente al motor local inteligente
    }

    return _fallbackResponse(userText);
  }

  static String _fallbackResponse(String prompt) {
    final lower = prompt.toLowerCase();

    if (lower.contains('hola') || lower.contains('buen') || lower.contains('buenas')) {
      return "¡Hola! Bienvenido a Herencia. ¿En qué prenda o colección te puedo colaborar hoy?";
    }
    if (lower.contains('precio') || lower.contains('cuesta') || lower.contains('cuanto')) {
      return "Nuestros buzos oversize van desde \$85 a \$99.99 USD (~ \$340.000 COP), camisetas desde \$35 USD y jeans desde \$75 USD. Puedes revisar el catálogo completo en la pestaña Catálogo.";
    }
    if (lower.contains('talla') || lower.contains('medida')) {
      return "Manejamos tallas desde S hasta XL en buzos y camisetas para hombre, y de XS a L en mujer. Los jeans están disponibles desde la talla 28 a la 34 en hombre, y 24 a 30 en mujer. Nuestro corte es oversize.";
    }
    if (lower.contains('buzo') || lower.contains('hoodie') || lower.contains('saco')) {
      return "Contamos con los buzos icónicos: Contoda, Cóndor, Gestión (firma) y Night Walk para hombre; y Aura, Duna y Nocturna para mujer. Todos fabricados en felpa pesada de alta calidad.";
    }
    if (lower.contains('envio') || lower.contains('despacho') || lower.contains('llegar')) {
      return "Realizamos envíos nacionales e internacionales seguros con número de seguimiento directo.";
    }
    if (lower.contains('cambio') || lower.contains('devolucion') || lower.contains('garantia')) {
      return "Tienes hasta 30 días para solicitar cambios de talla manteniendo las marquillas y el estado original de la prenda.";
    }
    if (lower.contains('pago') || lower.contains('tarjeta')) {
      return "Aceptamos pagos con tarjeta de crédito o débito (Visa, Mastercard, American Express). El proceso de pago es 100% encriptado.";
    }

    return "Gracias por tu mensaje. Para consultar información sobre alguna prenda en particular (buzos, camisetas, jeans o tallas), pregúntame directamente o explora la sección Catálogo.";
  }
}
