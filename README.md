# MOPROG - Aplikasi Mobile Multiplatform dengan Flutter

## Tentang Proyek

Proyek MOPROG adalah tugas semester untuk mata kuliah Mobile Programming. Repository ini khusus untuk versi multiplatform yang dikembangkan menggunakan Flutter.

## Struktur Branch

Proyek ini menggunakan struktur branch berikut untuk pengembangan:

- `main`: Branch produksi yang stabil
- `development`: Branch untuk integrasi fitur sebelum dirilis ke `main`
- `features/xxx`: Branch untuk pengembangan fitur individual

## Alur Kerja

Setiap developer bekerja pada branch `features/xxx` masing-masing, di mana `xxx` adalah nama fitur yang sedang dikembangkan. Alur kerja pengembangan:

1. Buat branch baru dari `development` dengan format `features/nama-fitur`
2. Kembangkan fitur di branch tersebut
3. Setelah selesai, buat Pull Request ke branch `development`
4. Setelah semua fitur terintegrasi di `development` dan teruji dengan baik, akan dilakukan Pull Request ke branch `main`

## Cara Menjalankan Proyek

### Prasyarat

- Flutter SDK (versi terbaru)
- Android Studio / VS Code
- Emulator atau perangkat fisik untuk pengujian

### Langkah-langkah

1. Clone repository
   ```
   git clone https://github.com/andreasmlbngaol/moprog.git
   ```

2. Masuk ke direktori proyek
   ```
   cd moprog
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Jalankan aplikasi
   ```
   flutter run
   ```

## Kontributor

- [Andreas M Lbn Gaol](https://github.com/andreasmlbngaol)
- [Bintang Aulia](https://github.com/BintangAull)
- [Clara Angelin Pijoh](https://github.com/indomiekwah)