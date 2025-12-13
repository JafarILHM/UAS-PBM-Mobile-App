import 'package:flutter/material.dart';
import '../stock_service.dart';

class TransaksiGudangPage extends StatefulWidget {
  final String token;
  const TransaksiGudangPage({super.key, required this.token});

  @override
  State<TransaksiGudangPage> createState() => _TransaksiGudangPageState();
}

class _TransaksiGudangPageState extends State<TransaksiGudangPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late StockService service;

  List<dynamic> items = [];
  List<dynamic> batches = [];

  String? selectedItemIdentifier;
  int? selectedBatchId;

  int currentStock = 0;

  final qtyCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    service = StockService(widget.token);
    _tabController = TabController(length: 2, vsync: this);
    loadItems();
  }

  Future<void> loadItems() async {
    final data = await service.fetchItems();
    setState(() => items = data);
  }

  void onSelectItem(dynamic item) {
    setState(() {
      selectedItemIdentifier = item['sku'];
      batches = item['item_batches'] ?? [];
      selectedBatchId = null;
      currentStock = item['stock'];
    });
  }

  void onSelectBatch(int? batchId) {
    if (batchId == null) return;

    final batch = batches.firstWhere((b) => b['id'] == batchId);
    setState(() {
      selectedBatchId = batchId;
      currentStock = batch['quantity'];
    });
  }

  Future<void> simpan() async {
    final qty = int.tryParse(qtyCtrl.text);

    if (selectedItemIdentifier == null || qty == null || qty <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Data belum lengkap")));
      return;
    }

    setState(() => loading = true);

    bool success;

    if (_tabController.index == 0) {
      // BARANG MASUK
      success = await service.barangMasuk(
        itemIdentifier: selectedItemIdentifier!,
        batchNumber: noteCtrl.text.isEmpty ? "DEFAULT" : noteCtrl.text,
        qty: qty,
      );
    } else {
      if (selectedBatchId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pilih batch terlebih dahulu")),
        );
        setState(() => loading = false);
        return;
      }

      success = await service.barangKeluar(
        itemIdentifier: selectedItemIdentifier!,
        itemBatchId: selectedBatchId!,
        qty: qty,
        purpose: noteCtrl.text,
      );
    }

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Transaksi berhasil" : "Transaksi gagal"),
      ),
    );

    if (success) {
      qtyCtrl.clear();
      noteCtrl.clear();
      loadItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaksi Gudang"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Barang Masuk"),
            Tab(text: "Barang Keluar"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ITEM
            DropdownButtonFormField<dynamic>(
              hint: const Text("Pilih Item"),
              items: items
                  .map(
                    (i) => DropdownMenuItem(value: i, child: Text(i['name'])),
                  )
                  .toList(),
              onChanged: onSelectItem,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 12),

            // BATCH (KHUSUS BARANG KELUAR)
            if (_tabController.index == 1)
              DropdownButtonFormField<int>(
                hint: const Text("Pilih Batch"),
                items: batches
                    .map(
                      (b) => DropdownMenuItem<int>(
                        value: b['id'],
                        child: Text(
                          "Batch ${b['batch_number']} (Stok ${b['quantity']})",
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onSelectBatch,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),

            const SizedBox(height: 12),

            Text(
              "Stok tersedia: $currentStock",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: qtyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Qty",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: noteCtrl,
              decoration: InputDecoration(
                labelText: _tabController.index == 0
                    ? "Batch Number"
                    : "Tujuan",
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: loading ? null : simpan,
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Simpan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
