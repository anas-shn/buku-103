class Buku {
  final String? id;
  final String judul;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final int volume;
  final String penulis;
  final String penerbit;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Buku({
    this.id,
    required this.judul,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    required this.volume,
    required this.penulis,
    required this.penerbit,
    this.createdAt,
    this.updatedAt,
  });

  // Convert from JSON (from Supabase)
  factory Buku.fromJson(Map<String, dynamic> json) {
    return Buku(
      id: json['id'] as String?,
      judul: json['judul'] as String,
      harga: json['harga'] as int,
      jumlah: json['jumlah'] as int,
      tanggalMasuk: json['tanggal_masuk'] as String,
      volume: json['volume'] as int,
      penulis: json['penulis'] as String,
      penerbit: json['penerbit'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  // Convert to JSON (for Supabase)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'judul': judul,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
      'volume': volume,
      'penulis': penulis,
      'penerbit': penerbit,
    };
  }

  // Create a copy with some fields changed
  Buku copyWith({
    String? id,
    String? judul,
    int? harga,
    int? jumlah,
    String? tanggalMasuk,
    int? volume,
    String? penulis,
    String? penerbit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Buku(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      harga: harga ?? this.harga,
      jumlah: jumlah ?? this.jumlah,
      tanggalMasuk: tanggalMasuk ?? this.tanggalMasuk,
      volume: volume ?? this.volume,
      penulis: penulis ?? this.penulis,
      penerbit: penerbit ?? this.penerbit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Buku(id: $id, judul: $judul, harga: $harga, jumlah: $jumlah, '
        'tanggalMasuk: $tanggalMasuk, volume: $volume, penulis: $penulis, '
        'penerbit: $penerbit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Buku &&
        other.id == id &&
        other.judul == judul &&
        other.harga == harga &&
        other.jumlah == jumlah &&
        other.tanggalMasuk == tanggalMasuk &&
        other.volume == volume &&
        other.penulis == penulis &&
        other.penerbit == penerbit;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        judul.hashCode ^
        harga.hashCode ^
        jumlah.hashCode ^
        tanggalMasuk.hashCode ^
        volume.hashCode ^
        penulis.hashCode ^
        penerbit.hashCode;
  }
}
