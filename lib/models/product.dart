class Product {
  final String id;
  final String nombre;
  final String categoria;
  final double precio;
  final List<String> tallas;
  final String texto;
  final List<String> fotos;
  final String genero; // 'hombre' o 'mujer'

  const Product({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.precio,
    required this.tallas,
    required this.texto,
    required this.fotos,
    required this.genero,
  });

  String get precioFormateado {
    // Formato con separador de miles o decimal
    return "\$ ${precio.toStringAsFixed(2)} USD";
  }

  String get precioCOP {
    // Equivalente aproximado en COP (ej. $70,000 COP)
    final valorCop = (precio * 4000).round();
    final formatted = valorCop.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
    return "\$ $formatted COP";
  }
}
