/// Garage E-Ticaret Ürün Modeli
class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final List<String> sizes;
  final Map<String, String> specifications;
  final bool isFeatured;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.description,
    required this.imageUrl,
    this.rating = 4.8,
    this.reviewCount = 120,
    required this.sizes,
    required this.specifications,
    this.isFeatured = false,
    this.isFavorite = false,
  });

  /// JSON verisinden Product nesnesi üretme (Eğitim Gün 4 standardı)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 100,
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['S', 'M', 'L', 'XL'],
      specifications: (json['specifications'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      isFeatured: json['isFeatured'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  /// Product nesnesini JSON formatına dönüştürme
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'originalPrice': originalPrice,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'sizes': sizes,
      'specifications': specifications,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
    };
  }

  /// İndirim oranı hesaplayıcı
  int? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
