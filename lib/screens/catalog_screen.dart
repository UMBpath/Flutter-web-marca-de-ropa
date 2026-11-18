import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../data/catalog_data.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialGender;

  const CatalogScreen({super.key, this.initialGender});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late String _selectedGender; // 'todos', 'hombre', 'mujer'
  String _selectedCategory = 'todas';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _categories = ['todas', 'Buzos', 'Camiseta', 'Jeans'];

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender ?? 'todos';
  }

  @override
  void didUpdateWidget(covariant CatalogScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialGender != null && widget.initialGender != _selectedGender) {
      setState(() {
        _selectedGender = widget.initialGender!;
      });
    }
  }

  List<Product> get _filteredProducts {
    return CatalogData.products.where((p) {
      // Filtro de género
      if (_selectedGender != 'todos' && p.genero != _selectedGender) {
        return false;
      }
      // Filtro de categoría
      if (_selectedCategory != 'todas') {
        if (!p.categoria.toLowerCase().contains(_selectedCategory.toLowerCase())) {
          return false;
        }
      }
      // Filtro de búsqueda
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = p.nombre.toLowerCase().contains(query);
        final matchDesc = p.texto.toLowerCase().contains(query);
        final matchCat = p.categoria.toLowerCase().contains(query);
        if (!matchName && !matchDesc && !matchCat) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          "CATÁLOGO",
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.w900,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: AppColors.textPrimary),
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
              decoration: InputDecoration(
                hintText: "Buscar prenda, buzo, camiseta...",
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Selector de Género (Pestañas)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                _buildGenderButton("TODOS", "todos"),
                const SizedBox(width: 8),
                _buildGenderButton("HOMBRE", "hombre"),
                const SizedBox(width: 8),
                _buildGenderButton("MUJER", "mujer"),
              ],
            ),
          ),

          // Selector de Categoría (Chips horizontales)
          Container(
            color: AppColors.surface,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
            child: SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final cat = _categories[idx];
                  final isSelected = _selectedCategory == cat;
                  return ChoiceChip(
                    label: Text(
                      cat.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.card,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    onSelected: (val) {
                      setState(() => _selectedCategory = cat);
                    },
                  );
                },
              ),
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // Lista de resultados
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "No se encontraron prendas",
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Prueba seleccionando otra categoría o término",
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedGender = 'todos';
                              _selectedCategory = 'todas';
                              _searchQuery = '';
                              _searchCtrl.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                          child: const Text("Restablecer filtros"),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      return ProductCard(product: filtered[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderButton(String label, String value) {
    final isSelected = _selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.card,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
