import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/buku_model.dart';
import '../services/supabase_service.dart';
import '../config/supabase_config.dart';

class BukuRepository {
  final SupabaseClient _client = SupabaseService.client;

  // Get all books
  Future<List<Buku>> getAllBuku() async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .order('created_at', ascending: false);

      return (response as List).map((json) => Buku.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  // Get book by ID
  Future<Buku?> getBukuById(String id) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .eq('id', id)
          .single();

      return Buku.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching book: $e');
    }
  }

  // Search books by title
  Future<List<Buku>> searchBukuByJudul(String query) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .ilike('judul', '%$query%')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Buku.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error searching books: $e');
    }
  }

  // Search books by author
  Future<List<Buku>> searchBukuByPenulis(String penulis) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .ilike('penulis', '%$penulis%')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Buku.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error searching books by author: $e');
    }
  }

  // Search books by publisher
  Future<List<Buku>> searchBukuByPenerbit(String penerbit) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .ilike('penerbit', '%$penerbit%')
          .order('created_at', ascending: false);

      return (response as List).map((json) => Buku.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error searching books by publisher: $e');
    }
  }

  // Insert new book
  Future<Buku> insertBuku(Buku buku) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .insert(buku.toJson())
          .select()
          .single();

      return Buku.fromJson(response);
    } catch (e) {
      throw Exception('Error inserting book: $e');
    }
  }

  // Update existing book
  Future<Buku> updateBuku(String id, Buku buku) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .update(buku.toJson())
          .eq('id', id)
          .select()
          .single();

      return Buku.fromJson(response);
    } catch (e) {
      throw Exception('Error updating book: $e');
    }
  }

  // Delete book
  Future<void> deleteBuku(String id) async {
    try {
      await _client.from(SupabaseConfig.tableBuku).delete().eq('id', id);
    } catch (e) {
      throw Exception('Error deleting book: $e');
    }
  }

  // Update book quantity (for stock management)
  Future<void> updateJumlah(String id, int newJumlah) async {
    try {
      await _client
          .from(SupabaseConfig.tableBuku)
          .update({'jumlah': newJumlah})
          .eq('id', id);
    } catch (e) {
      throw Exception('Error updating quantity: $e');
    }
  }

  // Get books with low stock (jumlah < threshold)
  Future<List<Buku>> getLowStockBuku(int threshold) async {
    try {
      final response = await _client
          .from(SupabaseConfig.tableBuku)
          .select()
          .lt('jumlah', threshold)
          .order('jumlah', ascending: true);

      return (response as List).map((json) => Buku.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Error fetching low stock books: $e');
    }
  }

  // Get total inventory value
  Future<int> getTotalInventoryValue() async {
    try {
      final books = await getAllBuku();
      return books.fold<int>(
        0,
        (sum, book) => sum + (book.harga * book.jumlah),
      );
    } catch (e) {
      throw Exception('Error calculating inventory value: $e');
    }
  }

  // Get total number of books
  Future<int> getTotalBooksCount() async {
    try {
      final books = await getAllBuku();
      return books.fold<int>(0, (sum, book) => sum + book.jumlah);
    } catch (e) {
      throw Exception('Error calculating total books: $e');
    }
  }

  // Subscribe to real-time changes
  RealtimeChannel subscribeToBukuChanges({
    required void Function(List<Buku>) onData,
    required void Function(String) onError,
  }) {
    return _client
        .channel('public:buku')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: SupabaseConfig.tableBuku,
          callback: (payload) async {
            try {
              // Refresh all data when changes occur
              final books = await getAllBuku();
              onData(books);
            } catch (e) {
              onError('Error in real-time update: $e');
            }
          },
        )
        .subscribe();
  }
}
