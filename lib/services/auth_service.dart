import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  // SharedPreferences keys
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _isLoggedInKey = 'is_logged_in';

  // Get current user
  User? get currentUser => _client.auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up with email, password, and name
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name, 'display_name': name},
      );

      if (response.user != null) {
        debugPrint('✅ User signed up successfully: ${response.user!.email}');
        // Sign out after registration so user needs to login
        await _client.auth.signOut();
        debugPrint('✅ User signed out after registration');
      }

      return response;
    } catch (e) {
      debugPrint('❌ Sign up error: $e');
      rethrow;
    }
  }

  // Sign in with email and password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Get user name from metadata
        final name =
            response.user!.userMetadata?['name'] ??
            response.user!.userMetadata?['display_name'] ??
            'User';

        // Save user info to SharedPreferences
        await _saveUserInfo(name, email);
        await _setLoggedIn(true);

        debugPrint('✅ User signed in successfully: ${response.user!.email}');
      }

      return response;
    } catch (e) {
      debugPrint('❌ Sign in error: $e');
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      await _clearUserInfo();
      await _setLoggedIn(false);
      debugPrint('✅ User signed out successfully');
    } catch (e) {
      debugPrint('❌ Sign out error: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
      debugPrint('✅ Password reset email sent to: $email');
    } catch (e) {
      debugPrint('❌ Reset password error: $e');
      rethrow;
    }
  }

  // Update user password
  Future<UserResponse> updatePassword(String newPassword) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      debugPrint('✅ Password updated successfully');
      return response;
    } catch (e) {
      debugPrint('❌ Update password error: $e');
      rethrow;
    }
  }

  // Update user name
  Future<UserResponse> updateUserName(String newName) async {
    try {
      final response = await _client.auth.updateUser(
        UserAttributes(data: {'name': newName, 'display_name': newName}),
      );

      if (response.user != null) {
        await _saveUserName(newName);
        debugPrint('✅ User name updated successfully');
      }

      return response;
    } catch (e) {
      debugPrint('❌ Update user name error: $e');
      rethrow;
    }
  }

  // Get user name from local storage or metadata
  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString(_userNameKey);

    if (name == null && currentUser != null) {
      name =
          (currentUser!.userMetadata?['name'] ??
                  currentUser!.userMetadata?['display_name'] ??
                  'User')
              as String;
      await _saveUserName(name);
    }

    return name ?? 'User';
  }

  // Get user email from local storage or current user
  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString(_userEmailKey);

    if (email == null && currentUser != null) {
      email = currentUser!.email ?? '';
      await _saveUserEmail(email);
    }

    return email ?? '';
  }

  // Check if user has verified email
  bool get isEmailVerified => currentUser?.emailConfirmedAt != null;

  // Resend verification email
  Future<void> resendVerificationEmail() async {
    try {
      if (currentUser?.email != null) {
        await _client.auth.resend(
          type: OtpType.signup,
          email: currentUser!.email!,
        );
        debugPrint('✅ Verification email resent');
      }
    } catch (e) {
      debugPrint('❌ Resend verification error: $e');
      rethrow;
    }
  }

  // Private helper methods
  Future<void> _saveUserInfo(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }

  Future<void> _saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> _clearUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
  }

  Future<void> _setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  Future<bool> getLoggedInStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate password strength
  static String? validatePassword(String password) {
    if (password.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }
    return null; // Password is valid
  }

  // Get error message in Indonesian
  static String getErrorMessage(dynamic error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('invalid login credentials') ||
        errorMessage.contains('invalid email or password')) {
      return 'Email atau password salah';
    } else if (errorMessage.contains('email already registered') ||
        errorMessage.contains('user already registered')) {
      return 'Email sudah terdaftar';
    } else if (errorMessage.contains('invalid email')) {
      return 'Format email tidak valid';
    } else if (errorMessage.contains('password should be at least')) {
      return 'Password minimal 6 karakter';
    } else if (errorMessage.contains('network')) {
      return 'Tidak ada koneksi internet';
    } else if (errorMessage.contains('timeout')) {
      return 'Koneksi timeout, coba lagi';
    } else {
      return 'Terjadi kesalahan, silakan coba lagi';
    }
  }
}
