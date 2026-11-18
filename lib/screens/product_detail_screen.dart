import 'package:flutter/material.dart';
import '../models/product.dart';
import '../constants/app_colors.dart';
import '../data/cart_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    if (widget.product.tallas.isNotEmpty) {
      _selectedSize = widget.product.tallas.first;
    }
  }

  void _addToCart() {
    if (_selectedSize == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor selecciona una talla"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    CartState().addItem(widget.product, _selectedSize!);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.card,
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "${widget.product.nombre} (Talla $_selectedSize) añadido al carrito",
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: "VER",
          textColor: AppColors.primary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          product.nombre.toUpperCase(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Enlace del producto copiado")),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Galería de imágenes
            SizedBox(
              height: 380,
              child: Stack(
                children: [
                  PageView.builder(
                    itemCount: product.fotos.length,
                    onPageChanged: (index) {
                      setState(() => _currentImageIndex = index);
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        product.fotos[index],
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, _, __) => Container(
                          color: AppColors.card,
                          child: const Icon(
                            Icons.broken_image,
                            size: 60,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                  // Indicador de puntos
                  if (product.fotos.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          product.fotos.length,
                          (i) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentImageIndex == i ? 20 : 7,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentImageIndex == i
                                  ? AppColors.primary
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Categoría y género
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary),
                        ),
                        child: Text(
                          product.categoria.toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          product.genero == 'hombre' ? 'COLECCIÓN HOMBRE' : 'COLECCIÓN MUJER',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Nombre
                  Text(
                    product.nombre,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Precios
                  Row(
                    children: [
                      Text(
                        product.precioFormateado,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "(${product.precioCOP})",
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Divider(color: AppColors.border),
                  const SizedBox(height: 14),

                  // Selector de tallas
                  const Text(
                    "SELECCIONAR TALLA",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    children: product.tallas.map((talla) {
                      final isSelected = _selectedSize == talla;
                      return ChoiceChip(
                        label: Text(
                          talla,
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        onSelected: (val) {
                          if (val) setState(() => _selectedSize = talla);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Descripción
                  const Text(
                    "DETALLES DE LA PRENDA",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.texto,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Beneficios / Info adicional
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.local_shipping_outlined, color: AppColors.primary, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Envío rápido asegurado con tracking",
                                style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.autorenew, color: AppColors.primary, size: 20),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "30 días para cambios de talla sin costo",
                                style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 10),
                Text(
                  "AÑADIR AL CARRITO",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
