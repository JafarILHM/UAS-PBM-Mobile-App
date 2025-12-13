import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final barang = FirebaseFirestore.instance.collection("barang");
  final transaksi = FirebaseFirestore.instance.collection("transaksi");

  Future<void> addBarangMasuk(Map<String, dynamic> data) async {
    await transaksi.add(data);
    await barang.doc(data["sku"]).set({
      "sku": data["sku"],
      "nama": data["nama"],
      "availableStock": FieldValue.increment(data["qty"]),
    }, SetOptions(merge: true));
  }

  Future<void> addBarangKeluar(Map<String, dynamic> data) async {
    await transaksi.add(data);
    await barang.doc(data["sku"]).update({
      "availableStock": FieldValue.increment(-data["qty"]),
    });
  }

  Future<void> bookingStok(String sku, int qty) async {
    final doc = await barang.doc(sku).get();
    final available = doc["availableStock"];

    if (available < qty) throw Exception("Stok tidak cukup!");

    await barang.doc(sku).update({
      "availableStock": available - qty,
      "bookedStock": (doc["bookedStock"] ?? 0) + qty,
    });
  }

  Future<List<Map<String, dynamic>>> getAllBarang() async {
    final data = await barang.get();
    return data.docs.map((d) => d.data()).toList();
  }
}

final db = FirestoreService();
