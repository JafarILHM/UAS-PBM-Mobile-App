import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/supplier_provider.dart';
import '../core/theme.dart';
import '../models/supplier_model.dart';

class SupplierFormPage extends StatefulWidget {
  final Supplier? supplier; 

  const SupplierFormPage({super.key, this.supplier});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _nameController.text = widget.supplier!.name;
      _contactController.text = widget.supplier!.contact ?? "";
      _addressController.text = widget.supplier!.address ?? "";
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    final provider = Provider.of<SupplierProvider>(context, listen: false);
    
    // Buat objek dari inputan
    final data = Supplier(
      id: widget.supplier?.id ?? 0, 
      name: _nameController.text,
      contact: _contactController.text,
      address: _addressController.text,
    );

    bool success;
    if (widget.supplier == null) {
      success = await provider.addSupplier(data);
    } else {
      success = await provider.updateSupplier(data);
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil disimpan"), backgroundColor: AdminKitTheme.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.supplier == null ? "Tambah Supplier" : "Edit Supplier";

    return MainLayout(
      title: title,
      body: AdminCard(
        title: "Form Supplier",
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAMA
              _buildInput("Nama Supplier", _nameController, true),
              const SizedBox(height: 16),
              
              // KONTAK
              _buildInput("Kontak (HP/Telp)", _contactController, false),
              const SizedBox(height: 16),
              
              // ALAMAT
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Alamat", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3, 
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // TOMBOL AKSI
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal", style: TextStyle(color: AdminKitTheme.secondary)),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminKitTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Simpan"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget agar kode tidak berulang
  Widget _buildInput(String label, TextEditingController controller, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          validator: (val) {
            if (isRequired && (val == null || val.isEmpty)) {
              return "$label wajib diisi";
            }
            return null;
          },
        ),
      ],
    );
  }
}