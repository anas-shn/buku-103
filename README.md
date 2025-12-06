# 📚 Inventaris Buku 103

Aplikasi manajemen inventaris buku berbasis Flutter dengan Supabase sebagai backend. Aplikasi ini dilengkapi dengan sistem autentikasi yang aman dan antarmuka yang menarik.

##    Author 
-     Nama: Anas Sholihin
-     NIM: H1D023103
-     Shift: F - E

## ✨ Fitur

### Demo
[Demo Aplikasi](https://github.com/anas-shn/buku-103/blob/main/docs/demo.gif)

### 🔐 Authentication
- ✅ Register dengan Email, Password, dan Nama
- ✅ Login dengan Email & Password
- ✅ Logout dengan konfirmasi
- ✅ Session persistence (auto-login)
- ✅ Password validation
- ✅ Beautiful UI dengan animasi smooth
- ✅ Error handling dalam Bahasa Indonesia

### 📖 Manajemen Buku (Coming Soon)
- 📝 CRUD lengkap (Create, Read, Update, Delete)
- 🔍 Search & Filter buku
- 📊 Statistik inventaris
- 📱 Real-time updates
- 💾 Local & cloud sync

## 🎨 Screenshots

### Splash Screen
Loading screen dengan animasi yang smooth dan pengecekan status autentikasi otomatis.

### Login Screen
- Email & password input dengan validasi
- Show/hide password toggle
- Smooth animations (fade & slide)
- Error messages dalam Bahasa Indonesia

### Register Screen
- Form lengkap: Nama, Email, Password, Confirm Password
- Real-time password validation
- Terms & conditions checkbox
- Success dialog setelah registrasi

### Home Screen
- Header dengan gradient
- User profile (nama & email)
- Dashboard cards untuk fitur inventaris
- Menu grid untuk navigasi

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10.0 atau lebih baru
- Dart SDK
- Akun Supabase (gratis)
- Android Studio / VS Code

### Installation

1. **Clone repository**
```bash
git clone <repository-url>
cd inventaris_103
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Setup Supabase**
   - Buat project baru di [supabase.com](https://supabase.com)
   - Copy Project URL dan Anon Key
   - Lihat [SETUP.md](SETUP.md) untuk langkah detail

4. **Konfigurasi Environment**
```bash
# Edit file .env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
```

5. **Setup Database**
   - Jalankan SQL migrations di Supabase SQL Editor
   - Lihat [SETUP.md](SETUP.md) untuk SQL script lengkap

6. **Run App**
```bash
flutter run
```

## 📁 Struktur Project

```
inventaris_103/
├── lib/
│   ├── main.dart                      # Entry point + initialization
│   ├── config/
│   │   └── supabase_config.dart      # Konfigurasi Supabase
│   ├── services/
│   │   ├── supabase_service.dart     # Supabase client
│   │   └── auth_service.dart         # Authentication service
│   ├── models/
│   │   └── buku_model.dart           # Model data Buku
│   ├── repositories/
│   │   └── buku_repository.dart      # Database operations
│   ├── screens/
│   │   ├── splash_screen.dart        # Splash screen
│   │   ├── auth/
│   │   │   ├── login_screen.dart     # Login page
│   │   │   └── register_screen.dart  # Register page
│   │   └── home_screen.dart          # Home dashboard
│   └── widgets/
│       ├── custom_text_field.dart    # Reusable text field
│       └── custom_button.dart        # Reusable button
├── supabase/
│   └── migrations/
│       ├── 001_create_buku_table.sql     # Tabel buku
│       └── 002_create_profiles_table.sql # Tabel profiles
├── .env                               # Environment variables (gitignored)
├── .env.example                       # Template environment
├── pubspec.yaml                       # Dependencies
├── README.md                          # Dokumentasi utama
├── SETUP.md                           # Quick setup guide
├── README_SUPABASE.md                 # Supabase documentation
└── README_AUTH.md                     # Authentication guide
```

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.10+
- **Backend**: Supabase
  - Authentication
  - PostgreSQL Database
  - Row Level Security (RLS)
  - Real-time subscriptions
- **State Management**: Provider (ready to use)
- **Local Storage**: SharedPreferences
- **UI/UX**: Material Design 3 + Google Fonts

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  
  # Supabase
  supabase_flutter: ^2.10.3
  flutter_dotenv: ^6.0.0
  
  # UI & Form
  google_fonts: ^6.1.0
  flutter_svg: ^2.0.9
  
  # State Management & Utils
  provider: ^6.1.1
  shared_preferences: ^2.2.2
```

## 🗄️ Database Schema

### Tabel: `buku`
| Column         | Type      | Description                    |
|----------------|-----------|--------------------------------|
| id             | UUID      | Primary key (auto-generated)   |
| judul          | TEXT      | Judul buku                     |
| harga          | INTEGER   | Harga dalam Rupiah             |
| jumlah         | INTEGER   | Jumlah stok                    |
| tanggal_masuk  | TEXT      | Tanggal masuk inventaris       |
| volume         | INTEGER   | Volume/edisi buku              |
| penulis        | TEXT      | Nama penulis                   |
| penerbit       | TEXT      | Nama penerbit                  |
| created_at     | TIMESTAMP | Waktu dibuat                   |
| updated_at     | TIMESTAMP | Waktu update terakhir          |

### Tabel: `profiles`
| Column      | Type      | Description                |
|-------------|-----------|----------------------------|
| id          | UUID      | Foreign key ke auth.users  |
| name        | TEXT      | Nama user                  |
| email       | TEXT      | Email user                 |
| avatar_url  | TEXT      | URL avatar (nullable)      |
| created_at  | TIMESTAMP | Waktu dibuat               |
| updated_at  | TIMESTAMP | Waktu update terakhir      |


### API Documentation

#### AuthService
```dart
// Register
await authService.signUp(
  email: 'user@example.com',
  password: 'SecurePass123',
  name: 'John Doe',
);

// Login
await authService.signIn(
  email: 'user@example.com',
  password: 'SecurePass123',
);

// Logout
await authService.signOut();

// Get user info
String name = await authService.getUserName();
String email = await authService.getUserEmail();
bool isLoggedIn = authService.isLoggedIn;
```

#### BukuRepository
```dart
// Get all books
List<Buku> books = await bukuRepo.getAllBuku();

// Search books
List<Buku> results = await bukuRepo.searchBukuByJudul('Laskar');

// Insert book
Buku newBook = await bukuRepo.insertBuku(buku);

// Update book
Buku updated = await bukuRepo.updateBuku(id, buku);

// Delete book
await bukuRepo.deleteBuku(id);

// Get statistics
int totalValue = await bukuRepo.getTotalInventoryValue();
int totalBooks = await bukuRepo.getTotalBooksCount();
```

## 🧪 Testing

### Manual Testing

1. **Test Registration**
   - Buka app → Klik "Daftar Akun Baru"
   - Isi form lengkap
   - Verify success dialog muncul
   - Check user di Supabase dashboard

2. **Test Login**
   - Login dengan credentials yang didaftarkan
   - Verify redirect ke Home Screen
   - Check nama & email tampil di header

3. **Test Logout**
   - Klik icon logout
   - Confirm di dialog
   - Verify redirect ke Login Screen

4. **Test Session Persistence**
   - Login → Close app (force quit)
   - Buka lagi app
   - Verify langsung masuk ke Home (auto-login)

## 🐛 Troubleshooting

### Error: "Failed to load asset: .env"
```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Invalid login credentials"
- Check email & password benar
- Verify user ada di Authentication > Users
- Check email confirmation jika diaktifkan

### App crash saat startup
- Verify .env file ada dan isinya benar
- Check Supabase credentials valid
- Check koneksi internet
- Lihat console logs untuk detail error

### Profile tidak terbuat otomatis
- Pastikan trigger SQL sudah dijalankan
- Check di SQL Editor:
```sql
SELECT * FROM pg_trigger WHERE tgname = 'on_auth_user_created';
```

## 🎨 Customization

### Ubah Tema Warna
Edit `lib/main.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: const Color(0xFF4A90E2), // Ganti warna di sini
),
```

### Ubah Font
Edit `lib/main.dart`:
```dart
textTheme: GoogleFonts.robotoTextTheme(), // Ganti font
```

Lihat [Google Fonts](https://fonts.google.com/) untuk pilihan font.

## 👨‍💻 Author

**Inventaris Buku 103 Team**

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI Framework
- [Supabase](https://supabase.com/) - Backend as a Service
- [Google Fonts](https://fonts.google.com/) - Typography
- [Material Design 3](https://m3.material.io/) - Design System

## 📞 Support

Jika ada pertanyaan atau masalah:
- 📖 Baca dokumentasi lengkap di folder docs
- 🐛 Create issue di GitHub
- 💬 Diskusi di GitHub Discussions

---

**Made with ❤️ using Flutter & Supabase**

**Happy Coding! 🚀**
