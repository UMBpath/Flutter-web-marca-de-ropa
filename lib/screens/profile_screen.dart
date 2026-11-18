import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoggedIn = false;
  String _userName = "Usuario Demo";
  String _userEmail = "usuario@herencia.co";

  void _toggleLogin() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLoggedIn ? "Sesión iniciada con Google" : "Sesión cerrada correctamente"),
        backgroundColor: _isLoggedIn ? AppColors.success : AppColors.card,
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
          "CUENTA Y POLÍTICAS",
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Tarjeta de perfil
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.card,
                    child: Icon(
                      _isLoggedIn ? Icons.person : Icons.person_outline,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isLoggedIn ? _userName : "Invitado",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isLoggedIn ? _userEmail : "Inicia sesión para guardar favoritos y pedidos",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _toggleLogin,
                    icon: Icon(_isLoggedIn ? Icons.logout : Icons.login, size: 18),
                    label: Text(_isLoggedIn ? "Cerrar Sesión" : "Continuar con Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isLoggedIn ? AppColors.card : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Opciones y Políticas
            _buildSectionTitle("INFORMACIÓN Y SOPORTE"),
            const SizedBox(height: 10),
            _buildTile(
              icon: Icons.shield_outlined,
              title: "Política de Privacidad",
              subtitle: "Protección de datos conforme a la ley colombiana",
              onTap: () => _showInfoModal("Política de Privacidad", "Tus datos personales son tratados bajo estrictas medidas de seguridad y confidencialidad en conformidad con la Ley 1581 de 2012 de Colombia."),
            ),
            _buildTile(
              icon: Icons.local_shipping_outlined,
              title: "Políticas de Envío",
              subtitle: "Entregas en 2 a 5 días hábiles a nivel nacional",
              onTap: () => _showInfoModal("Envíos", "Realizamos envíos a toda Colombia. Una vez procesado el pago recibirás un código de rastreo por correo o WhatsApp."),
            ),
            _buildTile(
              icon: Icons.assignment_return_outlined,
              title: "Cambios y Devoluciones",
              subtitle: "Hasta 30 días para solicitar cambios de talla",
              onTap: () => _showInfoModal("Cambios y Garantías", "Puedes solicitar cambio de talla de cualquier prenda dentro de los 30 días posteriores a la recepción, presentando la prenda sin uso y con sus etiquetas."),
            ),
            _buildTile(
              icon: Icons.camera_alt_outlined,
              title: "Instagram Oficial",
              subtitle: "@her3ncia",
              onTap: () => _showInfoModal("Instagram", "Visita nuestra cuenta oficial @her3ncia en Instagram para ver las últimas fotos del lookbook y lanzamientos."),
            ),

            const SizedBox(height: 30),

            // Marca / Créditos
            const Text(
              "GESTIÓN DE CATÁLOGO DE ROPA",
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Arquitectura de Software - 4to Semestre\nVersión 1.0.0 (Flutter Mobile)",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }

  void _showInfoModal(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: AppColors.textSecondary, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("ENTENDIDO", style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}
