# 🏁 GARAGE - Streetwear & Lifestyle E-Ticaret Uygulaması

Modern sokak modası ve urban giyim kültüründen ilham alınarak geliştirilmiş, saf Flutter ve Material Design mimarisi üzerine kurulu mobil e-ticaret ve katalog uygulamasıdır.

Bu proje, **Flutter 5 Günlük Eğitim – Proje Çıktısı** müfredat ve teslimat standartlarına tam uyumlu olarak tasarlanmış ve kodlanmıştır.

---

## 📱 Proje Özeti ve Kapsam

* **Proje Adı:** GARAGE Streetwear Mobile
* **Kategori:** E-Ticaret / Mobil Katalog & Alışveriş Simülasyonu
* **Kullanılan Flutter Sürümü:** Flutter 3.x.x / Dart 3.x (Null-Safety Uyumlu)
* **Paket Bağımlılığı:** Harici 3. parti paket kullanılmamıştır (`material.dart` tabanlı saf mimari).

---

## ✨ Temel Özellikler

### 1. Keşfet & Katalog Ekranı (`HomeScreen`)
* **Özel Promosyon Bannerı:** Yeni sezon koleksiyonu ve `%25` indirim kuponu tanıtan dinamik banner.
* **Canlı Arama (Search):** Ürün ismi veya kategorisine göre anında filtreleme.
* **Kategori Filtreleme:** *Tümü, Hoodie, Oversized T-Shirt, Ceket & Mont, Pantolon, Sneaker, Aksesuar* etiketleri ile yatay kaydırmalı hızlı filtreleme.
* **2 Sütunlu Grid Listesi:** `GridView.builder` ile optimize edilmiş, indirim rozetli ve favori butonlu ürün kartları.
* **Hızlı Sepete Ekleme:** Ürün kartı üzerindeki buton ile tek dokunuşla sepete ekleme ve `SnackBar` bildirimi.

### 2. Ürün Detay Ekranı (`ProductDetailScreen`)
* **Geniş Ürün Görseli:** Yüksek çözünürlüklü görsel alanı ve indirim etiketi.
* **Beden Seçimi:** `ChoiceChip` mimarisiyle dinamik beden seçimi (*S, M, L, XL, XXL*).
* **Ürün Detayları ve Hikayesi:** Kumaş gramajı, kalıp türü, yıkama ve menşei bilgilerini içeren teknik özellikler tablosu.
* **Miktar Belirleme:** Ürün adet artırma/azaltma kontrolü.
* **Sayfa Navigasyonu & Veri Taşıma:** `Navigator.push` ile seçilen ürün modelinin detay ekranına aktarılması.

### 3. Sepet ve Sipariş Ekranı (`CartScreen`)
* **Dinamik Sepet Yönetimi:** Sepetteki ürünlerin listesi, seçilen beden bilgisi, anlık adet güncelleme ve ürün silme.
* **Kupon Kodu Sistemi:** `GARAGE25` (%25 İndirim) veya `GARAGE10` (%10 İndirim) kodları ile anlık sepet indirimi simülasyonu.
* **Dinamik Hesaplama:** Ara toplam, indirim tutarı, kargo ücreti (1000 TL üzeri ücretsiz kargo) ve genel toplam hesaplaması.
* **Sipariş Tamamlama (Checkout):** Sipariş onay modalı, sipariş takip numarası üretimi ve sepeti temizleme.
* **Boş Sepet Durumu:** Sepette ürün bulunmadığında kullanıcıyı ana sayfaya yönlendiren bilgilendirici tasarım.

---

## 📂 Proje Klasör Mimarisi

```
garage_app/
├── lib/
│   ├── main.dart                       # Uygulama başlangıcı ve Dark Theme konfigürasyonu
│   ├── models/
│   │   ├── product.dart                # Ürün veri modeli (fromJson, toJson, indirim hesabı)
│   │   └── cart_item.dart              # Sepet kalemi veri modeli
│   ├── data/
│   │   └── mock_products.dart          # JSON simülasyonu ve zengin ürün kataloğu
│   ├── screens/
│   │   ├── home_screen.dart            # Keşfet / Ana sayfa
│   │   ├── product_detail_screen.dart  # Ürün detay sayfası
│   │   └── cart_screen.dart            # Sepet ve sipariş tamamlama ekranı
│   └── widgets/
│       ├── product_card.dart           # Grid ürün kartı bileşeni
│       ├── category_chip.dart          # Kategori filtre çipi
│       └── promo_banner.dart           # Promosyon banner bileşeni
├── pubspec.yaml                        # Flutter proje yapılandırması
└── README.md                           # Proje dokümantasyonu ve teslim raporu
```

---

## 🚀 Kurulum ve Çalıştırma Adımları

Projeyi yerel ortamınızda çalıştırmak için aşağıdaki adımları takip edebilirsiniz:

### Gereksinimler:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0.0 veya üzeri)
* Android Studio (Android Emulator) veya VS Code (Flutter eklentisi ile)

### Adım 1: Projeyi Klonlayın veya Dizine Geçin
```bash
cd garage_app
```

### Adım 2: Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### Adım 3: Emülatör veya Cihazı Başlatın
```bash
flutter devices
```

### Adım 4: Uygulamayı Çalıştırın
```bash
flutter run
```

---

## 📝 Değerlendirme Kriterleri Uyumluluğu
* [x] **Çalışan Mini Katalog Uygulaması:** Mevcut.
* [x] **Ana Sayfa - Ürün Listesi - Detay Ekranı:** Tamamlandı.
* [x] **Sayfa Geçişleri (Navigator):** `Navigator.push` ve `pop` ile uygulandı.
* [x] **Route Arguments:** Ürün nesnesi ekranlar arası parametre olarak aktarıldı.
* [x] **GridView Tasarımı:** 2 sütunlu, responsive kart yapısı oluşturuldu.
* [x] **State Yönetimi:** Sepet ekleme, çıkarma, kupon indirimi ve favori durumu dinamik olarak yönetildi.
* [x] **JSON Mimarisi:** `fromJson` ve `toJson` metodlarıyla simüle edildi.
* [x] **Temiz Klasörleme:** `models`, `data`, `screens`, `widgets` ayrımı eksiksiz sağlandı.
