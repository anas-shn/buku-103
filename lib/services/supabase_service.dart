import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static SupabaseClient? _client;

  // Get Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase has not been initialized. Call init() first.');
    }
    return _client!;
  }

  // Initialize Supabase
  static Future<void> init() async {
    try {
      // Check if configuration is valid
      if (!SupabaseConfig.isConfigured()) {
        throw Exception(SupabaseConfig.configErrorMessage);
      }

      // Initialize Supabase
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
        debug: true, // Set to false in production
      );

      _client = Supabase.instance.client;

      debugPrint('✅ Supabase initialized successfully');
    } catch (e) {
      debugPrint('❌ Error initializing Supabase: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  static bool isAuthenticated() {
    return _client?.auth.currentUser != null;
  }

  // Get current user
  static User? getCurrentUser() {
    return _client?.auth.currentUser;
  }

  // Sign out
  static Future<void> signOut() async {
    await _client?.auth.signOut();
  }
}
