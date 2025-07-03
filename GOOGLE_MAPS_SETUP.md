# Google Maps Setup Guide

## Masalah Saat Ini

Google Maps tidak tampil karena **Authorization failure**. Dari log aplikasi terlihat:

```
API Key: AIzaSyCnRajnzDRfLclTR2Jn7S_8ANpHHvxkEf4
SHA-1 Fingerprint: A1:C8:8F:5B:5F:B6:C5:D7:EA:CD:A8:18:95:43:ED:09:EA:94:42:26
Package Name: com.example.boss_kost
```

## Langkah Perbaikan di Google Cloud Console

### 1. Akses Google Cloud Console
1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Pastikan Anda memilih project yang benar

### 2. Enable Maps SDK for Android
1. Di menu sidebar, pilih **APIs & Services** > **Library**
2. Cari "Maps SDK for Android"
3. Klik dan pastikan status **ENABLED**
4. Jika belum, klik **ENABLE**

### 3. Konfigurasi API Key
1. Di menu sidebar, pilih **APIs & Services** > **Credentials**
2. Cari API key: `AIzaSyCnRajnzDRfLclTR2Jn7S_8ANpHHvxkEf4`
3. Klik pada API key tersebut untuk edit

### 4. Set Application Restrictions
1. Di bagian **Application restrictions**, pilih **Android apps**
2. Klik **Add an item**
3. Masukkan:
   - **Package name**: `com.example.boss_kost`
   - **SHA-1 certificate fingerprint**: `A1:C8:8F:5B:5F:B6:C5:D7:EA:CD:A8:18:95:43:ED:09:EA:94:42:26`

### 5. Set API Restrictions
1. Di bagian **API restrictions**, pilih **Restrict key**
2. Pilih APIs yang dibutuhkan:
   - **Maps SDK for Android**
   - **Geocoding API** (opsional, untuk search)
   - **Places API** (opsional, untuk autocomplete)

### 6. Save Changes
1. Klik **Save**
2. Tunggu beberapa menit agar perubahan ter-propagasi

## Cara Generate SHA-1 Fingerprint (Jika Dibutuhkan)

### Untuk Debug Key (Development)
```bash
# Windows (PowerShell)
cd $env:USERPROFILE\.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
cd ~/.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android
```

### Untuk Release Key (Production)
```bash
keytool -list -v -keystore path/to/your/release.keystore -alias your_alias_name
```

## Verifikasi Setelah Setup

1. **Clean dan rebuild** aplikasi:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Cek log** untuk memastikan tidak ada lagi error authorization

3. **Test Google Maps** di aplikasi

## Troubleshooting

### Jika Maps masih tidak muncul:
1. Pastikan **internet permission** ada di AndroidManifest.xml ✅
2. Pastikan **location permissions** ada ✅
3. Pastikan API key benar di AndroidManifest.xml ✅
4. Tunggu 5-10 menit setelah save changes di Cloud Console
5. Restart aplikasi dan device

### Jika error "Maps SDK for Android not enabled":
1. Enable Maps SDK for Android di Cloud Console
2. Tunggu beberapa menit
3. Restart aplikasi

### Jika SHA-1 fingerprint tidak cocok:
1. Generate SHA-1 fingerprint baru dengan command di atas
2. Update di Cloud Console
3. Save dan tunggu propagasi

## Status Saat Ini

✅ API Key sudah dikonfigurasi di AndroidManifest.xml
✅ Permissions sudah ditambahkan (INTERNET, ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION)
✅ Maps implementation sudah benar di code
✅ Error handling untuk lokasi sudah ditambahkan
✅ UI feedback dan loading states sudah diperbaiki
✅ Debug information sudah ditambahkan ke AppBar
✅ Fallback location untuk Jakarta sudah tersedia
❌ **API Key belum dikonfigurasi dengan benar di Google Cloud Console**

**Next Action**: Ikuti steps di atas untuk mengkonfigurasi API key di Google Cloud Console.

## Update Terakhir

### Perbaikan yang Sudah Dilakukan:
1. **Enhanced Error Handling**: Lokasi dengan pesan error yang jelas
2. **User Feedback**: SnackBar notifications untuk status lokasi
3. **Fallback Location**: Default ke Jakarta jika GPS gagal
4. **Debug Info**: Koordinat lokasi ditampilkan di AppBar
5. **Loading UI**: Loading indicator dengan pesan informatif
6. **Map Options**: Kontrol gesture dan zoom yang lebih baik

### Log Error Terbaru:
```
E/Google Android Maps SDK( 4838): Authorization failure
API Key: AIzaSyCnRajnzDRfLclTR2Jn7S_8ANpHHvxkEf4
SHA-1 Fingerprint: A1:C8:8F:5B:5F:B6:C5:D7:EA:CD:A8:18:95:43:ED:09:EA:94:42:26
Package Name: com.example.boss_kost
```

**Solusi Immediate**: Copy SHA-1 fingerprint dan package name di atas ke Google Cloud Console.
