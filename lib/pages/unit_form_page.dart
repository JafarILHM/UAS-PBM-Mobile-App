import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_layout.dart';
import '../widgets/admin_card.dart';
import '../providers/unit_provider.dart';
import '../core/theme.dart';
import '../models/unit_model.dart';

class UnitFormPage extends StatefulWidget {
  final Unit? unit;

  const UnitFormPage({super.key, this.unit});

  @override
  State<UnitFormPage> createState() => _UnitFormPageState();
}

class _UnitFormPageState extends State<UnitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _symbolController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.unit != null) {
      _nameController.text = widget.unit!.name;
      _symbolController.text = widget.unit!.symbol;
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final provider = Provider.of<UnitProvider>(context, listen: false);
    final data = Unit(
      id: widget.unit?.id ?? 0,
      name: _nameController.text,
      symbol: _symbolController.text,
    );

    bool success;
    if (widget.unit == null) {
      success = await provider.addUnit(data);
    } else {
      success = await provider.updateUnit(data);
    }

    setState(() => _isSaving = false);
    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data berhasil disimpan"),
          backgroundColor: AdminKitTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.unit == null ? "Tambah Satuan" : "Edit Satuan";

    return MainLayout(
      title: title,
      body: AdminCard(
        title: "Form Satuan",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInput("Nama Satuan", _nameController, "Contoh: Kilogram"),
              const SizedBox(height: 16),
              _buildInput(
                "Simbol / Singkatan",
                _symbolController,
                "Contoh: kg",
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Batal",
                      style: TextStyle(color: AdminKitTheme.secondary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AdminKitTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text("Simpan"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
    String label,
    TextEditingController controller,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          validator: (val) => val == null || val.isEmpty ? "Wajib diisi" : null,
        ),
      ],
    );
  }
}
