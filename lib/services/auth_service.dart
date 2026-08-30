import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// Garage Kimlik Doğrulama Servisi
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Kayıtlı kullanıcılar simülasyonu
  final List<Map<String, dynamic>> _userDatabase = [
    {
      'email': 'admin@admin.com',
      'password': 'admin',
      'user': const AppUser(
        id: 'admin_1',
        email: 'admin@admin.com',
        name: 'Garage Yönetici',
        role: UserRole.admin,
      ),
    },
    {
      'email': 'user@garage.com',
      'password': 'user123',
      'user': const AppUser(
        id: 'user_1',
        email: 'user@garage.com',
        name: 'Alper Demir',
        role: UserRole.customer,
      ),
    },
  ];

  /// Giriş Yapma İşlemi
  String? login({required String email, required String password}) {
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return 'Lütfen tüm alanları doldurunuz.';
    }

    final matchIndex = _userDatabase.indexWhere(
      (entry) =>
          (entry['email'] as String).toLowerCase() == cleanEmail &&
          entry['password'] == cleanPassword,
    );

    if (matchIndex != -1) {
      _currentUser = _userDatabase[matchIndex]['user'] as AppUser;
      notifyListeners();
      return null; // Başarılı
    }

    return 'Geçersiz e-posta adresi veya şifre.';
  }

  /// Kayıt Olma İşlemi
  String? register({
    required String name,
    required String email,
    required String password,
  }) {
    final cleanName = name.trim();
    final cleanEmail = email.trim().toLowerCase();
    final cleanPassword = password.trim();

    if (cleanName.isEmpty || cleanEmail.isEmpty || cleanPassword.isEmpty) {
      return 'Lütfen tüm alanları eksiksiz doldurunuz.';
    }

    if (cleanPassword.length < 4) {
      return 'Şifre en az 4 karakterden oluşmalıdır.';
    }

    final exists = _userDatabase.any(
      (entry) => (entry['email'] as String).toLowerCase() == cleanEmail,
    );

    if (exists) {
      return 'Bu e-posta adresi ile zaten kayıtlı bir hesap bulunmaktadır.';
    }

    final newUser = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: cleanEmail,
      name: cleanName,
      role: UserRole.customer,
    );

    _userDatabase.add({
      'email': cleanEmail,
      'password': cleanPassword,
      'user': newUser,
    });

    _currentUser = newUser;
    notifyListeners();
    return null; // Başarılı
  }

  /// Çıkış Yapma İşlemi
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
