import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

/// Garage Yönetici Paneli ve Ürün Ekleme Ekranı
class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AuthService _authService = AuthService();
  final ProductService _productService = ProductService();

  final _formKey = GlobalKey<FormState>();

  // Form Controller'ları
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fabricController = TextEditingController();
  final TextEditingController _fitController = TextEditingController();
  final TextEditingController _customSizeController = TextEditingController();
  final TextEditingController _customCategoryController =
      TextEditingController();

  // Seçili Bedenler & Kategori
  String _selectedCategory = 'Hoodie';
  final List<String> _selectedSizes = ['S', 'M', 'L', 'XL'];
  bool _isFeatured = true;

  // Hızlı Görsel Şablonları (Unsplash Streetwear)
  final List<Map<String, String>> _sampleImages = [
    {
      'title': 'Acid Hoodie',
      'url':
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Cyber Tee',
      'url':
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Leather Bomber',
      'url':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Cargo Pants',
      'url':
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Chunky Sneaker',
      'url':
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Crossbody Bag',
      'url':
          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Vintage Cap',
      'url':
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?auto=format&fit=crop&w=800&q=80',
    },
  ];

  final List<String> _availableSizes = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    'Standart',
    '30',
    '32',
    '34',
    '36',
    '40',
    '41',
    '42',
    '43',
    '44',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Varsayılan görsel olarak birinci örnek atanır
    _imageUrlController.text = _sampleImages[0]['url']!;
    _fabricController.text = '%100 Ağır Gramaj Pamuk (450 GSM)';
    _fitController.text = 'Oversized Street Fit';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _imageUrlController.dispose();
    _descriptionController.dispose();
    _fabricController.dispose();
    _fitController.dispose();
    _customSizeController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  void _submitNewProduct() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedSizes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen en az bir beden seçeneği ekleyin.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
    final originalPriceText = _originalPriceController.text.trim();
    final originalPrice = originalPriceText.isNotEmpty
        ? double.tryParse(originalPriceText.replaceAll(',', '.'))
        : null;

    final newProduct = Product(
      id: _productService.generateNewId(),
      name: _nameController.text.trim(),
      category: _selectedCategory,
      price: price,
      originalPrice: originalPrice,
      description: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'GARAGE yeni sezon özel tasarım koleksiyon ürünü.',
      imageUrl: _imageUrlController.text.trim(),
      rating: 5.0,
      reviewCount: 1,
      sizes: List.from(_selectedSizes),
      specifications: {
        if (_fabricController.text.isNotEmpty)
          'Kumaş': _fabricController.text.trim(),
        if (_fitController.text.isNotEmpty)
          'Kalıp': _fitController.text.trim(),
        'Koleksiyon': 'Garage Studio 2026',
        'Menşei': 'Türkiye',
      },
      isFeatured: _isFeatured,
      isFavorite: false,
    );

    _productService.addProduct(newProduct);

    // Formu temizle
    _nameController.clear();
    _priceController.clear();
    _originalPriceController.clear();
    _descriptionController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.greenAccent),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${newProduct.name} başarıyla eklendi!',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Mağazada Gör',
          textColor: Colors.orangeAccent,
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );

    // Ürünler sekmesine geç
    _tabController.animateTo(1);
  }

  void _showAddCustomSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Özel Beden Ekle',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: _customSizeController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Örn: 38, 46, Standart, One Size',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final size = _customSizeController.text.trim();
              if (size.isNotEmpty && !_selectedSizes.contains(size)) {
                setState(() {
                  _selectedSizes.add(size);
                });
              }
              _customSizeController.clear();
              Navigator.pop(context);
            },
            child: const Text('Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showAddCustomCategoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Yeni Kategori Oluştur',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: _customCategoryController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Örn: Şort, Çorap, Gözlük',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.orangeAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final cat = _customCategoryController.text.trim();
              if (cat.isNotEmpty) {
                setState(() {
                  _selectedCategory = cat;
                });
              }
              _customCategoryController.clear();
              Navigator.pop(context);
            },
            child: const Text('Seç', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteProduct(Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Ürünü Sil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Text(
          '${product.name} ürününü katalogdan silmek istediğinize emin misiniz?',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Vazgeç', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _productService.deleteProduct(product.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ürün başarıyla silindi.'),
                  backgroundColor: Color(0xFF2C2C2E),
                ),
              );
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_productService, _authService]),
      builder: (context, _) {
        final products = _productService.products;
        final categories = _productService.categories
            .where((c) => c != 'Tümü')
            .toList();

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GARAGE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ADMIN',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: 'Çıkış Yap',
                onPressed: () {
                  _authService.logout();
                  Navigator.pop(context);
                },
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.orangeAccent,
              indicatorWeight: 3,
              labelColor: Colors.orangeAccent,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                const Tab(
                  icon: Icon(Icons.add_box_outlined, size: 20),
                  text: 'Yeni Ürün Ekle',
                ),
                Tab(
                  icon: const Icon(Icons.inventory_2_outlined, size: 20),
                  text: 'Ürünleri Yönet (${products.length})',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              // TAB 1: ÜRÜN EKLEME FORMU
              _buildAddProductTab(categories),

              // TAB 2: MEVCUT ÜRÜNLERİ YÖNETME
              _buildManageProductsTab(products),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddProductTab(List<String> categories) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Admin Bilgi Bannerı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 18,
                  child: Icon(Icons.admin_panel_settings, color: Colors.black, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Yönetici Modu Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        _authService.currentUser?.email ?? 'admin@admin.com',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'CANLI KATALOG',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 1. GÖRSEL VE CANLI ÖNİZLEME
          _buildSectionHeader('1. ÜRÜN GÖRSELİ (FOTOĞRAF)', Icons.image_outlined),
          const SizedBox(height: 10),

          // Canlı Görsel Önizleme Kutusu
          Center(
            child: Container(
              height: 180,
              width: 140,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF333333)),
              ),
              clipBehavior: Clip.antiAlias,
              child: _imageUrlController.text.isNotEmpty
                  ? Image.network(
                      _imageUrlController.text,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image, color: Colors.grey, size: 36),
                          SizedBox(height: 6),
                          Text(
                            'Geçersiz URL',
                            style: TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.add_a_photo, color: Colors.grey, size: 36),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          // Görsel URL TextField
          TextFormField(
            controller: _imageUrlController,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (val) => setState(() {}),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Lütfen bir görsel URL girin veya aşağıdan seçin.';
              }
              return null;
            },
            decoration: _inputDecoration(
              label: 'Görsel URL Adresi',
              hint: 'https://images.unsplash.com/...',
              prefixIcon: Icons.link,
            ),
          ),
          const SizedBox(height: 10),

          // Hızlı Hazır Görseller Başlığı & Yatay Seçici
          const Text(
            'Hızlı Seçim (Örnek Sokak Modası Görselleri):',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sampleImages.length,
              itemBuilder: (context, index) {
                final item = _sampleImages[index];
                final isSelected = _imageUrlController.text == item['url'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _imageUrlController.text = item['url']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? Colors.orangeAccent
                            : const Color(0xFF333333),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item['url']!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            item['title']!,
                            style: TextStyle(
                              color: isSelected ? Colors.orangeAccent : Colors.white,
                              fontSize: 11,
                              fontWeight:
                                  isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 2. ÜRÜN BİLGİLERİ VE KATEGORİ
          _buildSectionHeader('2. TEMEL BİLGİLER & KATEGORİ', Icons.category_outlined),
          const SizedBox(height: 10),

          // Ürün Adı
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Lütfen ürün adını giriniz.';
              }
              return null;
            },
            decoration: _inputDecoration(
              label: 'Ürün İsmi',
              hint: 'Örn: Garage Heavyweight Boxy Hoodie',
              prefixIcon: Icons.title,
            ),
          ),
          const SizedBox(height: 14),

          // Kategori Seçici
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: categories.contains(_selectedCategory)
                      ? _selectedCategory
                      : categories.first,
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: _inputDecoration(
                    label: 'Kategori',
                    hint: 'Kategori Seçin',
                    prefixIcon: Icons.style,
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategory = val;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.orangeAccent),
                tooltip: 'Yeni Kategori Ekle',
                onPressed: _showAddCustomCategoryDialog,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 3. FİYATLANDIRMA
          _buildSectionHeader('3. FİYATLANDIRMA', Icons.payments_outlined),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Satış fiyatı zorunludur.';
                    }
                    if (double.tryParse(val.replaceAll(',', '.')) == null) {
                      return 'Geçerli sayı girin.';
                    }
                    return null;
                  },
                  decoration: _inputDecoration(
                    label: 'Satış Fiyatı (TL)',
                    hint: '890.00',
                    prefixIcon: Icons.attach_money,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _originalPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: _inputDecoration(
                    label: 'İndirimsiz Fiyat (Opsiyonel)',
                    hint: '1150.00',
                    prefixIcon: Icons.discount_outlined,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4. BEDEN SEÇENEKLERİ
          _buildSectionHeader('4. BEDEN SEÇENEKLERİ (SİZES)', Icons.straighten_outlined),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._availableSizes.map((size) {
                final isSelected = _selectedSizes.contains(size);
                return FilterChip(
                  label: Text(size),
                  selected: isSelected,
                  selectedColor: Colors.orangeAccent,
                  backgroundColor: const Color(0xFF1E1E1E),
                  checkmarkColor: Colors.black,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? Colors.orangeAccent
                          : const Color(0xFF333333),
                    ),
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSizes.add(size);
                      } else {
                        _selectedSizes.remove(size);
                      }
                    });
                  },
                );
              }),
              ActionChip(
                avatar: const Icon(Icons.add, size: 16, color: Colors.orangeAccent),
                label: const Text(
                  '+ Özel Beden',
                  style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                ),
                backgroundColor: const Color(0xFF1E1E1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.orangeAccent),
                ),
                onPressed: _showAddCustomSizeDialog,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 5. AÇIKLAMA VE TEKNİK ÖZELLİKLER
          _buildSectionHeader('5. AÇIKLAMA & KUMAŞ ÖZELLİKLERİ', Icons.description_outlined),
          const SizedBox(height: 10),
          TextFormField(
            controller: _descriptionController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: _inputDecoration(
              label: 'Ürün Açıklaması',
              hint: 'Ürünün tarzı, dokusu ve detayları hakkında bilgi verin...',
              prefixIcon: Icons.notes,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fabricController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration(
                    label: 'Kumaş Türü',
                    hint: '%100 Pamuk (450 GSM)',
                    prefixIcon: Icons.texture,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _fitController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: _inputDecoration(
                    label: 'Kalıp',
                    hint: 'Oversized Fit',
                    prefixIcon: Icons.checkroom,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Öne Çıkar Anahtarı
          SwitchListTile(
            title: const Text(
              'Ana Sayfada Öne Çıkar (Featured)',
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Ürünü ana sayfa vitrininde ve kampanyalarda vurgular.',
              style: TextStyle(color: Colors.grey[400], fontSize: 12),
            ),
            value: _isFeatured,
            activeThumbColor: Colors.orangeAccent,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) => setState(() => _isFeatured = val),
          ),
          const SizedBox(height: 24),

          // ÜRÜNÜ YAYINLA BUTONU
          ElevatedButton.icon(
            onPressed: _submitNewProduct,
            icon: const Icon(Icons.cloud_upload_outlined),
            label: const Text(
              'ÜRÜNÜ KATALOĞA EKLE & YAYINLA',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildManageProductsTab(List<Product> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text(
          'Henüz kayıtlı ürün bulunmamaktadır.',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2C2C2E)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                p.imageUrl,
                width: 54,
                height: 54,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 54,
                  height: 54,
                  color: Colors.black38,
                  child: const Icon(Icons.checkroom, color: Colors.grey),
                ),
              ),
            ),
            title: Text(
              p.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        p.category,
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${p.price.toStringAsFixed(0)} TL',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Bedenler: ${p.sizes.join(", ")}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              tooltip: 'Ürünü Sil',
              onPressed: () => _confirmDeleteProduct(p),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.orangeAccent, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.orangeAccent,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 12),
      prefixIcon: Icon(prefixIcon, color: Colors.grey[400], size: 20),
      filled: true,
      fillColor: const Color(0xFF1C1C1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2C2C2E)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.orangeAccent),
      ),
    );
  }
}
