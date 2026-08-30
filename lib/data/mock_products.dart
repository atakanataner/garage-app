import '../models/product.dart';

/// Garage Streetwear Mock Ürün Verileri (JSON Simülasyonu)
/// Eğitim Gün 4 gereksinimi: JSON verisi model sınıflarına parse edilerek kullanılır.
class MockData {
  static final List<Map<String, dynamic>> rawProductsJson = [
    {
      'id': 1,
      'name': 'Garage Acid Wash Heavyweight Hoodie',
      'category': 'Hoodie',
      'price': 980.0,
      'originalPrice': 1250.0,
      'description':
          'Vintage efektli özel yıkama teknikleriyle üretilen 480 GSM ağır gramaj pamuklu hoodie. Rahat drop-shoulder kesimi ve dikiş detayları ile sokak stilini zirveye taşır.',
      'imageUrl':
          'https://images.unsplash.com/photo-1556905055-8f358a7a47b2?auto=format&fit=crop&w=800&q=80',
      'rating': 4.9,
      'reviewCount': 234,
      'sizes': ['S', 'M', 'L', 'XL', 'XXL'],
      'specifications': {
        'Kumaş': '%100 Organik Ağır Gramaj Pamuk (480 GSM)',
        'Kalıp': 'Oversized Boxy Fit',
        'Yıkama': '30°C Ters Çevirerek Yıkayınız',
        'Detay': 'Kanguru cep, çift katmanlı kapüşon',
        'Üretim': 'İstanbul, Türkiye',
      },
      'isFeatured': true,
      'isFavorite': false,
    },
    {
      'id': 2,
      'name': 'Garage "Night Drive" Cyber Oversized Tee',
      'category': 'Oversized T-Shirt',
      'price': 550.0,
      'originalPrice': 690.0,
      'description':
          'Gece sürüşleri ve retro neon estetiğinden ilham alan sırt baskılı tişört. Nefes alabilen 240 GSM kompakt taranmış pamuk kumaş.',
      'imageUrl':
          'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80',
      'rating': 4.8,
      'reviewCount': 189,
      'sizes': ['S', 'M', 'L', 'XL'],
      'specifications': {
        'Kumaş': '%100 Kompakt Penye Pamuk (240 GSM)',
        'Kalıp': 'Oversized Street Fit',
        'Baskı': 'Yüksek Dayanımlı Serigrafi',
        'Yaka': 'Geniş Ribana Yaka',
      },
      'isFeatured': true,
      'isFavorite': false,
    },
    {
      'id': 3,
      'name': 'Garage Tactical Multi-Pocket Cargo Pants',
      'category': 'Pantolon',
      'price': 1250.0,
      'originalPrice': 1500.0,
      'description':
          'Fonksiyonel ve dayanıklı ripstop kumaştan üretilmiş çok cepli taktik kargo pantolon. Ayarlanabilir paça kordonları ve metal D-ring askı aparatları içerir.',
      'imageUrl':
          'https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?auto=format&fit=crop&w=800&q=80',
      'rating': 4.7,
      'reviewCount': 142,
      'sizes': ['S (30)', 'M (32)', 'L (34)', 'XL (36)'],
      'specifications': {
        'Kumaş': '%65 Pamuk, %35 Dayanıklı Ripstop Naylon',
        'Kalıp': 'Relaxed Tapered Fit',
        'Cepler': '6 Adet Fonksiyonel Körüklü Cep',
        'Kapanış': 'Fermuar & Güçlendirilmiş Düğme',
      },
      'isFeatured': false,
      'isFavorite': false,
    },
    {
      'id': 4,
      'name': 'Garage "Speedway" Leather Racing Bomber',
      'category': 'Ceket & Mont',
      'price': 2400.0,
      'originalPrice': 3200.0,
      'description':
          'Motor sporları kültüründen ilham alan özel deri ceket. Vintage nakış yamaları, saten iç astar ve tok fermuar detayları ile ikonik bir duruş sunar.',
      'imageUrl':
          'https://images.unsplash.com/photo-1551028719-00167b16eac5?auto=format&fit=crop&w=800&q=80',
      'rating': 5.0,
      'reviewCount': 96,
      'sizes': ['M', 'L', 'XL'],
      'specifications': {
        'Dış Malzeme': 'Premium Vegan Deri',
        'İç Astar': 'Yumuşak Saten Astar',
        'Yama': 'Özel Tasarım Racing Nakışlar',
        'Kapanış': 'YKK Çift Yönlü Metal Fermuar',
      },
      'isFeatured': true,
      'isFavorite': false,
    },
    {
      'id': 5,
      'name': 'Garage "Raw Denim" Wide-Leg Skater Jeans',
      'category': 'Pantolon',
      'price': 1100.0,
      'originalPrice': 1350.0,
      'description':
          '90\'lar kaykay kültürünün vazgeçilmezi geniş paça raw denim jean. 14.5 oz ağır gramaj pamuk denim kumaş ve kontrast dikişler.',
      'imageUrl':
          'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=800&q=80',
      'rating': 4.6,
      'reviewCount': 88,
      'sizes': ['30/32', '32/32', '34/32', '36/32'],
      'specifications': {
        'Kumaş': '14.5 oz %100 Pamuk Rigid Denim',
        'Kalıp': 'Baggy / Wide Leg',
        'Paça Genişliği': '24 cm',
      },
      'isFeatured': false,
      'isFavorite': false,
    },
    {
      'id': 6,
      'name': 'Garage "Phantom" Chunky Sole Sneaker',
      'category': 'Sneaker & Ayakkabı',
      'price': 2150.0,
      'originalPrice': 2600.0,
      'description':
          'Fütüristik sokak tasarımı ve konforu bir arada sunan kalın tabanlı sneaker. Darbe emici EVA taban ve nefes alabilir file/nubuk kombinasyonu.',
      'imageUrl':
          'https://images.unsplash.com/photo-1552346154-21d32810aba3?auto=format&fit=crop&w=800&q=80',
      'rating': 4.9,
      'reviewCount': 310,
      'sizes': ['40', '41', '42', '43', '44', '45'],
      'specifications': {
        'Taban': 'Hafif ve Yastıklamalı Chunky EVA',
        'Saya': 'Nefes Alabilir File & Süet Nubuk',
        'İç Taban': 'Memory Foam Destekli',
      },
      'isFeatured': true,
      'isFavorite': false,
    },
    {
      'id': 7,
      'name': 'Garage Utility Crossbody Chest Bag',
      'category': 'Aksesuar',
      'price': 480.0,
      'originalPrice': 590.0,
      'description':
          'Günlük kullanım için ideal, suya dayanıklı Cordura kumaştan göğüs ve omuz çantası. Ayarlanabilir tokalı askı ve gizli kart cebi.',
      'imageUrl':
          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=800&q=80',
      'rating': 4.8,
      'reviewCount': 175,
      'sizes': ['Standart'],
      'specifications': {
        'Kumaş': '1000D Su İtici Cordura Naylon',
        'Hacim': '3.5 Litre',
        'Bölmeler': '3 Fermuarlı Ana ve Ön Göz',
      },
      'isFeatured': false,
      'isFavorite': false,
    },
    {
      'id': 8,
      'name': 'Garage Distressed Vintage Street Cap',
      'category': 'Aksesuar',
      'price': 350.0,
      'originalPrice': 420.0,
      'description':
          'Eskitme efektli kanvas kumaş ve ön panelde kabartmalı "GARAGE" 3D nakışlı snapback şapka.',
      'imageUrl':
          'https://images.unsplash.com/photo-1588850561407-ed78c282e89b?auto=format&fit=crop&w=800&q=80',
      'rating': 4.7,
      'reviewCount': 114,
      'sizes': ['Ayarlanabilir Tek Ebat'],
      'specifications': {
        'Kumaş': '%100 Pamuk Kanvas',
        'Kapanış': 'Metal Tokalı Ayarlanabilir Arka Kayış',
        'Detay': 'Vintage Yıpratılmış Kenar Dikişleri',
      },
      'isFeatured': false,
      'isFavorite': false,
    },
  ];

  /// Kategoriler Listesi
  static const List<String> categories = [
    'Tümü',
    'Hoodie',
    'Oversized T-Shirt',
    'Ceket & Mont',
    'Pantolon',
    'Sneaker & Ayakkabı',
    'Aksesuar',
  ];

  /// JSON verisini Product nesnelerine dönüştürerek döndürür
  static List<Product> getProducts() {
    return rawProductsJson.map((json) => Product.fromJson(json)).toList();
  }
}
