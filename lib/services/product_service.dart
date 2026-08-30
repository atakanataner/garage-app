import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../data/mock_products.dart';

/// Garage Merkezi Ürün ve Katalog Yönetim Servisi
class ProductService extends ChangeNotifier {
  static final ProductService _instance = ProductService._internal();
  factory ProductService() => _instance;

  ProductService._internal() {
    _products = MockData.getProducts();
    _categories = List<String>.from(MockData.categories);
  }

  late List<Product> _products;
  late List<String> _categories;

  List<Product> get products => List.unmodifiable(_products);
  List<String> get categories => List.unmodifiable(_categories);

  /// Yeni Ürün Ekleme (Admin Paneli)
  void addProduct(Product product) {
    // Listeye en baştan ekle (en son eklenen en üstte görünsün)
    _products.insert(0, product);

    // Kategori henüz listede yoksa kategorilere ekle
    if (!_categories.contains(product.category) && product.category.isNotEmpty) {
      _categories.add(product.category);
    }

    notifyListeners();
  }

  /// Ürün Silme (Admin Paneli)
  void deleteProduct(int id) {
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  /// Ürün Güncelleme
  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  /// Favori Durumunu Değiştirme
  void toggleFavorite(int id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index].isFavorite = !_products[index].isFavorite;
      notifyListeners();
    }
  }

  /// Yeni Benzersiz Ürün ID Üretici
  int generateNewId() {
    if (_products.isEmpty) return 1;
    final maxId = _products.map((p) => p.id).reduce((a, b) => a > b ? a : b);
    return maxId + 1;
  }
}
