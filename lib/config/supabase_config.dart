import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  // Supabase credentials
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Validate configuration
  static bool isConfigured() {
    return supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
  }

  // Table names
  static const String tableBuku = 'buku';

  // Error messages
  static const String configErrorMessage =
      'Supabase configuration is missing. Please check your .env file.';
}
