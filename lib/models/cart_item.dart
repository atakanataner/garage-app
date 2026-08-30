import 'product.dart';

/// Garage E-Ticaret Sepet Kalemi Modeli
class CartItem {
  final Product product;
  final String selectedSize;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  /// Kalem toplam tutarı
  double get totalPrice => product.price * quantity;

  /// JSON dönüşümü
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selectedSize': selectedSize,
      'quantity': quantity,
    };
  }

  /// JSON'dan CartItem oluşturma
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selectedSize'] as String? ?? 'M',
      quantity: json['quantity'] as int? ?? 1,
    );
  }
}
