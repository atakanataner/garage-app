import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import '../widgets/category_chip.dart';
import '../widgets/promo_banner.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';
import 'admin_panel_screen.dart';

/// Garage Keşfet & Ana Sayfa Ekranı
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();
  final List<CartItem> _cartItems = [];

  String _selectedCategory = 'Tümü';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  int get _cartTotalCount =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _addToCart(CartItem item) {
    setState(() {
      final existingIndex = _cartItems.indexWhere((ci) =>
          ci.product.id == item.product.id &&
          ci.selectedSize == item.selectedSize);

      if (existingIndex != -1) {
        _cartItems[existingIndex].quantity += item.quantity;
      } else {
        _cartItems.add(item);
      }
    });
  }

  void _quickAddToCart(Product product) {
    final defaultSize =
        product.sizes.isNotEmpty ? product.sizes.first : 'Standart';
    _addToCart(CartItem(product: product, selectedSize: defaultSize, quantity: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF222222),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF444444)),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${product.name} sepete eklendi!',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToDetail(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          product: product,
          cartItems: _cartItems,
          onAddToCart: _addToCart,
        ),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          cartItems: _cartItems,
          onCartUpdated: () => setState(() {}),
        ),
      ),
    );
  }

  void _navigateToAuthOrProfile() {
    if (_authService.isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  void _navigateToAdminPanel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AdminPanelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_productService, _authService]),
      builder: (context, _) {
        final allProducts = _productService.products;
        final categories = _productService.categories;
        final isAdmin = _authService.isAdmin;
        final isLoggedIn = _authService.isLoggedIn;

        final filteredProducts = allProducts.where((product) {
          final matchesCategory = _selectedCategory == 'Tümü' ||
              product.category.toLowerCase() == _selectedCategory.toLowerCase();
          final matchesSearch = product.name
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              product.category
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
          return matchesCategory && matchesSearch;
        }).toList();

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          floatingActionButton: isAdmin
              ? FloatingActionButton.extended(
                  onPressed: _navigateToAdminPanel,
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                  icon: const Icon(Icons.add_box, size: 20),
                  label: const Text(
                    'ÜRÜN EKLE (ADMIN)',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      fontSize: 13,
                    ),
                  ),
                )
              : null,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                // Üst Başlık, Profil ve Sepet Butonları
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo & Slogan
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'GARAGE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'STUDIO',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Sokak Modası & Lifestyle',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        // Sağ Butonlar (Profil / Admin Girişi + Sepet)
                        Row(
                          children: [
                            // Profil / Admin Butonu
                            Material(
                              color: isAdmin
                                  ? Colors.orangeAccent.withValues(alpha: 0.15)
                                  : const Color(0xFF1E1E1E),
                              shape: const CircleBorder(),
                              child: IconButton(
                                tooltip: isLoggedIn ? 'Profilim' : 'Giriş Yap',
                                icon: Icon(
                                  isAdmin
                                      ? Icons.admin_panel_settings
                                      : (isLoggedIn
                                          ? Icons.person
                                          : Icons.person_outline),
                                  color: isAdmin
                                      ? Colors.orangeAccent
                                      : Colors.white,
                                ),
                                onPressed: _navigateToAuthOrProfile,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Sepet Butonu
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Material(
                                  color: const Color(0xFF1E1E1E),
                                  shape: const CircleBorder(),
                                  child: IconButton(
                                    tooltip: 'Sepetim',
                                    icon: const Icon(
                                      Icons.shopping_bag_outlined,
                                      color: Colors.white,
                                    ),
                                    onPressed: _navigateToCart,
                                  ),
                                ),
                                if (_cartTotalCount > 0)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.orangeAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        '$_cartTotalCount',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Admin Aktif Bannerı (Eğer Admin Girişi Yapılmışsa)
                if (isAdmin)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.verified_user, color: Colors.orangeAccent, size: 18),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Yönetici Modu Aktif',
                                      style: TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'admin@admin.com',
                                      style: TextStyle(color: Colors.white70, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: _navigateToAdminPanel,
                              icon: const Icon(Icons.add, size: 16, color: Colors.orangeAccent),
                              label: const Text(
                                'Ürün Ekle',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E1E),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Arama Kutusu
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Hoodie, t-shirt, sneaker veya ürün ara...',
                        hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.white70),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFF1C1C1E),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Colors.white70),
                        ),
                      ),
                    ),
                  ),
                ),

                // Kampanya Bannerı
                const SliverToBoxAdapter(
                  child: PromoBanner(),
                ),

                // Kategoriler (Yatay Kaydırma)
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return CategoryChip(
                          label: category,
                          isSelected: _selectedCategory == category,
                          onTap: () => _onCategorySelected(category),
                        );
                      },
                    ),
                  ),
                ),

                // Başlık & Ürün Sayısı
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedCategory == 'Tümü'
                              ? 'TÜM PARÇALAR'
                              : _selectedCategory.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          '${filteredProducts.length} Ürün',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ürünler Grid Görünümü
                if (filteredProducts.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.search_off_outlined,
                            size: 54,
                            color: Colors.white38,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ürün Bulunamadı',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Arama kriterlerinizi değiştirerek tekrar deneyebilirsiniz.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                              _onCategorySelected('Tümü');
                            },
                            child: const Text(
                              'Filtreleri Temizle',
                              style: TextStyle(color: Colors.orangeAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filteredProducts[index];
                          return ProductCard(
                            product: product,
                            onTap: () => _navigateToDetail(product),
                            onFavoriteToggle: () {
                              _productService.toggleFavorite(product.id);
                            },
                            onQuickAddToCart: () => _quickAddToCart(product),
                          );
                        },
                        childCount: filteredProducts.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
