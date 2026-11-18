import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/catalog_data.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  final Function(int tabIndex, String? genero) onNavigateToCatalog;

  const HomeScreen({super.key, required this.onNavigateToCatalog});

  @override
  Widget build(BuildContext context) {
    final featuredProducts = CatalogData.products.take(6).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Center(
                child: Text(
                  "H",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              "HERENCIA",
              style: TextStyle(
                letterSpacing: 2.5,
                fontWeight: FontWeight.w900,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- LOOKBOOK CAROUSEL ---
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "LOOKBOOK 2026",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "EDICIÓN LIMITADA",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: CatalogData.lookbook.length,
                itemBuilder: (context, index) {
                  final item = CatalogData.lookbook[index];
                  return Container(
                    width: 240,
                    margin: const EdgeInsets.only(right: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Imagen (intenta asset local, con fallback a URL)
                        Image.asset(
                          item["imagen"]!,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, _) => Image.network(
                            item["url"]!,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.card,
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                          ),
                        ),
                        // Gradiente de contraste
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.85),
                              ],
                            ),
                          ),
                        ),
                        // Textos
                        Positioned(
                          bottom: 14,
                          left: 14,
                          right: 14,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["titulo"]!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["subtitulo"]!,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            // --- ACCESO A COLECCIONES ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "COLECCIONES",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Tarjeta Hombre
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigateToCatalog(1, 'hombre'),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1618354691373-d851c5c3a99b?auto=format&fit=crop&w=600&q=80",
                                ),
                                fit: BoxFit.cover,
                                opacity: 0.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "HOMBRE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Tarjeta Mujer
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onNavigateToCatalog(1, 'mujer'),
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=600&q=80",
                                ),
                                fit: BoxFit.cover,
                                opacity: 0.5,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "MUJER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- HISTORIA DE MARCA (MANIFIESTO) ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_stories_outlined, color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        "UNA HISTORIA PARA CONTAR",
                        style: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Herencia nace como un archivo visual: siluetas oversize, denim amplio y gráficos que evocan símbolos y raíces urbanas.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Cada pieza está pensada para el confort del día a día y para perdurar en tu rotación de armario.",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- PRODUCTOS DESTACADOS ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "DESTACADOS",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () => onNavigateToCatalog(1, null),
                    child: const Text(
                      "VER TODO ›",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: featuredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.68,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return ProductCard(product: featuredProducts[index]);
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
