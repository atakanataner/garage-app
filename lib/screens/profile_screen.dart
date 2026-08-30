import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';
import 'auth_screen.dart';
import 'admin_panel_screen.dart';

/// Garage Profil & Hesap Yönetim Ekranı
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final productService = ProductService();

    return ListenableBuilder(
      listenable: Listenable.merge([authService, productService]),
      builder: (context, _) {
        final user = authService.currentUser;
        final isLoggedIn = authService.isLoggedIn;
        final isAdmin = authService.isAdmin;

        return Scaffold(
          backgroundColor: const Color(0xFF121212),
          appBar: AppBar(
            backgroundColor: const Color(0xFF121212),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'HESABIM & PROFİL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Profil Kartı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isAdmin ? Colors.orangeAccent : const Color(0xFF2C2C2E),
                      width: isAdmin ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isAdmin
                            ? Colors.orangeAccent.withValues(alpha: 0.1)
                            : Colors.black.withValues(alpha: 0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor:
                            isAdmin ? Colors.orangeAccent : const Color(0xFF2C2C2E),
                        child: Icon(
                          isAdmin
                              ? Icons.admin_panel_settings
                              : (isLoggedIn ? Icons.person : Icons.person_outline),
                          size: 38,
                          color: isAdmin ? Colors.black : Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isLoggedIn ? user!.name : 'Misafir Kullanıcı',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLoggedIn ? user!.email : 'Giriş yapılmadı',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAdmin
                              ? Colors.orangeAccent.withValues(alpha: 0.15)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isAdmin
                                ? Colors.orangeAccent
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          isAdmin
                              ? '⚡ SİSTEM YÖNETİCİSİ (ADMIN)'
                              : (isLoggedIn ? 'MÜŞTERİ ÜYESİ' : 'ZİYARETÇİ'),
                          style: TextStyle(
                            color: isAdmin ? Colors.orangeAccent : Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Eğer Admin ise Admin Paneli Kısayolu
                if (isAdmin) ...[
                  _buildMenuCard(
                    context: context,
                    icon: Icons.dashboard_customize_outlined,
                    iconColor: Colors.orangeAccent,
                    title: 'GARAGE Admin Paneli',
                    subtitle: 'Yeni ürün fotoğrafı, beden, fiyat ve kategori ekle / yönet',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelScreen(),
                        ),
                      );
                    },
                    highlight: true,
                  ),
                  const SizedBox(height: 12),
                ],

                // Giriş Yapılmadıysa Giriş/Kayıt Seçeneği
                if (!isLoggedIn) ...[
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    },
                    icon: const Icon(Icons.login),
                    label: const Text(
                      'GİRİŞ YAP / KAYIT OL',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthScreen(openAsAdmin: true),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bolt, color: Colors.orangeAccent),
                    label: const Text(
                      'Admin Girişi Yap (admin@admin.com)',
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orangeAccent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Menü Öğeleri
                _buildMenuCard(
                  context: context,
                  icon: Icons.inventory_2_outlined,
                  title: 'Katalog Ürün Sayısı',
                  subtitle: '${productService.products.length} Aktif Sokak Modası Ürünü',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

                _buildMenuCard(
                  context: context,
                  icon: Icons.local_offer_outlined,
                  title: 'Aktif Kuponlar',
                  subtitle: 'GARAGE25 (%25 İndirim) & GARAGE10 (%10 İndirim)',
                  onTap: () {},
                ),
                const SizedBox(height: 10),

                _buildMenuCard(
                  context: context,
                  icon: Icons.support_agent_outlined,
                  title: 'Garage Müşteri Desteği',
                  subtitle: '7/24 Canlı Destek & İletişim',
                  onTap: () {},
                ),
                const SizedBox(height: 20),

                // Çıkış Butonu (Giriş yapılmışsa)
                if (isLoggedIn) ...[
                  OutlinedButton.icon(
                    onPressed: () {
                      authService.logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Oturum kapatıldı.'),
                          backgroundColor: Color(0xFF2C2C2E),
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.redAccent),
                    label: const Text(
                      'ÇIKIŞ YAP',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    Color iconColor = Colors.white70,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: highlight
            ? Colors.orangeAccent.withValues(alpha: 0.1)
            : const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: highlight ? Colors.orangeAccent : const Color(0xFF2C2C2E),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: highlight ? Colors.orangeAccent : const Color(0xFF2C2C2E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: highlight ? Colors.black : iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: highlight ? Colors.orangeAccent : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: highlight ? Colors.white70 : Colors.grey[400],
            fontSize: 12,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: highlight ? Colors.orangeAccent : Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
