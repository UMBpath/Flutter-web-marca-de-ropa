import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../data/cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final CartState _cartState = CartState();

  final _nameCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  bool _isProcessing = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cardCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    // Simulación de procesamiento seguro
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Diálogo de éxito
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              "¡PAGO EXITOSO!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Gracias por tu compra en Herencia. Tu pedido #${DateTime.now().millisecondsSinceEpoch.toString().substring(7)} ha sido confirmado y está en preparación.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _cartState.clearCart();
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text("VOLVER AL INICIO"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          "PAGO SEGURO",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner de seguridad
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, color: AppColors.success, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transacción Encriptada SSL",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            "Tus datos de pago viajan de forma 100% segura",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Marcas de tarjetas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "TARJETA DE CRÉDITO O DÉBITO",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Row(
                    children: [
                      _cardBadge("VISA"),
                      const SizedBox(width: 6),
                      _cardBadge("MC"),
                      const SizedBox(width: 6),
                      _cardBadge("AMEX"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Nombre en la tarjeta
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Nombre del titular de la tarjeta", Icons.person_outline),
                validator: (val) => val == null || val.trim().isEmpty ? "Ingresa el nombre del titular" : null,
              ),
              const SizedBox(height: 14),

              // Número de tarjeta
              TextFormField(
                controller: _cardCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                style: const TextStyle(color: Colors.white, letterSpacing: 1.5),
                decoration: _inputDecoration("Número de tarjeta (16 dígitos)", Icons.credit_card_outlined),
                validator: (val) {
                  if (val == null || val.length < 15) return "Número de tarjeta inválido";
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Fila Vencimiento y CVV
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(5),
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("MM/AA", Icons.calendar_today_outlined),
                      validator: (val) => val == null || val.isEmpty ? "Ingresa MM/AA" : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: TextFormField(
                      controller: _cvvCtrl,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration("CVV", Icons.security_outlined),
                      validator: (val) => val == null || val.length < 3 ? "Ingresa CVV" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Dirección de envío
              const Text(
                "DIRECCIÓN DE ENTREGA",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration("Dirección completa, ciudad y apto", Icons.local_shipping_outlined),
                validator: (val) => val == null || val.trim().isEmpty ? "Ingresa tu dirección de envío" : null,
              ),

              const SizedBox(height: 30),

              // Resumen de total a pagar
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Monto a cobrar:", style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          _cartState.totalAmountFormatted,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("En pesos colombianos:", style: TextStyle(color: AppColors.textSecondary)),
                        Text(
                          _cartState.totalCOPFormatted,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Botón de pago
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          "PAGAR ${_cartState.totalAmountFormatted}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            letterSpacing: 1.0,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBadge(String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        name,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
