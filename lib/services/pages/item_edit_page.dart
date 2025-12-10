import 'package:flutter/material.dart';
import '../item_service.dart';

class EditItemPage extends StatefulWidget {
  final int itemId;
  final String token;

  const EditItemPage({required this.itemId, required this.token});

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late ItemService itemService;

  TextEditingController skuC = TextEditingController();
  TextEditingController barcodeC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController stockMinC = TextEditingController();

  int? selectedSupplier;
  int? selectedCategory;
  int? selectedUnit;

  List suppliers = [];
  List categories = [];
  List units = [];

  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    itemService = ItemService(widget.token);
    loadData();
  }

  Future<void> loadData() async {
    try {
      print("GET DETAIL ITEM...");
      final item = await itemService.getItemDetail(widget.itemId);
      print("ITEM DETAIL: $item");

      skuC.text = item['sku'] ?? "";
      barcodeC.text = item['barcode'] ?? "";
      nameC.text = item['name'] ?? "";
      stockMinC.text = item['stock_minimum']?.toString() ?? "";

      selectedSupplier = item['supplier_id'];
      selectedCategory = item['category_id'];
      selectedUnit = item['unit_id'];

      print("GET SUPPLIERS...");
      suppliers = await itemService.getDropdown("suppliers");
      print("SUPPLIERS: $suppliers");

      print("GET CATEGORIES...");
      categories = await itemService.getDropdown("categories");
      print("CATEGORIES: $categories");

      print("GET UNITS...");
      units = await itemService.getDropdown("units");
      print("UNITS: $units");

      setState(() {
        loading = false;
      });
    } catch (e) {
      print("====================");
      print("ERROR LOAD DATA:");
      print(e);
      print("====================");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void saveItem() async {
    setState(() => saving = true);

    final body = {
      "sku": skuC.text,
      "barcode": barcodeC.text,
      "name": nameC.text,
      "stock_minimum": int.tryParse(stockMinC.text) ?? 0,
      "supplier_id": selectedSupplier,
      "category_id": selectedCategory,
      "unit_id": selectedUnit,
    };

    final ok = await itemService.updateItem(widget.itemId, body);

    setState(() => saving = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text("Item berhasil diupdate!"),
            ],
          ),
          backgroundColor: Colors.green[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 8),
              Text("Gagal update item"),
            ],
          ),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
              SizedBox(height: 16),
              Text(
                "Memuat data...",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[700]!, Colors.blue[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          "Edit Item",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Basic Information Card
          _buildSectionCard(
            title: "Informasi Dasar",
            icon: Icons.info_outline,
            children: [
              _buildTextField(
                controller: skuC,
                label: "SKU",
                icon: Icons.qr_code,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: barcodeC,
                label: "Barcode",
                icon: Icons.barcode_reader,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: nameC,
                label: "Nama Item",
                icon: Icons.inventory_2,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: stockMinC,
                label: "Stock Minimum",
                icon: Icons.warehouse,
                keyboardType: TextInputType.number,
              ),
            ],
          ),

          SizedBox(height: 16),

          // Dropdown Section Card
          _buildSectionCard(
            title: "Kategori & Detail",
            icon: Icons.category,
            children: [
              _buildDropdown(
                label: "Supplier",
                icon: Icons.local_shipping,
                value: selectedSupplier,
                items: suppliers,
                onChanged: (v) => setState(() => selectedSupplier = v as int?),
              ),
              SizedBox(height: 16),
              _buildDropdown(
                label: "Category",
                icon: Icons.category_outlined,
                value: selectedCategory,
                items: categories,
                onChanged: (v) => setState(() => selectedCategory = v as int?),
              ),
              SizedBox(height: 16),
              _buildDropdown(
                label: "Unit",
                icon: Icons.straighten,
                value: selectedUnit,
                items: units,
                onChanged: (v) => setState(() => selectedUnit = v as int?),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Save Button
          Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[600]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: saving ? null : saveItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: saving
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.save, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Simpan Perubahan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.blue[700], size: 20),
                ),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required int? value,
    required List items,
    required Function(dynamic) onChanged,
  }) {
    return DropdownButtonFormField(
      value: value,
      items: items
          .map(
            (item) =>
                DropdownMenuItem(value: item['id'], child: Text(item['name'])),
          )
          .toList(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
