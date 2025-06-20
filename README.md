# 🏠 Boss Kost - Aplikasi Pencarian Kos-Kosan

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![GitHub issues](https://img.shields.io/github/issues/Liayuu/app_pencari_kos?style=flat-square)](https://github.com/Liayuu/app_pencari_kos/issues)
[![GitHub stars](https://img.shields.io/github/stars/Liayuu/app_pencari_kos?style=flat-square)](https://github.com/Liayuu/app_pencari_kos/stargazers)

Aplikasi mobile untuk mencari kos-kosan terdekat dengan fitur peta interaktif, filter pencarian, dan informasi lengkap tentang fasilitas, harga, serta jarak ke kampus.

## 📋 Daftar Isi

- [📱 Apa itu Boss Kost?](#-apa-itu-boss-kost)
- [🎯 Mengapa Boss Kost?](#-mengapa-boss-kost)
- [⚡ Fungsi dan Fitur Utama](#-fungsi-dan-fitur-utama)
- [🚀 Cara Menjalankan Aplikasi](#-cara-menjalankan-aplikasi)
- [📁 Struktur Proyek](#-struktur-proyek)
- [🎨 Screenshot](#-screenshot)
- [🔧 Konfigurasi Tambahan](#-konfigurasi-tambahan)
- [🤝 Kontribusi](#-kontribusi)
- [📄 Lisensi](#-lisensi)

📱 Apa itu Boss Kost?

Boss Kost adalah aplikasi Flutter yang dirancang khusus untuk memudahkan mahasiswa dan pekerja dalam mencari kos-kosan yang sesuai dengan kebutuhan dan budget mereka. Aplikasi ini menggabungkan teknologi GPS untuk menampilkan kos terdekat dengan interface yang modern dan user-friendly.

🎯 Mengapa Boss Kost?

### Masalah yang Diselesaikan:
- Kesulitan mencari kos - Proses pencarian kos yang memakan waktu dan tidak efisien
- Informasi tidak lengkap - Sulit mendapatkan informasi detail tentang fasilitas dan harga
- Lokasi tidak jelas - Tidak tahu jarak sebenarnya dari kos ke kampus atau tempat kerja
- Perbandingan sulit - Sulit membandingkan pilihan kos yang tersedia

### Solusi yang Ditawarkan:
- Pencarian berbasis lokasi - Temukan kos terdekat dengan GPS
- Informasi lengkap - Detail fasilitas, harga, rating, dan foto
- Peta interaktif - Visualisasi lokasi kos dengan marker
- Filter canggih - Cari berdasarkan harga, tipe, dan fasilitas
- Interface modern - UI/UX yang mudah digunakan

⚡ Fungsi dan Fitur Utama

### 🔍 Pencarian & Filter
- Pencarian berdasarkan nama kos atau lokasi
- Filter berdasarkan tipe kos (Putra/Putri/Campur)
- Filter rentang harga
- Sorting berdasarkan jarak, harga, atau rating

### 🗺️ Peta Interaktif
- Tampilan peta dengan marker lokasi kos
- Informasi jarak ke kampus/universitas
- Navigasi GPS terintegrasi

### 📋 Informasi Detail
- Galeri foto kos
- Daftar fasilitas lengkap (WiFi, AC, Parkir, dll)
- Rating dan review
- Informasi harga per bulan
- Status ketersediaan kamar

### 👤 Fitur Pengguna
- Profil pengguna
- Bookmark kos favorit
- Riwayat pencarian
- Notifikasi kos baru

### 🎨 Komponen UI
- StatefulWidget - Manajemen state dinamis
- Custom AppBar - Header dengan gradient styling
- Bottom Navigation - Navigasi dengan icon Home, Map, Notifikasi, People
- Custom Drawer - Sidebar dengan profil dan menu
- Cards & Containers - Layout modern dengan shadow dan border radius
- ListView & GridView - Tampilan daftar yang responsive
- Form & Dialog - Input dan popup interaktif
- Stack & Overlay - Widget berlapis untuk badge dan marker

🚀 Cara Menjalankan Aplikasi

### 📋 Prasyarat
Pastikan Anda telah menginstall:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.8.1 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart) (biasanya sudah termasuk dengan Flutter)
- [Android Studio](https://developer.android.com/studio) atau [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)

### 1️⃣ Clone Repository
```bash
git clone https://github.com/Liayuu/app_pencari_kos.git
cd app_pencari_kos
```

### 2️⃣ Install Dependencies
Jalankan perintah berikut untuk mengunduh dan menginstall semua dependencies yang diperlukan:
```bash
flutter pub get
```
Perintah ini akan menginstall packages seperti Google Maps, Location services, HTTP client, dll.

### 3️⃣ Jalankan Aplikasi

#### 🖥️ Untuk Web (Recommended untuk testing)
```bash
flutter run -d web-server
```
Kemudian buka browser dan akses `http://localhost:8080`

#### 📱 Untuk Android
```bash
# Pastikan device Android sudah terhubung atau emulator sudah running
flutter devices
flutter run -d android
```

#### 🍎 Untuk iOS (hanya di macOS)
```bash
flutter run -d ios
```

#### 🖥️ Untuk Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

### 4️⃣ Build untuk Production

#### 📱 Android APK
```bash
flutter build apk --release
```
File APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

#### 🌐 Web Build
```bash
flutter build web --release
```
File web akan tersedia di: `build/web/`

📁 Struktur Proyek

```
lib/
├── main.dart                 # Entry point aplikasi
├── models/                   # Data models
│   └── kos.dart             # Model untuk data kos
├── screens/                  # Layar-layar aplikasi
│   ├── splash_screen.dart   # Layar pembuka
│   ├── home_screen.dart     # Layar utama
│   ├── search_screen.dart   # Layar pencarian
│   ├── map_screen.dart      # Layar peta
│   ├── kos_detail_screen.dart # Detail kos
│   ├── notification_screen.dart # Layar notifikasi
│   ├── profile_screen.dart  # Layar profil
│   └── search_form_screen.dart # Form pencarian
├── widgets/                  # Custom widgets
│   ├── kos_card.dart        # Card untuk tampilan kos
│   └── custom_drawer.dart   # Sidebar menu
└── services/                 # Service layer
    ├── api_service.dart     # Integrasi API
    └── location_service.dart # Service GPS
```

## 🛠️ Teknologi yang Digunakan

- **Flutter** - Framework UI cross-platform
- **Dart** - Bahasa pemrograman
- **Google Maps** - Integrasi peta dan lokasi
- **HTTP** - Network requests
- **Geolocator** - Location services
- **Material Design** - Design system

🎨 Screenshot

> Catatan: Screenshot akan ditambahkan setelah aplikasi fully running

🔧 Konfigurasi Tambahan

### 🗺️ Google Maps (Opsional)
Untuk mengaktifkan Google Maps:
1. Dapatkan API Key dari [Google Cloud Console](https://console.cloud.google.com/)
2. Tambahkan ke file konfigurasi masing-masing platform
3. Update kode di `map_screen.dart`

### 🌐 API Backend
Aplikasi saat ini menggunakan data sample. Untuk menghubungkan dengan API:
1. Update endpoint di `api_service.dart`
2. Sesuaikan model data jika diperlukan
3. Implementasikan authentication jika diperlukan

## 🔍 Troubleshooting

### ❓ Error saat menjalankan `flutter pub get`
```bash
flutter clean
flutter pub get
```

### ❓ Aplikasi tidak bisa build
Pastikan Flutter SDK sudah terinstall dengan benar:
```bash
flutter doctor
```

### ❓ Permission error di Android
Tambahkan permission di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

🤝 Kontribusi

Kontribusi sangat diterima! Silakan:
1. Fork repository ini
2. Buat branch baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

📄 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Kontak

- **GitHub:** [@Liayuu](https://github.com/Liayuu)
- **Email:** your.email@example.com
- **Project Link:** [https://github.com/Liayuu/app_pencari_kos](https://github.com/Liayuu/app_pencari_kos)

---

⭐ **Jika project ini membantu Anda, jangan lupa berikan star!** ⭐

