# 🏭 Aplikasi Manajemen Gudang (Warehouse Management System)

Aplikasi Manajemen Gudang adalah aplikasi **berbasis mobile** yang dikembangkan menggunakan **Flutter** sebagai frontend dan **Laravel REST API** sebagai backend, dengan **MySQL** sebagai basis data. Aplikasi ini bertujuan untuk membantu proses pengelolaan gudang secara digital, terstruktur, dan real-time, mencakup pengelolaan data barang, transaksi barang masuk dan keluar, serta manajemen pengguna berdasarkan hak akses.

Project ini dikembangkan sebagai **Ujian Akhir Semester (UAS)** mata kuliah **Pemrograman Berbasis Mobile** Program Studi Informatika.

---

## 📌 Fitur Utama

* Autentikasi pengguna (Login & Logout)
* Manajemen pengguna (Admin & Staff)
* CRUD Data Master:

  * Barang
  * Kategori
  * Supplier
  * Satuan
* Transaksi Barang Masuk (Incoming)
* Transaksi Barang Keluar (Outgoing)
* Update stok otomatis
* Dashboard ringkasan stok
* Riwayat seluruh transaksi
* Export data ke Excel
* Role-based access control (Admin & Staff)

---

## 🧱 Tech Stack

### Mobile (Frontend)

* Flutter (Dart)
* Provider (State Management)
* REST API (JSON)

### Backend (API)

* Laravel Framework
* Laravel Sanctum (Authentication)
* PHP

### Database

* MySQL

---

## 🗂️ Arsitektur Sistem

Aplikasi menggunakan arsitektur **Client–Server** dengan REST API:

```
Flutter Mobile App
        │
        │ HTTP (JSON)
        ▼
Laravel REST API
        │
        ▼
      MySQL
```

---

## 🚀 Instalasi & Konfigurasi

### 🔧 Backend (Laravel API)

1. Clone repository backend:

```bash
git clone https://github.com/JafarILHM/UAS-PBM-Website.git
cd UAS-PBM-Website
```

2. Install dependency:

```bash
composer install
```

3. Copy file environment:

```bash
cp .env.example .env
```

4. Konfigurasi database di file `.env`:

```env
DB_DATABASE=nama_database
DB_USERNAME=root
DB_PASSWORD=
```

5. Generate key & migrate database:

```bash
php artisan key:generate
php artisan migrate --seed
```

6. Jalankan server:

```bash
php artisan serve
```

---

### 📱 Frontend (Flutter Mobile App)

1. Clone repository Flutter:

```bash
git clone https://github.com/JafarILHM/UAS-PBM-Mobile-App.git
cd UAS-PBM-Mobile-App
```

2. Install dependency:

```bash
flutter pub get
```

3. Konfigurasi base URL API pada file:

```
lib/core/api_config.dart
```

4. Jalankan aplikasi:

```bash
flutter run
```

---

## 🔗 Endpoint API Utama

| Method | Endpoint          | Deskripsi               |
| ------ | ----------------- | ----------------------- |
| POST   | /api/login        | Login pengguna          |
| POST   | /api/logout       | Logout pengguna         |
| GET    | /api/user         | Data user login         |
| GET    | /api/dashboard    | Ringkasan dashboard     |
| GET    | /api/items        | Data barang             |
| POST   | /api/items        | Tambah barang           |
| PUT    | /api/items/{id}   | Update barang           |
| POST   | /api/incoming     | Transaksi barang masuk  |
| POST   | /api/outgoing     | Transaksi barang keluar |
| GET    | /api/transactions | Riwayat transaksi       |

---

## 🗄️ Struktur Database (Ringkas)

* users
* items
* categories
* suppliers
* units
* incoming_items
* outgoing_items

Relasi database dirancang untuk mendukung update stok otomatis dan pencatatan histori transaksi.

---

## 👥 Hak Akses Pengguna

### 👑 Admin (Kepala Gudang)

* Akses penuh ke seluruh fitur
* Manajemen akun pengguna
* Monitoring transaksi & stok

### 👷 Staff Gudang

* CRUD data master
* Input barang masuk & keluar
* Tidak dapat mengelola akun pengguna

---

## 👤 Tim Pengembang

**Kelompok Sekawan Enem – Informatika 5E**

* Raffi Naufal Fahreza
* Akbar Putra Wiratama
* Fathir Ilham Hendri
* Wahyu Setya Aji
* Jafaruddin Ilham
* Ridwan Nursamsi

---

## 📄 Lisensi

Project ini dibuat untuk keperluan akademik (UAS).

---

✨ *Aplikasi Manajemen Gudang – Flutter × Laravel × MySQL*
