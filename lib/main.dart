import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'data/cart_state.dart';
import 'screens/home_screen.dart';
import 'screens/catalog_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HerenciaApp());
}

class HerenciaApp extends StatelessWidget {
  const HerenciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Herencia Streetwear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String? _catalogGenderFilter;
  final CartState _cartState = CartState();

  @override
  void initState() {
    super.initState();
    _cartState.addListener(_onCartChanged);
  }

  @override
  void dispose() {
    _cartState.removeListener(_onCartChanged);
    super.dispose();
  }

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  void _navigateToCatalogWithFilter(int tabIndex, String? genero) {
    setState(() {
      _currentIndex = tabIndex;
      _catalogGenderFilter = genero;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(onNavigateToCatalog: _navigateToCatalogWithFilter),
      CatalogScreen(initialGender: _catalogGenderFilter),
      CartScreen(onContinueShopping: () => setState(() => _currentIndex = 1)),
      const ChatbotScreen(),
      const ProfileScreen(),
    ];

    final cartCount = _cartState.totalItemCount;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index != 1) {
                _catalogGenderFilter = null;
              }
            });
          },
          backgroundColor: AppColors.surface,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Inicio",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: "Catálogo",
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text("$cartCount"),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text("$cartCount"),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.shopping_bag),
              ),
              label: "Carrito",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: "Asistente",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Cuenta",
            ),
          ],
        ),
      ),
    );
  }
}
